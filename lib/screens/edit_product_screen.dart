import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/models/product.dart';
import 'package:shoppingapp/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/add_product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  var initValues = {
    'title': '',
    'description': '',
    'price': '',
  };

  late TextEditingController _imageUrlController = TextEditingController();
  FocusNode _imageUrlFocusNode = FocusNode();

  bool isDependenciesLoaded = false;

  var _editProduct = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0.0,
  );

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    if (!isDependenciesLoaded) {
      var args = ModalRoute.of(context)!.settings.arguments;
      String productId = args != null ? args as String : '';

      if (productId.isNotEmpty) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        setState(() {
          initValues = {
            'title': _editProduct.title,
            'description': _editProduct.description,
            'price': _editProduct.price.toString(),
          };
          _imageUrlController.text = _editProduct.imageUrl;
        });
      }

      isDependenciesLoaded = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    if ((!_imageUrlFocusNode.hasFocus &&
            (_imageUrlController.text.startsWith('http')) &&
            (_imageUrlController.text.endsWith('png') &&
                !_imageUrlController.text.endsWith('jpg') &&
                !_imageUrlController.text.endsWith('jpeg'))) ||
        _imageUrlController.text.isEmpty) setState(() {});
  }

  void _saveForm() {
    var validated = _formKey.currentState?.validate();
    if (!validated!) return null;
    _formKey.currentState?.save();

    if (_editProduct.id != null || _editProduct.id.isNotEmpty)
      Provider.of<Products>(context, listen: false).addProduct(_editProduct);
    else
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [
            IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  initialValue: initValues['title'],
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => _editProduct = Product(
                    id: _editProduct.id,
                    title: value!,
                    description: _editProduct.description,
                    price: _editProduct.price,
                    imageUrl: _editProduct.imageUrl,
                    isFavourite: _editProduct.isFavourite,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please provide a value.';
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  initialValue: initValues['price'],
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => _editProduct = Product(
                    id: _editProduct.id,
                    title: _editProduct.title,
                    description: _editProduct.description,
                    price: double.parse(value!),
                    imageUrl: _editProduct.imageUrl,
                    isFavourite: _editProduct.isFavourite,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return "Please provide a value.";
                    if (double.tryParse(value) == null)
                      return "Please enter a valid number";
                    if (double.parse(value) <= 0.0)
                      return "Please enter value greater than zero";
                    return null;
                  },
                ),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  initialValue: initValues['description'],
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) => _editProduct = Product(
                    id: _editProduct.id,
                    title: _editProduct.title,
                    description: value!,
                    price: _editProduct.price,
                    imageUrl: _editProduct.imageUrl,
                    isFavourite: _editProduct.isFavourite,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter a description';
                    if (value.length <= 10)
                      return 'Should be atleast 10 characters long';
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(top: 20, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Center(
                              child: Text(
                                'Enter a Url',
                              ),
                            )
                          : FittedBox(
                              child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            )),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        decoration: InputDecoration(labelText: 'Image Url'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _saveForm(),
                        onEditingComplete: () {
                          print(_imageUrlController.text);
                          setState(() {});
                        },
                        onSaved: (value) => _editProduct = Product(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: _editProduct.description,
                          price: _editProduct.price,
                          imageUrl: value!,
                          isFavourite: _editProduct.isFavourite,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter a image url';
                          if (!value.startsWith('http'))
                            return 'Please enter a valid url';
                          if (!value.endsWith('png') &&
                              !value.endsWith('jpg') &&
                              !value.endsWith('jpeg'))
                            return 'Please enter a valid image url';
                          return null;
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

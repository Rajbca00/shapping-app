import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/providers/products_provider.dart';
import 'package:shoppingapp/widgets/mainDrawer.dart';
import 'package:shoppingapp/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsController = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsController.items.length,
          itemBuilder: (ctx, index) => UserProductItem(
            id: productsController.items[index].id,
            imageUrl: productsController.items[index].imageUrl,
            title: productsController.items[index].title,
          ),
        ),
      ),
    );
  }
}

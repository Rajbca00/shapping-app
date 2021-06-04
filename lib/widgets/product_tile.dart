import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/models/cart.dart';
import 'package:shoppingapp/models/product.dart';
import 'package:shoppingapp/screens/product_details_screen.dart';

class ProductTile extends StatelessWidget {
  // final String productId;
  // final String productTitle;
  // final String productImageUrl;

  // ProductTile({
  //   required this.productId,
  //   required this.productTitle,
  //   required this.productImageUrl,
  // });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            leading: Consumer<Product>(
              builder: (ctx, value, child) => IconButton(
                onPressed: product.toggleFavorite,
                icon: product.isFavourite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border_outlined),
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
              },
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
            ),
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

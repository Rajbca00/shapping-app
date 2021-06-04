import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/models/cart.dart';
import 'package:shoppingapp/screens/cart_screen.dart';
import 'package:shoppingapp/widgets/badge.dart';
import 'package:shoppingapp/widgets/mainDrawer.dart';
import '../providers/products_provider.dart';
import '../widgets/product_gridview.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoriteOnly = false;

  void updateFavouriteOnly(bool val) {
    setState(() {
      _showFavoriteOnly = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                selectedValue == FilterOptions.Favorites
                    ? updateFavouriteOnly(true)
                    : updateFavouriteOnly(false);
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOptions.Favorites),
                    PopupMenuItem(
                        child: Text('Show All'), value: FilterOptions.All),
                  ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<Cart>(
              builder: (ctx, cart, ch) {
                return Badge(
                  child: ch!,
                  color: Colors.red,
                  value: cart.itemCount.toString(),
                );
              },
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: ProductsGridView(_showFavoriteOnly),
    );
  }
}

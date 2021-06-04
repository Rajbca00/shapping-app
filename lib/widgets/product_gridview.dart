import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'product_tile.dart';

class ProductsGridView extends StatelessWidget {
  final _showFavoritesOnly;

  ProductsGridView(this._showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    final providerContainer = Provider.of<Products>(context);
    final dummyProducts = _showFavoritesOnly
        ? providerContainer.favouriteItems
        : providerContainer.items;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: dummyProducts.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: dummyProducts[index],
              child: ProductTile(),
            ));
  }
}

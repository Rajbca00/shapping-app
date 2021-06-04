import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/models/cart.dart';
import 'package:shoppingapp/models/order.dart';
import 'package:shoppingapp/widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<Cart>(context);

    final cartItemValues = cartController.items.values.toList();
    final cartItemKeys = cartController.items.keys.toList();

    final cartTotal = cartController.cartTotal;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total ',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$$cartTotal',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              ?.color),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Order>(context, listen: false)
                          .addOrder(cartItemValues, cartTotal);
                      cartController.clearCart();
                    },
                    child: Text(
                      'ORDER NOW',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              )),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartController.itemCount,
            itemBuilder: (ctx, index) => CartItemTile(
              id: cartItemValues[index].id,
              price: cartItemValues[index].price,
              quantity: cartItemValues[index].quantity,
              title: cartItemValues[index].title,
              productId: cartItemKeys[index],
            ),
          ),
        )
      ]),
    );
  }
}

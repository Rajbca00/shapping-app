import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/models/order.dart';
import 'package:shoppingapp/widgets/mainDrawer.dart';
import 'package:shoppingapp/widgets/order_item_tile.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderController = Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: MainDrawer(),
      body: ListView.builder(
        itemCount: orderController.orderCount,
        itemBuilder: (ctx, index) {
          return OrderItemTile(orderController.orders[index]);
        },
      ),
    );
  }
}

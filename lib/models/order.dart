import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shoppingapp/models/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.datetime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get orderCount {
    return _orders.length;
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItem(
            id: UniqueKey().toString(),
            amount: total,
            datetime: DateTime.now(),
            products: cartProducts));

    notifyListeners();
  }
}

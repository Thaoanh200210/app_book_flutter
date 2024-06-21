import '../../models/cart_item.dart';
import '../../models/order_item.dart';
import 'package:flutter/foundation.dart';
import '../../services/orders_service.dart';
import '../../models/auth_token.dart';


class OrderManager extends ChangeNotifier {
  List<OrderItem> _orders = [];
  final OrderService _orderService;

  OrderManager([AuthToken? authToken])
      : _orderService = OrderService(authToken);

  set authToken(AuthToken? authToken) {
    _orderService.authToken = authToken;
  }

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    _orders = await _orderService.fetchOrders();

    notifyListeners();
  }

  Future<void> addOrder(OrderItem order) async {
    final newOrder = await _orderService.addOrder(order);

    if (newOrder != null) {
      _orders.add(newOrder);

    }

    notifyListeners();
  }
}

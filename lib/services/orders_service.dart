import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/auth_token.dart';
import 'dart:convert';
import '../models/order_item.dart';
import 'firebase_service.dart';

class OrderService extends FirebaseService {
  OrderService([AuthToken? authToken]) : super(authToken);

  Future<List<OrderItem>> fetchOrders() async {
    List<OrderItem> orders = [];
    try {
      final ordersMap =
          await httpFetch('$databaseUrl/orders/$userId.json?auth=$token')
              as Map<String, dynamic>?;

      ordersMap?.forEach((orderId, order) {
        orders.add(OrderItem.fromJson({'id': orderId, ...order}));
      });

      return orders;
    } catch (error) {
      print(error);
      return orders;
    }
  }

  Future<OrderItem?> addOrder(OrderItem order) async {
    try {
      print(order.dateTime);
      Map<String, dynamic> newOrder = await httpFetch(
          '$databaseUrl/orders/$userId.json?auth=$token',
          method: HttpMethod.post,
          body: jsonEncode(order.toJson()));
      print(order);
      return OrderItem.fromJson({'id': newOrder['name'], ...order.toJson()});
    } catch (error) {
      print(error);
      return null;
    }
  }
}

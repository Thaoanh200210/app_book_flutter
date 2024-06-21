import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/auth_token.dart';
import 'dart:convert';
import '../models/cart_item.dart';
import 'firebase_service.dart';

class CartService extends FirebaseService {
  CartService([AuthToken? authToken]) : super(authToken);

  Future<Map<String, CartItem>> getCart() async {
    Map<String, CartItem> cart = {};

    try {
      final cartMap =
          await httpFetch('$databaseUrl/carts/$userId.json?auth=$token')
              as Map<String, dynamic>?;

      cartMap?.forEach((bookId, cartItem) {
        cart.addEntries({bookId: CartItem.fromJson(cartItem)}.entries);
      });

      return cart;
    } catch (error) {
      print(error);
      return cart;
    }
  }

  Future<bool> addItem(String bookId, CartItem cartItem) async {
    try {
      await httpFetch('$databaseUrl/carts/$userId/$bookId.json?auth=$token',
          method: HttpMethod.put, body: jsonEncode(cartItem.toJson()));

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> updateItem(String bookId, num quantity) async {
    try {
      await httpFetch('$databaseUrl/carts/$userId/$bookId.json?auth=$token',
          method: HttpMethod.patch, body: jsonEncode({'quantity': quantity}));

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> removeItem(String bookId) async {
    try {
      await httpFetch(
        '$databaseUrl/carts/$userId/$bookId.json?auth=$token',
        method: HttpMethod.delete,
      );

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> clearCart() async {
    try {
      await httpFetch(
        '$databaseUrl/carts/$userId.json?auth=$token',
        method: HttpMethod.delete,
      );

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

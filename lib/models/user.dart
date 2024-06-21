import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myshop/models/cart_item.dart';

class User {
  final String? id;
  final String email;
  final String name;
  final String address;
  final String phone;
  final bool isAdmin;

  User(
      {this.id,
        required this.email,
        required this.name,
        required this.address,
        required this.phone,
        this.isAdmin = false});

  toJson() {
    return {
      'email': email,
      'name': name,
      'address': address,
      'phone': phone,
      'isAdmin': isAdmin,
    };
  }

  static fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        address: json['address'],
        phone: json['phone'],
        isAdmin: json['isAdmin']);
  }

  User copyWith(
      {String? id,
        String? email,
        String? name,
        String? address,
        String? phone,
        bool? isAdmin}) {
    return User(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        isAdmin: isAdmin ?? this.isAdmin);
  }
}

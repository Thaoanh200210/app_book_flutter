import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Book {
  final String? id; //id=null
  final String title;
  final String description;
  final String author;
  final String category;
  final int price;
  final int quantity;
  final String imageUrl;
  final ValueNotifier<bool> _isFavorite;

  Book({
    this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.category,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    isFavorite = false,
  }) : _isFavorite = ValueNotifier(isFavorite);

  set isFavorite(bool newValue) {
    _isFavorite.value = newValue;
  }

  bool get isFavorite {
    return _isFavorite.value;
  }

  ValueNotifier<bool> get isFavoriteListenable {
    return _isFavorite;
  }

  Book copyWith({
    String? id,
    String? title,
    String? description,
    String? author,
    String? category,
    int? price,
    int? quantity,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'category': category,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  static Book fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      category: json['category'],
      quantity: json['quantity'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }
}

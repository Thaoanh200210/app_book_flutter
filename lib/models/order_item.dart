import 'dart:convert';

import 'cart_item.dart';

class OrderItem {
  final String? id; //id=null
  final int amount;
  final List<CartItem> books;

  final DateTime dateTime;

  int get bookCount {
    return books.length;
  }

  OrderItem({
    this.id,
    required this.amount,
    required this.books,

    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  OrderItem copyWith(
      {String? id, int? amount, List<CartItem>? books, DateTime? dateTime,Map<String, DateTime?>? status}) {
    return OrderItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      books: books ?? this.books,

      dateTime: dateTime ?? this.dateTime,
    );
  }

   toJson() {
    return {
      'amount': amount,
      'books': jsonEncode(books),

      'dateTime': dateTime.toString(),
    };
  }

  static fromJson(Map<String, dynamic> json) {
    final books = jsonDecode(json['books']) as List<dynamic>;
    return OrderItem(
      id: json['id'],
      amount: json['amount'],

        books:
            books.map((book) => CartItem.fromJson(book)).toList(),
        dateTime: DateTime.parse(json['dateTime'])
    );
  }
}

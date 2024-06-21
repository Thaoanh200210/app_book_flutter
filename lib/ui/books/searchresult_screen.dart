import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/book.dart';
import 'book_detail_screen.dart';

class SearchResultScreen extends StatelessWidget {
  static const routeName = '/search_result';
  final List<Book> searchResult;

  const SearchResultScreen({Key? key, required this.searchResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả tìm kiếm'),
      ),
      body: searchResult.isEmpty
          ? Center(
        child: Text(
          'Không Tìm Thấy Sách',
          style: TextStyle(fontSize: 28),
        ),
      )
          : ListView.builder(
        itemCount: searchResult.length,
        itemBuilder: (context, index) {
          final book = searchResult[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            leading: Image.network(
              book.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                BookDetailScreen.routeName,
                arguments: book.id,
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'books_manager.dart';
import 'book_grid_tile.dart';
import '../../models/book.dart';
import 'package:provider/provider.dart';

class BookGrid extends StatelessWidget {
  final bool showFavorites;

  const BookGrid(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final books = context.select<BooksManager, List<Book>>((booksManager) =>
        showFavorites ? booksManager.favoriteItems : booksManager.items);
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: books.length,
      itemBuilder: (ctx, i) => BookGridTile(books[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myshop/ui/books/book_detail_screen.dart';
import '../../models/book.dart';
import 'package:provider/provider.dart';
import '../cart/cart_manager.dart';
import 'books_manager.dart';

class BookGridTile extends StatelessWidget {
  const BookGridTile(
    this.book, {
    super.key,
  });
  final Book book;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          BookDetailScreen.routeName,
          arguments: book.id,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Image.network(
            book.imageUrl,
            fit: BoxFit.cover,

          ),
          footer: Container(
            color: Colors.black.withOpacity(0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: ValueListenableBuilder<bool>(
                    valueListenable: book.isFavoriteListenable,
                    builder: (context, isFavorite, child) {
                      return Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Theme.of(context).colorScheme.secondary,
                      );
                    },
                  ),
                  onPressed: () {
                    context.read<BooksManager>().toggleFavoriteStatus(book);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
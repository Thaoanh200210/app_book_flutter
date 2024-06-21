import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/book.dart';
import 'edit_book_screen.dart';
import 'books_manager.dart';
import 'package:provider/provider.dart';



class UserBookListTile extends StatelessWidget {
  final Book book;

  const UserBookListTile(this.book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(book.imageUrl),
        ),
        title: Text(
          book.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          // '${book.price} vnđ',
          'Giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(book.price)}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditBookScreen.routeName,
                    arguments: book.id,
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Xác nhận'),
                      content: Text('Bạn có chắc chắn muốn xóa cuốn sách này không?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: Text('Không'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<BooksManager>().deleteBook(book.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Sách đã được xóa',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                            Navigator.of(ctx).pop(true);
                          },
                          child: Text('Có'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DeleteUserBookButton extends StatelessWidget {
  const DeleteUserBookButton({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.error,
    );
  }
}

class EditUserBookButton extends StatelessWidget {
  const EditUserBookButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

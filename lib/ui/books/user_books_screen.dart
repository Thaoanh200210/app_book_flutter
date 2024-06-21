import 'package:flutter/material.dart';
import '../screens.dart';
import 'user_book_list_tile.dart';
import 'books_manager.dart';
import 'edit_book_screen.dart';
import '../shared/app_drawer.dart';
import 'package:provider/provider.dart';

class UserBooksScreen extends StatelessWidget {
  static const routeName = '/user-books';
  const UserBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sách'),
        actions: <Widget>[

            HomeButton(
              onPressed: () {
                // Chuyển đến trang Home
                Navigator.of(context).pushNamed('/');
              },
            ),

          AddUserBookButton(
            onPressed: () {
              // Chuyển đến trang EditBookScreen
              Navigator.of(context).pushNamed(
                EditBookScreen.routeName,
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: context.read<BooksManager>().fetchUserBooks(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ctx.read<BooksManager>().fetchUserBooks(),
            child: const UserBookList(),
          );
        },
      ),
    );
  }
}

class UserBookList extends StatelessWidget {
  const UserBookList({super.key});

  @override
  Widget build(BuildContext context) {
    final booksManager = BooksManager();
// Dùng Consumer để truy xuất và lắng nghe báo hiệu
// thay đổi trạng thái từ BooksManager
    return Consumer<BooksManager>(
      builder: (ctx, booksManager, child) {
        return ListView.builder(
          itemCount: booksManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              UserBookListTile(
                booksManager.items[i],
              ),
              // const Divider(),
            ],
          ),
        );
      },
    );
  }
}

class AddUserBookButton extends StatelessWidget {
  const AddUserBookButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: onPressed,
    );
  }
}

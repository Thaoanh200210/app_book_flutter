
import 'package:flutter/material.dart';
import 'package:myshop/ui/books/top_right_badge.dart';
import '../../ui/books/books_grid.dart';
import '../cart/cart_manager.dart';
import '../cart/cart_screen.dart';
import '../shared/app_drawer.dart';
import '../books/books_overview_screen.dart';
enum FilterOptions { favorites , all}
class BooksOverviewScreen2 extends StatefulWidget {
  const BooksOverviewScreen2({super.key});

  @override
  State<BooksOverviewScreen2> createState() => _BooksOverviewScreen2State();
}

class _BooksOverviewScreen2State extends State<BooksOverviewScreen2> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sách Yêu Thich'),
        actions: <Widget>[

          ShoppingCartButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: const BookGrid(true),

    );
  }
}

class BookFilterMenu extends StatelessWidget {
  const BookFilterMenu({super.key,this.onFilterSelected});
  final void Function (FilterOptions selectedValue)? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: onFilterSelected,
        icon: const Icon(Icons.more_vert),
        itemBuilder: (ctx) => [
          const PopupMenuItem(
            value: FilterOptions.favorites,
            child: Text('Sách Yêu Thích'),


          ),
          const PopupMenuItem(
            value: FilterOptions.all,
            child: Text('Hiện tất cả'),

          )
        ]);
  }
}


import 'package:flutter/material.dart';
import 'package:myshop/ui/books/books_manager.dart';
import 'books_grid.dart';
import '../shared/app_drawer.dart';
import 'package:provider/provider.dart';
import '../cart/cart_manager.dart';
import 'top_right_badge.dart';
import 'book_grid_tile.dart';
import '../cart/cart_screen.dart';

enum FilterOptions { favorites, all }

class BooksOverviewScreen extends StatefulWidget {
  const BooksOverviewScreen({super.key});

  @override
  State<BooksOverviewScreen> createState() => _BooksOverviewScreenState();
}

class _BooksOverviewScreenState extends State<BooksOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchBooks;

  @override
  void initState() {
    super.initState();
    _fetchBooks = context.read<BooksManager>().fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookStore'),
        actions: <Widget>[

          ShoppingCartButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: _fetchBooks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ValueListenableBuilder<bool>(
                  valueListenable: _showOnlyFavorites,
                  builder: (context, onlyFavorites, child) {
                    return BookGrid(onlyFavorites);
                  });
            }
            return const Center(
              //vòng tròn chờ
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class BookFilterMenu extends StatelessWidget {
  const BookFilterMenu({super.key, this.onFilterSelected});

  final void Function(FilterOptions selectedValue)? onFilterSelected;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onFilterSelected,
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show All'),
        ),
      ],
    );
  }
}

class ShoppingCartButton extends StatelessWidget {
  const ShoppingCartButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    // Truy xuất CartManager thông qua widget Consumer
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
        return TopRightBadge(
          data: cartManager.bookCount,
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: onPressed,
          ),
        );
      },
    );
  }
}

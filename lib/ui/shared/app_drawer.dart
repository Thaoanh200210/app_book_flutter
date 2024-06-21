import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myshop/ui/auth/auth_manager.dart';
import '../auth/auth_manager.dart';
import '../orders/orders_screen.dart';
import '../cart/cart_screen.dart';
import '../books/user_books_screen.dart';
import '../books/find_book_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('WELCOME'),
            automaticallyImplyLeading: false,
          ),
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.search),
          //   title: const Text('Search Books'),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(FindBookScreen.routeName);
          //   },
          // ),

          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Đơn hàng'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Quản Lý Sách'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserBooksScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Giỏ Hàng'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
            },
          ),
          const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.exit_to_app),
          //   title: const Text('Logout'),
          //   onTap: () {
          //     Navigator.of(context)
          //       ..pop()
          //       ..pushReplacementNamed('/');
          //     context.read<AuthManager>().logout();
          //   },
          // ),
        ],
      ),
    );
  }
}

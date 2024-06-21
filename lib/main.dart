

import 'package:flutter/material.dart';
import 'package:myshop/ui/books/books_overview_screen2.dart';
import 'package:myshop/ui/books/find_book_screen.dart';
import 'package:myshop/ui/user/user_screen.dart';
import 'package:provider/provider.dart';
import 'package:myshop/ui/cart/cart_screen.dart';
import 'package:myshop/ui/orders/orders_screen.dart';
import 'ui/books/searchresult_screen.dart';
import 'ui/orders/order_manager.dart';
import 'ui/cart/cart_manager.dart';
import 'ui/orders/order_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ui/screens.dart';
import 'ui/user/user_manager.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final Gradient myGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.blue, Colors.green],
  );
  static final List<Widget> _pages = <Widget>[
    const BooksOverviewScreen(),
    const BooksOverviewScreen2(),
    const FindBookScreen(),
     const UserScreen(),

  ];

  void _onItemTapped (int index) {
    setState((){
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.lightGreen,
      secondary: Colors.deepOrange,
      background: Colors.grey[200],
      surfaceTint: Colors.grey[500],
    );
    final themData = ThemeData(
      fontFamily: 'Lato',
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shadowColor: colorScheme.shadow,
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 20,
        ),
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, UserManager>(
          create: (ctx) => UserManager(),
          update: (ctx, authManager, userManager) {
            userManager!.authToken = authManager.authToken;
            return userManager;
          },
        ),

        ChangeNotifierProxyProvider<AuthManager, BooksManager>(
          create: (ctx) => BooksManager(),
          update: (ctx, authManager, booksManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho bookManager
            booksManager!.authToken = authManager.authToken;
            return booksManager;
          },
        ),
        ChangeNotifierProxyProvider<AuthManager, CartManager>(
          create: (ctx) => CartManager(),
          update: (ctx, authManager, cartManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho bookManager
            cartManager!.authToken = authManager.authToken;
            return cartManager;
          },
        ),
        ChangeNotifierProxyProvider<AuthManager, OrderManager>(
          create: (ctx) => OrderManager(),
          update: (ctx, authManager, ordersManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho bookManager
            ordersManager!.authToken = authManager.authToken;
            return ordersManager;
          },
        ),

        // ChangeNotifierProvider(
        //   create: (ctx) => CartManager(),
        // ),
        // ChangeNotifierProvider(
        //   create: (ctx) => OrderManager(),
        // ),
      ],
      child: Consumer<AuthManager>(builder: (context, authManager, child) {
        return MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: themData,
          // home: const SafeArea(
          //   child: CartScreen(),
          // ),
          home: authManager.isAuth
              ? Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar: NavigationBar(
              destinations: const <Widget>[
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Yêu Thích'),
                NavigationDestination(icon: Icon(Icons.search), label: 'Tìm Kiếm'),
                NavigationDestination(icon: Icon(Icons.person_outline), label: 'Tài Khoản'),

              ],
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
            ),
          )
              : FutureBuilder(
                  future: authManager.tryAutoLogin(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const SafeArea(child: SplashScreen())
                        : const SafeArea(child: AuthScreen());
                  },
                ),
          // child: BookDetailScreen(BooksManager().items[0]),
          // child: BooksOverviewScreen(),
          // child: UserBooksScreen(),
          // child: CartScreen(),
          // Thuộc tính routes thường dùng khai báo
          // các route không tham số.

          routes: {
            CartScreen.routeName: (ctx) => const SafeArea(
                  child: CartScreen(),
                ),
            OrderScreen.routeName: (ctx) => const SafeArea(
                  child: OrderScreen(),
                ),
            UserBooksScreen.routeName: (ctx) => const SafeArea(
                  child: UserBooksScreen(),
                ),
            FindBookScreen.routeName: (ctx) => const SafeArea(
                  child: FindBookScreen(),
                ),
            UserScreen.routeName: (ctx) =>
            const SafeArea(child: UserScreen()),

          },
          onGenerateRoute: (settings) {
            if (settings.name == BookDetailScreen.routeName) {
              final bookId = settings.arguments as String;
              return MaterialPageRoute(
                settings: settings,
                builder: (ctx) {
                  return SafeArea(
                    child: BookDetailScreen(
                        ctx.read<BooksManager>().findById(bookId)!),
                  );
                },
              );
            }
            if (settings.name == EditBookScreen.routeName) {
              final bookId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return SafeArea(
                    child: EditBookScreen(
                      bookId != null
                          ? ctx.read<BooksManager>().findById(bookId)
                          : null,
                    ),
                  );
                },
              );
            }
            return null;
          },
        );
      }),
    );
  }
}

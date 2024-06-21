import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../orders/order_manager.dart';
import '../screens.dart';
import 'cart_manager.dart';
import 'cart_item_card.dart';
import '../../models/order_item.dart';
import 'package:provider/provider.dart';
import '../../services/carts_service.dart';
import '../books/books_manager.dart';
import '../shared/app_drawer.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng'),
        actions:<Widget> [
          HomeButton(
            onPressed: () {
              // Chuyển đến trang Home
              Navigator.of(context).pushNamed('/');
            },
          ),
        ],
      ),
      // drawer: const AppDrawer(),
      body: Column(
        children: <Widget>[
          CartSummary(
            cart: cart,
            // Xử lý xự kiện cho nút Order Now
            // onOrderNowPressed: cart.totalAmount <= 0
            //     ? null
            //     : () {
            //         context.read<OrderManager>().addOrder(
            //               cart.books,
            //               cart.totalAmount,
            //             );
            //         cart.clearAllItem();
            //       },
            onOrderNowPressed: () async {
              final store = context.read<BooksManager>();
              final orderManager = context.read<OrderManager>();
              final cart = context.read<CartManager>();
              final bookInCarts = cart.books;

              String? bookOutOfStock = store.checkingStock(bookInCarts);

              if (bookOutOfStock == null) {
                await orderManager.addOrder(OrderItem(
                  amount: cart.totalAmount,
                  books: bookInCarts,
                  ));

                store.updateStore(bookInCarts);
                cart.clearAllItem();
                Navigator.of(context).pushReplacementNamed('/orders');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                      'Sách đã hết'),
                  duration: const Duration(seconds: 5),
                ));
              }
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CartItemList(cart),
          ),
        ],
      ),
    );
  }
}

class CartItemList extends StatefulWidget {
  const CartItemList(this.cart, {super.key});
  final CartManager cart;

  @override
  State<CartItemList> createState() => _CartItemListState();
}

class _CartItemListState extends State<CartItemList> {
  late Future<void> fetchCart;

  @override
  void initState() {
    fetchCart = context.read<CartManager>().fetchCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchCart,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return widget.cart.bookCount > 0
              ? ListView(
                  children: widget.cart.bookEntries
                      .map(
                          (e) => CartItemCard(bookId: e.key, cartItem: e.value))
                      .toList(),
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Text(
                        'không có sản phẩm nào trong giỏ hàng',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ],
                  ),
                );
        });
  }
}

class CartSummary extends StatefulWidget {
  const CartSummary({
    super.key,
    required this.cart,
    this.onOrderNowPressed,
  });

  final CartManager cart;
  final void Function()? onOrderNowPressed;

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Tổng:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Chip(
              label: Text(
                // '${widget.cart.totalAmount.toStringAsFixed(0)}' + ' vnđ',
                '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(widget.cart.totalAmount)}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 10), // Thêm khoảng cách giữa Chip và nút
            ElevatedButton(
              onPressed: widget.onOrderNowPressed,
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('ĐẶT HÀNG',style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

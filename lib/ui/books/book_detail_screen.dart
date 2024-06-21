import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/book.dart';
import '../shared/app_drawer.dart';
import '../cart/cart_manager.dart';
import '../cart/cart_screen.dart';
import '../books/book_detail_screen.dart';

import 'books_manager.dart';
import 'package:provider/provider.dart';
import 'books_overview_screen.dart';
import 'top_right_badge.dart';

class BookDetailScreen extends StatefulWidget {
  BookDetailScreen(
    this.book, {
    super.key,
  });

  static const routeName = '/book-detail';

  final Book book;

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int _count = 0;

  void _increaseCount() {
    setState(() {
      _count++;
    });
  }

  void _decreaseCount() {
    setState(() {
      _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: <Widget>[

          // HomeButton(
          //   onPressed: () {
          //     // Chuyển đến trang Home
          //     Navigator.of(context).pushNamed('/');
          //   },
          // ),
          ShoppingCartButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ],
      ),
      // drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            SizedBox(
              height: 300,
              width: 250,
              child: Image.network(widget.book.imageUrl, width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,),
            ),
            const SizedBox(height: 10),
            Text(

                widget.book.title,

                style: const TextStyle( color: Colors.red, fontSize: 24,fontWeight: FontWeight.bold)
            ),
            // const SizedBox(height: 10),


            Padding(
              padding: const EdgeInsets.fromLTRB(20,10,20,10),
              child: Row(

                children: [
                  Text(
                    'Tác giả: ' + widget.book.author,
                    maxLines: 1,
                      style: const TextStyle( fontSize: 18)
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,10,20,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thể loại: ' + widget.book.category,
                      style: const TextStyle( fontSize: 18)
                  ),
                  Text(
                      'Số lượng:' + '${widget.book.quantity}',

                      style: const TextStyle( fontSize: 18)
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Text(
                widget.book.description,
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 3,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right:  80.0),
                  child: Text(
                    // 'Giá: ' + '${widget.book.price}' + ' vnđ',
                    'Giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(widget.book.price)}',
                    style: const TextStyle(color: Colors.red, fontSize: 24),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Màu của border
                      width: 1, // Độ dày của border
                    ),
                    borderRadius: BorderRadius.circular(8), // Độ bo tròn của border
                  ),
                  child: IconButton(
                    onPressed: _decreaseCount,
                    icon: Icon(Icons.remove),
                    color: Colors.red, // Màu đỏ cho nút giảm
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '$_count',
                    style: TextStyle(fontSize: 20), // Cỡ chữ lớn hơn
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Màu của border
                      width: 1, // Độ dày của border
                    ),
                    borderRadius: BorderRadius.circular(8), // Độ bo tròn của border
                  ),
                  child: IconButton(
                    onPressed: _increaseCount,
                    icon: Icon(Icons.add),
                    color: Colors.green, // Màu xanh lá cây cho nút tăng
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                FavoriteButton(
                  book: widget.book,

                  onFavoritePressed: () {
                    // Nghịch đảo giá trị isFavorite của book
                    context.read<BooksManager>().toggleFavoriteStatus(widget.book);
                  },
                ),
                ShoppingButton(
                  onAddToCartPressed: () async {
                    // Đọc ra CartManager dùng context.read
                    final cart = context.read<CartManager>();
                    String? error = await cart.addItem(widget.book, _count);
                    // cart.addItem(widget.book,_count);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          backgroundColor: error != null ? Colors.red : Colors.green,
                          content: Text(
                            error ?? 'Sách đã được thêm vào giỏ hàng',
                            style: const TextStyle(color: Colors.white),
                          ),
                          duration: const Duration(seconds: 2),
                          action: error != null
                              ? null
                              :SnackBarAction(
                            label: 'hoàn tác',
                            onPressed: () {
                              // Xóa book nếu undo
                              cart.removeItem(widget.book.id!);


                            },
                          ),
                        ),
                      );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.book,
    this.onFavoritePressed,
  });

  final void Function()? onFavoritePressed;
  final Book book;

  @override
  Widget build(BuildContext context) {
    return GridTileBar(
        leading: ValueListenableBuilder<bool>(
      valueListenable: book.isFavoriteListenable,
      builder: (ctx, isFavorite, child) {
        return ElevatedButton.icon(
          onPressed: onFavoritePressed,

          label: const Text('Yêu Thích',style: TextStyle(color: Colors.white)),

          icon: Icon(

            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Theme.of(context).colorScheme.secondary,


          ),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen)
        );
      },
    ));
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.home,
      ),
      onPressed: onPressed,
    );
  }
}

class ShoppingButton extends StatelessWidget {
  const ShoppingButton({
    super.key,
    this.onPressed,
    this.onAddToCartPressed,
  });

  final void Function()? onAddToCartPressed;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(
        Icons.shopping_cart,

      ),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
      onPressed: onAddToCartPressed,
      label: const Text('Thêm vào giỏ hàng',style: TextStyle(color: Colors.white)),

    );
  }
}


// class BookDetailScreen extends StatelessWidget {
//   final Book book;
//
//   const BookDetailScreen(this.book, {Key? key}) : super(key: key);
//   static const routeName = '/book-detail';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(book.title),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: SizedBox(
//                 height: 300,
//                 width: 250,
//                 child: Image.network(
//                   book.imageUrl,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Tác giả: ${book.author}',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Thể loại: ${book.category}',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Số lượng: ${book.quantity}',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Mô tả:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               book.description,
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Giá: ${book.price} vnđ',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {},
//                       icon: Icon(Icons.remove),
//                       color: Colors.red,
//                     ),
//                     Text(
//                       '0',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: Icon(Icons.add),
//                       color: Colors.green,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.shopping_cart),
//               label: Text('Thêm vào giỏ hàng', style: TextStyle(fontSize: 18)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ShoppingCartButton extends StatelessWidget {
//   const ShoppingCartButton({super.key, this.onPressed});
//
//   final void Function()? onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     // Truy xuất CartManager thông qua widget Consumer
//     return Consumer<CartManager>(
//       builder: (ctx, cartManager, child) {
//         return TopRightBadge(
//           data: cartManager.bookCount,
//           child: IconButton(
//             icon: const Icon(
//               Icons.shopping_cart,
//             ),
//             onPressed: onPressed,
//           ),
//         );
//       },
//     );
//   }
// }
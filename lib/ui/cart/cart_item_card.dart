import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import '../../models/cart_item.dart';
import '../shared/dialog_utils.dart';

class CartItemCard extends StatelessWidget {
  final String bookId;
  final CartItem cartItem;

  const CartItemCard({
    required this.bookId,
    required this.cartItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(bookId),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showConfirmDialog(
          context,
          'Bạn muốn xóa sách này khỏi giỏ hàng?',
        );
      },
      onDismissed: (direction) {
        // Xóa sản phẩm khỏi giỏ hàng
        context.read<CartManager>().clearItem(bookId);
      },
      child: ItemInfoCard(cartItem),
    );
  }
}

class ItemInfoCard extends StatelessWidget {
  const ItemInfoCard(this.cartItem, {super.key});
  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Tạo hiệu ứng đổ bóng để làm nổi bật thẻ Card
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Bo tròn góc của thẻ Card
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Hiển thị hình ảnh của mặt hàng
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                cartItem.imageUrl,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(width: 10), // Tạo khoảng cách giữa hình ảnh và nội dung
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Hiển thị tiêu đề của mặt hàng
                  Text(
                    cartItem.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5), // Tạo khoảng cách giữa tiêu đề và nội dung phụ
                  // Hiển thị giá tiền và số lượng
                  Text(
                    // ' ${(cartItem.price * cartItem.quantity)} vnd',
                    'tổng: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(cartItem.price * cartItem.quantity)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    // ' ${cartItem.price} vnd ',
                    ' ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(cartItem.price)} x ${cartItem.quantity}',

                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}

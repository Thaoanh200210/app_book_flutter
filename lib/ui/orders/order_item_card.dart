import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/order_item.dart';

// class OrderItemCart extends StatefulWidget {
//   final OrderItem order;
//   final bool expanded;
//   const OrderItemCart(
//     this.order,
//       this.expanded,{
//     super.key,
//   });
//
//   @override
//   State<OrderItemCart> createState() => _OrderItemCartState();
// }
//
// class _OrderItemCartState extends State<OrderItemCart> {
//   var _expaned = false;
//
//   @override
//   void initState() {
//     _expaned = widget.expanded;
//     super.initState();
//   }
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(10),
//       child: Column(
//         children: <Widget>[
//           OrderSummary(
//             expanded: _expaned,
//             order: widget.order,
//             onExpandPressed: () {
//               setState(() {
//                 _expaned = !_expaned;
//               });
//             },
//           ),
//           if (_expaned) OrderItemList(widget.order)
//         ],
//       ),
//     );
//
//   }
// }
//
// class OrderItemList extends StatelessWidget {
//   final OrderItem order;
//   const OrderItemList(this.order, {super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//       height: max(order.bookCount * 100.0 + 10, 100),
//       child: ListView(
//         children: order.books
//             .map(
//               (prod) => Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                   children: <Widget>[
//
//                     SizedBox(
//                       height: 80,
//                       width: 60,
//                       child: Image.network(
//                         prod.imageUrl, // URL của hình ảnh sản phẩm
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Text(
//                       '${prod.quantity}x ${prod.price} vnđ ',
//                       style: const TextStyle(
//                         fontSize: 18,
//
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             )
//             .toList(),
//       ),
//     );
//
//   }
// }
//
// class OrderSummary extends StatelessWidget {
//   const OrderSummary({
//     super.key,
//     required this.order,
//     required this.expanded,
//     this.onExpandPressed,
//   });
//
//   final bool expanded;
//   final OrderItem order;
//   final void Function()? onExpandPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       titleTextStyle: Theme.of(context).textTheme.titleLarge,
//       title: Text('${order.amount.toString()} vnd'),
//       subtitle: Text(
//         DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime),
//       ),
//       trailing: IconButton(
//         icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
//         onPressed: onExpandPressed,
//       ),
//     );
//
//
//   }
// }
class OrderItemCart extends StatefulWidget {
  final OrderItem order;
  final bool expanded;

  const OrderItemCart(
      this.order,
      this.expanded, {
        Key? key,
      }) : super(key: key);

  @override
  _OrderItemCartState createState() => _OrderItemCartState();
}

class _OrderItemCartState extends State<OrderItemCart> {
  var _expanded = false;

  void toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            onTap: () {
              toggleExpanded();
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    // 'Tổng: ${widget.order.amount} VNĐ',
                    'Giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(widget.order.amount)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[

                      Text(
                        DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
                        style: TextStyle(
                          fontSize: 16,

                        ),
                      ),
                      SizedBox(height: 4),

                      Text(
                        'xem chi tiết đơn hàng',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          if (_expanded) OrderItemList(widget.order),
        ],
      ),
    );
  }
}


class OrderItemList extends StatelessWidget {
  final OrderItem order;

  const OrderItemList(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: order.books.length,
        itemBuilder: (context, index) {
          var product = order.books[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        // '${product.quantity}x ${product.price} vnđ',
                        'Giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.price)} x ${product.quantity}',
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
          );
        },
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  const OrderSummary({
    Key? key,
    required this.order,
    required this.expanded,
    this.onExpandPressed,
  }) : super(key: key);

  final bool expanded;
  final OrderItem order;
  final void Function()? onExpandPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${order.amount.toString()} vnd',
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime),
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          expanded ? Icons.expand_less : Icons.expand_more,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: onExpandPressed,
      ),
    );
  }
}

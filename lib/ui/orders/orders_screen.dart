import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens.dart';
import 'order_manager.dart';
import 'order_item_card.dart';
import '../shared/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderManager = context.read<OrderManager>();
    final fetchOrders = orderManager.fetchOrders();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Đơn Hàng'),
          actions:<Widget> [
            HomeButton(
              onPressed: () {
                // Chuyển đến trang Home
                Navigator.of(context).pushNamed('/');
              },
            ),
          ],
        ),
        drawer: const AppDrawer(),
        // body: Consumer<OrderManager>(
        //   builder: (ctx, ordersManager, child) {
        //     return ListView.builder(
        //       itemCount: ordersManager.orderCount,
        //       itemBuilder: (ctx, i) => OrderItemCart(ordersManager.orders[i]),
        //     );
        //   },
        // ),
        body: FutureBuilder(
          future: fetchOrders,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: orderManager.orderCount,
                itemBuilder: (ctx, i) => OrderItemCart(orderManager.orders[i],i == 0));
          },
        ));
  }
}



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return OrderItemWidget(
            order: order.orders[index],
          );
        },
        itemCount: order.orders.length,
      ),
    );
  }
}

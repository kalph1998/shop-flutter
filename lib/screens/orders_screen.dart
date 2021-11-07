import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {


  @override
  Widget build(BuildContext context) {
    // final order = Provider.of<Orders>(context);

    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return const Center(
                  child: Text('An error occured'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, order, child) => ListView.builder(
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
          },
        ));
  }
}

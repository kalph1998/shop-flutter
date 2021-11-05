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
  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then( (_) async {
     setState(() {
       _isLoading = true;
     });
     await  Provider.of<Orders>(context, listen: false).fetchAndSetOrders();

     setState(() {
       _isLoading = false;
     });
    } );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: _isLoading ? const Center(child:  CircularProgressIndicator(),) : ListView.builder(
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

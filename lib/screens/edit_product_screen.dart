import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
      ),
    );
  }
}

import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://shop-flutter-35558-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-flutter-35558-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite
          }));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)['name'],
      );

      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product findById(String id) {
    return items.firstWhere((product) => product.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    final url = Uri.parse(
        'https://shop-flutter-35558-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    if (prodIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}

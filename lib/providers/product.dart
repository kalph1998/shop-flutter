import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exceptin.dart';

class Product with ChangeNotifier {
  final dynamic id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    var oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shop-flutter-35558-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          
             isFavorite,
          
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
        throw HttpException('Could not delete product');
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}

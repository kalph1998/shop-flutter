import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exceptin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';

  bool get isAuth {
    return _token != '';
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != '') {
      return _token;
    }
    return '';
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCVZg96J5ZI_rYIU4iIoM-6V-Lb2ERJGWA');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);
    } catch (error) {
      print(error);

      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    notifyListeners();
    return true;
  }

  void logout() {
    _token = '';
    _userId = '';
    notifyListeners();
  }
}

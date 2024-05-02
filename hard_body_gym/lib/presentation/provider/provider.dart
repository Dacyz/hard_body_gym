import 'package:flutter/material.dart';
import 'package:hard_body_gym/models/user.dart';

class DataService extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }
}

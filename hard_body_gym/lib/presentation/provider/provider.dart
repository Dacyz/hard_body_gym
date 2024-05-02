import 'package:flutter/material.dart';
import 'package:hard_body_gym/models/person.dart';
import 'package:hard_body_gym/models/user.dart';

class DataService extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  List<Person> persons = [];

  Person? _person;
  Person? get person => _person;
  set person(Person? value) {
    _person = value;
    notifyListeners();
  }
}

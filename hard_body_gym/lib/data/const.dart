import 'package:flutter/material.dart';
import 'package:hard_body_gym/presentation/pages/add_person.dart';
import 'package:hard_body_gym/presentation/pages/home.dart';
import 'package:hard_body_gym/presentation/pages/login.dart';

class Constants {
  static const String appName = 'HardBodyGym';
  static const String host = 'https://ucvpppix.net/hard_body_gym';
  static const int timeOutSeconds = 75;
  static final Map<String, String> headers = {'Content-Type': 'application/json'};

  static const initialRoute = LoginPage.route;
  static final Map<String, Widget Function(BuildContext)> routes = {
    LoginPage.route: (context) => const LoginPage(),
    HomePage.route: (context) => const HomePage(),
    AddPersonPage.route: (context) => const AddPersonPage(),
  };
}

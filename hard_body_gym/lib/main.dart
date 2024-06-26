import 'package:flutter/material.dart';
import 'package:hard_body_gym/data/const.dart';
import 'package:hard_body_gym/presentation/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataService(),
      child: MaterialApp(
        title: Constants.appName,
        locale: const Locale('es'),
        debugShowCheckedModeBanner: false,
        initialRoute: Constants.initialRoute,
        routes: Constants.routes,
      ),
    );
  }
}

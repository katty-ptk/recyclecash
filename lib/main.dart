import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recyclecash/firebase_options.dart';
import 'package:recyclecash/screens/home/home.screen.dart';
import 'package:recyclecash/screens/login/login.screen.dart';
import 'package:recyclecash/services/auth.service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  bool isLoggedIn = await AuthService().isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn,));
}

class MyApp extends StatelessWidget {

  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycle Cash',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn == true ? const HomeScreen() : LoginScreen()
    );
  }
}
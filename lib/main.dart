import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recyclecash/firebase_options.dart';
import 'package:recyclecash/screens/home.screen.dart';
import 'package:recyclecash/screens/login.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  bool isLoggedIn;
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  if ( sharedPreferences.getString('tickets') != null ) {
    isLoggedIn = true;
  } else {
    isLoggedIn = false;
  }

  runApp(MyApp(isLoggedIn: isLoggedIn,));
}

class MyApp extends StatelessWidget {

  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn == true ? const HomeScreen() : LoginScreen()
    );
  }
}
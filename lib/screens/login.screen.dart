import 'package:flutter/material.dart';
import 'package:recyclecash/screens/home.screen.dart';
import 'package:recyclecash/services/firestore.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> login() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    FirestoreService().getUserName();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () async => await login(), child: Text('login as test'))
          ],
        ),
      ),
    );
  }
}

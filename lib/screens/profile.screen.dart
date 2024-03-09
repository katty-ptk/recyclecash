import 'package:flutter/material.dart';
import 'package:recyclecash/screens/login.screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen())
            ),
            child: Text("logout")),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:recyclecash/screens/home/home.screen.dart';
import 'package:recyclecash/screens/login/login.screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen())
          ),
        ),
        title: Text(userName, textAlign: TextAlign.center,),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => LoginScreen())
                ),
                child: Text('logout')
            )
          ],
        ),
      )
    );
  }
}

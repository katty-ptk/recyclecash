import 'package:flutter/material.dart';
import 'package:recyclecash/services/auth.service.dart';

import '../services/firestore.service.dart';
import 'home.screen.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Future<void> login() async {
      // FirestoreService().getUserName();

      AuthService().signInWithEmailAndPassword(_emailController.text, _passController.text);

      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/SL-051919-20420-09.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            margin: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                _inputField(context, login),
                _forgotPassword(context),
                _signup(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Row(
      children: [
        Image.asset(
          "assets/logo.png", // Replace with your image asset path
          height: 100, // Adjust the height as needed
        ),
        SizedBox(width: 10), // Add some space between the logo and text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "  Welcome to",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color(0xFF36A383)),
            ),
            Text(
              "RecycleCash",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF36A383)),
            ),
          ],
        ),
      ],
    );
  }

  _inputField(BuildContext context, Function login ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Color(0xFF36A383).withOpacity(0.1), // Changed box color
            filled: true,
            prefixIcon: Icon(Icons.person, color: Color(0xFF595959)),
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _passController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Color(0xFF36A383).withOpacity(0.1), // Changed box color
            filled: true,
            prefixIcon: Icon(Icons.lock, color: Color(0xFF595959)),
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => login(),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Color(0xFF595959)),
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        "Forgot password?",
        style: TextStyle(fontSize: 15, color: Color(0xFF595959)),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ", style: TextStyle(color: Color(0xFF595959))), // Added TextStyle for text color
        TextButton(onPressed: () {}, child: Text("Sign Up", style: TextStyle(color: Color(0xFF595959)))), // Added TextStyle for text color
      ],
    );
  }
}
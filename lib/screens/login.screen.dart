import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                _inputField(context),
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

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
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
        TextField(
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
          onPressed: () {},
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
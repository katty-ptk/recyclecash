import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
            margin: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context, screenWidth),
                _inputField(context, screenWidth),
                _forgotPassword(context, screenWidth),
                _signup(context, screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _header(context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/logo.png",
          height: screenWidth * 0.2,
        ),
        SizedBox(width: screenWidth * 0.03),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "   Welcome to",
              style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold, color: Color(0xFF36A383)),
            ),
            Text(
              "RecycleCash",
              style: TextStyle(fontSize: screenWidth * 0.075, fontWeight: FontWeight.bold, color: Color(0xFF36A383)),
            ),
          ],
        ),
      ],
    );
  }

  _inputField(context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14), // Adjusted to screen width proportion
              borderSide: BorderSide.none,
            ),
            fillColor: Color(0xFF36A383).withOpacity(0.1),
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: screenWidth * 0.032), // Adjusted to screen width proportion
            prefixIcon: Icon(Icons.person, color: Color(0xFF595959)),
          ),
        ),
        SizedBox(height: screenWidth * 0.04),
        TextField(
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14), // Adjusted to screen width proportion
              borderSide: BorderSide.none,
            ),
            fillColor: Color(0xFF36A383).withOpacity(0.1),
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: screenWidth * 0.032), // Adjusted to screen width proportion
            prefixIcon: Icon(Icons.lock, color: Color(0xFF595959)),
          ),
          obscureText: true,
        ),
        SizedBox(height: screenWidth * 0.04),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
          ),
          child: Text(
            "Login",
            style: TextStyle(fontSize: screenWidth * 0.04, color: Color(0xFF595959)),
          ),
        )
      ],
    );
  }

  _forgotPassword(context, double screenWidth) {
    return TextButton(
      onPressed: () {},
      child: Text(
        "Forgot password?",
        style: TextStyle(fontSize: screenWidth * 0.04, color: Color(0xFF595959)),
      ),
    );
  }

  _signup(context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ", style: TextStyle(fontSize: screenWidth * 0.04, color: Color(0xFF595959))),
        TextButton(onPressed: () {}, child: Text("Sign Up", style: TextStyle(fontSize: screenWidth * 0.04, color: Color(0xFF595959)))),
      ],
    );
  }
}

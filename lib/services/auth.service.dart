import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  SharedPreferences? sharedPreferences;
  AuthService() {
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
    });
  }

  Future<bool> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    bool signedInSuccessfully = false;
    try {
      print("email is ==> " + email);
      print("password is ==> " + password);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      if ( credential.user != null ) {
        print("we have user");
        saveUserID(FirebaseAuth.instance.currentUser?.uid ?? "");
        signedInSuccessfully = true;
      }

      if (FirebaseAuth.instance.currentUser != null) {
        print(FirebaseAuth.instance.currentUser?.uid);
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e);
      }
    }
    return signedInSuccessfully;
  }

  Future<bool> isLoggedIn() async {
    sharedPreferences ??= await SharedPreferences.getInstance();

    if ( sharedPreferences?.getString('userId') != null ) {
      return  true;
    } else {
      return false;
    }
  }

  saveUserID(String userId) async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    sharedPreferences?.setString("userId", userId);
  }

  signOut() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    sharedPreferences?.remove("userId");
  }

  Future<String> getUserId() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    return sharedPreferences?.getString("userId") ?? "";
  }
}
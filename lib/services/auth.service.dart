import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  signInWithEmailAndPassword(String email, String password) async {
    try {

      print("email is ==> " + email);
      print("password is ==> " + password);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      if ( credential.user != null ) {
        print("we have user");
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
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphedemo/pages/loginpage.dart';
import 'package:graphedemo/pages/profilepage.dart';
import 'package:graphedemo/services/data_service.dart';
import 'package:provider/provider.dart';

class AuthService {
  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // ignore: use_build_context_synchronously
    // Check if the user is successfully signed in
    if (userCredential.user != null) {
      //debugPrint(userCredential.user.toString());
      //dataService.updateUser(userCredential.user);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        // ignore: prefer_const_constructors
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  Future<void> signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Check if the user is successfully signed in
      if (userCredential.user != null) {
        // Navigate to the HomeScreenWidget
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          // ignore: prefer_const_constructors
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signUpWithEmail(
      BuildContext context, String email, String password) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //signs in the user if try is successful
      if (userCredential.user != null) {
        // Navigate to the HomeScreenWidget
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          // ignore: prefer_const_constructors
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // ignore: use_build_context_synchronously
    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.updateUser(null);
    // Navigate to the SignInScreen or any other screen you want
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      // ignore: prefer_const_constructors
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

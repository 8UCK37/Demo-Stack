import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:graphedemo/pages/signup_page.dart';
import 'package:graphedemo/services/auth_service.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginPage> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 218, 74, 69),
                  Color.fromARGB(255, 80, 19, 11)
                ],
                stops: [0, 1],
                begin: AlignmentDirectional(0.87, -1),
                end: AlignmentDirectional(-0.87, 1),
              ),
            ),
            alignment: const AlignmentDirectional(0, -1),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 70,
                  decoration: BoxDecoration(
                    //border:Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: const AlignmentDirectional(0, 0),
                  child: const Text('CRUD Demo',
                      style: TextStyle(
                        fontFamily: 'Caveat',
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    'assets/images/data-management.png',
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: MediaQuery.of(context).size.width * .9,
                  child: TextField(
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 83, 13,
                                95), // Change the color to your desired color
                            width: 2.0, // Set the width of the border
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintText: "email",
                        hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)))),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: MediaQuery.of(context).size.width * .9,
                  child: TextField(
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 83, 13,
                                95), // Change the color to your desired color
                            width: 2.0, // Set the width of the border
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintText: "password",
                        hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap:(){
                    AuthService().signInWithEmail(context,email,password);
                  },
                  child: Container(
                    decoration: const BoxDecoration(color: Color.fromARGB(255, 66, 202, 114),borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 40,
                    width:150,
                    child: const Center(
                      child: Text(
                        "SignIn",
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                          )
                        ),
                    ),
                  ),
                ),
                const Text(
                  "or",
                  style: TextStyle(color: Colors.white,fontSize: 15),
                ),
                SignInButton(
                  buttonType: ButtonType.google,
                  onPressed: () {
                    AuthService().signInWithGoogle(context);
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Don't have an account yet?\nSign Up here!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SignUpPage(),
                        ),
                      );
                  },
                  child: Container(
                    decoration: const BoxDecoration(color: Color.fromARGB(255, 183, 194, 66),borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 40,
                    width:150,
                    child: const Center(
                      child: Text(
                        "SignUp",
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                          )
                        ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

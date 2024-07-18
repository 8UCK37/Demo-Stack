import 'package:flutter/material.dart';
import 'package:graphedemo/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = '';
  String password = '';
  String passwordConfirm = '';

  void signUp() {
    if (email.length != 0 && password.length != 0 && passwordConfirm != 0) {
      if (password != passwordConfirm) {
        debugPrint("Passwoeds do not match");
        return;
      }
      AuthService().signUpWithEmail(context, email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
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
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
                height: 35,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: MediaQuery.of(context).size.width * .9,
                child: TextField(
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      passwordConfirm = value;
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
                      hintText: "confirm password",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  signUp();
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 183, 194, 66),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  height: 40,
                  width: 150,
                  child: const Center(
                    child: Text("SignUp",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

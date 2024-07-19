import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphedemo/services/auth_service.dart';
import 'package:graphedemo/services/data_service.dart';
import 'package:provider/provider.dart';
import 'package:weather_animation/weather_animation.dart';
import '../controller/network_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FocusNode searchTextArea = FocusNode();
  final FocusNode editText = FocusNode();
  String searchterm = '';
  String name = "";
  String bio = "";
  String address = "";
  String country = "";
  String phone = "";
  bool enabled = false;
  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchUser() {
    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.saveUserInit();
  }

  void updateUserData(Map<String, String> userInfo) {
    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.updateUserInfo(userInfo);
  }

  void updateUserName(String name) {
    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.updateName(name);
  }

  Widget switchWeather(String weatherDesc) {
    switch (weatherDesc) {
      case "Sunny":
        return const WeatherSceneWidget(
          weatherScene: WeatherScene.scorchingSun,
        );
      case "Clear":
        return const WeatherSceneWidget(
          weatherScene: WeatherScene.scorchingSun,
        );
      case "Partly Cloudy":
        return const WeatherSceneWidget(
          weatherScene: WeatherScene.stormy,
        );
      case "Overcast":
        return const WeatherSceneWidget(
          weatherScene: WeatherScene.stormy,
        );
      case "Mist":
        return const WeatherSceneWidget(
          weatherScene: WeatherScene.sunset,
        );
      case "Patchy light rain":
        return const WeatherSceneWidget(
          weatherScene: WeatherScene.rainyOvercast,
        );
      default:
        return const WeatherSceneWidget(
          weatherScene: WeatherScene.weatherEvery,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: true);
    final userData = dataService.currentUser;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 10,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Graphe CRUD"),
              const SizedBox(width: 25),
              GestureDetector(
                onTap: () {
                  AuthService().signOut(context);
                },
                child: const Icon(Icons.logout),
              ),
            ],
          ),
          leading: const Icon(Icons.menu),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            //height: double.infinity,
            alignment: const AlignmentDirectional(0, -1),
            child: Column(
              children: [
                if (enabled)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            updateUserName(name);
                            // updateUserData(
                            //     {
                            //       'bio': bio,
                            //       'Address': address,
                            //       'Country': country,
                            //       'Phone': phone
                            //     }
                            //   );
                            setState(() {
                              enabled = false;
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 66, 202, 114),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            height: 40,
                            width: 70,
                            child: const Center(
                              child: Text("Save",
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
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: CircleAvatar(
                    maxRadius: 100,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        imageScale: .4,
                        placeholder: 'assets/images/profile.png',
                        image: userData?['profilePicture'],
                        fit: BoxFit.fill,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/profile.png',
                              fit: BoxFit.cover);
                        },
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextField(
                        focusNode: editText,
                        enabled: enabled,
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 83, 13,
                                    95), // Change the color to your desired color
                                width: 2.0, // Set the width of the border
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            hintText: "${userData["name"]}",
                            hintStyle: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
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
                        enabled: enabled,
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            bio = value;
                          });
                        },
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 83, 13,
                                    95), // Change the color to your desired color
                                width: 2.0, // Set the width of the border
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            hintText: "${userData["bio"]}",
                            hintStyle: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
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
                        enabled: enabled,
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 83, 13,
                                    95), // Change the color to your desired color
                                width: 2.0, // Set the width of the border
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            hintText: "${userData["Address"]}",
                            hintStyle: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
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
                        enabled: enabled,
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            country = value;
                          });
                        },
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 83, 13,
                                    95), // Change the color to your desired color
                                width: 2.0, // Set the width of the border
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            hintText: "${userData["Country"]}",
                            hintStyle: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
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
                        enabled: enabled,
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 83, 13,
                                    95), // Change the color to your desired color
                                width: 2.0, // Set the width of the border
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            hintText: "${userData["Phone"]}",
                            hintStyle: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          enabled = true;
                          Future.delayed(const Duration(milliseconds: 150), () {
                            editText.requestFocus();
                          });
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 66, 202, 114),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        height: 40,
                        width: 150,
                        child: const Center(
                          child: Text("Edit Info",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

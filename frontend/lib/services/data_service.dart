import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphedemo/controller/network_controller.dart';
import 'package:graphedemo/pojos/weather_data.dart';

class DataService extends ChangeNotifier {
  NetworkController networkController = NetworkController();
  WeatherDataPojo? data;
  var user;

  String profileImagecacheKey = "dp1";
  String bannerImagecacheKey = "ban1";

  Map<String, dynamic> currentUser = {};

  void updateUser(var newUser) {
    user = newUser;
    //debugPrint(user.displayName);
    notifyListeners();
  }

  void refreshCache() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    profileImagecacheKey = "dp2$timestamp";
    bannerImagecacheKey = "ban2$timestamp";
    notifyListeners();
  }

  void saveUserInit() async {
    NetworkController networkController = NetworkController();
    if (await networkController.noInternet()) {
      debugPrint("saveUserInit() no_internet");
      return;
    } else {
      debugPrint("saveUser called");
    }
    Dio dio = Dio();

    final user = FirebaseAuth.instance.currentUser;
    // ignore: use_build_context_synchronously

    final idToken = await user!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    // ignore: unnecessary_null_comparison
    if (user != null) {
      //debugPrint(user.uid.toString());
      var response = await dio.get(
        'http://${dotenv.env['server_url']}/saveuser',
        options: options,
      );
      //debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        // Request successful
        var userData = json.decode(response.data);
        //debugPrint(userData.toString());
        currentUser = userData;
        notifyListeners();
        refreshCache();
      } else {
        // Request failed
        debugPrint('Failed to hit Express backend endpoint');
      }
    } else {
      // User not logged in
      debugPrint('User is not logged in');
    }
  }
  
}

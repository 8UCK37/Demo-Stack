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

  void refreashCache() {
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
      var response = await dio.post(
        'http://${dotenv.env['server_url']}/saveuser',
        options: options,
      );
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        // Request successful
        var userData = json.decode(response.data);
        //debugPrint(userData.toString());
        currentUser = userData;
        notifyListeners();
        refreashCache();
      } else {
        // Request failed
        debugPrint('Failed to hit Express backend endpoint');
      }
    } else {
      // User not logged in
      debugPrint('User is not logged in');
    }
  }
  

  Future<void> updateUserInfo(dynamic userInfo) async {
    if (await networkController.noInternet()) {
      debugPrint("updateSelectedLanguage() no_internet");
      return;
    } else {
      debugPrint("updateSelectedLanguage() called");
    }

    Dio dio = Dio();
    final userFromFirebase = FirebaseAuth.instance.currentUser;
    final idToken = await userFromFirebase!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/updateUserData',
      data: {
        'data': {
          'id': 2,
          'bio': "userInfo['bio']",
          'Address': "userInfo['Address']",
          'Country': "userInfo['Country']",
          'Phone':"userInfo['Phone']"
        }
      },
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint("userinfo updated");
    }
  }

  Future<void> updateName(String newName) async {
    if (await networkController.noInternet()) {
      debugPrint("updateSelectedLanguage() no_internet");
      return;
    } else {
      debugPrint("updateSelectedLanguage() called");
    }
    debugPrint("----------------------------\n\n");
    debugPrint(newName);
    Dio dio = Dio();

    final userFromFirebase = FirebaseAuth.instance.currentUser;
    final idToken = await userFromFirebase!.getIdToken();
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );
    var response = await dio.post(
      'http://${dotenv.env['server_url']}/userNameUpdate',
      data: {'name': newName},
      options: options,
    );
    if (response.statusCode == 200) {
      debugPrint("name updated");
    }
  }

  void fetchWeatherData(String searchTerm) async {
    if (await networkController.noInternet()) {
      debugPrint("no_internet");
      return;
    } else {
      debugPrint("data fetch called");
    }

    Dio dio = Dio();

    try {
      var response = await dio.post(
        'http://api.weatherstack.com/current?query=${searchTerm}&access_key=${dotenv.env['weatherApiKey']}',
      );

      if (response.statusCode == 200) {
        // Request successful
        //var weatherData = json.decode(response.data);
        data = WeatherDataPojo.fromJson(response.data);
        debugPrint(data?.current?.observationTime.toString());
        notifyListeners();
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        // Dio error occurred
        switch (e.type) {
          case DioExceptionType.cancel:
            debugPrint("Request to API server was cancelled");
            break;
          case DioExceptionType.connectionTimeout:
            debugPrint("Connection timeout with API server");
            break;
          case DioExceptionType.connectionError:
            debugPrint("Connection timeout with API server");
            break;
          case DioExceptionType.receiveTimeout:
            debugPrint("Receive timeout in connection with API server");
            break;
          case DioExceptionType.badResponse:
            debugPrint(
                "Received invalid status code: ${e.response?.statusCode}");
            break;
          case DioExceptionType.sendTimeout:
            debugPrint("Send timeout in connection with API server");
            break;
          case DioExceptionType.badCertificate:
            debugPrint("Send timeout in connection with API server");
            break;
          case DioExceptionType.unknown:
            debugPrint("Unexpected error: $e");
            break;
        }
      } else {
        debugPrint("Unexpected error: $e");
      }
    }
  }
}

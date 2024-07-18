import 'package:flutter/material.dart';
import 'package:graphedemo/services/auth_service.dart';
import 'package:graphedemo/services/data_service.dart';
import 'package:provider/provider.dart';
import 'package:weather_animation/weather_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FocusNode searchTextArea = FocusNode();
  String searchterm = '';

  void fetchData(String searchTerm) {
    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.fetchWeatherData(searchTerm);
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
        body: Container(
          height: double.infinity,
          alignment: const AlignmentDirectional(0, -1),
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top:18.0),
              //   child: 
              //   CircleAvatar(
              //       maxRadius: 100,
              //       child: ClipOval(
              //         child: FadeInImage.assetNetwork(
              //           imageScale: .4,
              //           placeholder: 'assets/images/profile.png',
              //           image: dataService.currentUser == null
              //               ? ''
              //               : dataService.user.photoURL,
              //           fit: BoxFit.fill,
              //           imageErrorBuilder: (context, error, stackTrace) {
              //             return Image.asset('assets/images/profile.png',
              //                 fit: BoxFit.cover);
              //           },
              //         ),
              //       ),
              //     ),
              // ),
              // Text(dataService.user.displayName),
              Text("Bio"),
              Text("Country"),
              Text("Address"),
              Text("Phone Number")
            ],
          )
        ),
      ),
    );
  }
}

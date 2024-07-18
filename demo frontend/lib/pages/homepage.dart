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
              const Text("Graphe Weather"),
              Row(
                children: [
                  CircleAvatar(
                    maxRadius: 22,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder:
                            'assets/images/profile.png', 
                        image: dataService.user==null? '' : dataService.user.photoURL,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/profile.png',
                              fit: BoxFit.cover);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: () {
                      AuthService().signOut(context);
                    },
                    child: const Icon(Icons.logout),
                  ),
                ],
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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: MediaQuery.of(context).size.width * .9,
                child: TextField(
                  focusNode: searchTextArea,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      searchterm = value;
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
                      hintText: "Search for the city",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  onTap: () {
                    debugPrint(searchterm);
                    searchTextArea.unfocus();
                    fetchData(searchterm);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 183, 194, 66),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 40,
                    width: 150,
                    child: const Center(
                      child: Text("Search",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ),
              if (dataService.data != null && dataService.data!.current!=null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    child: Card(
                      elevation: 10,
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          Container(
                            height: 160,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              child: switchWeather(dataService
                                  .data!.current!.weatherDescriptions![0]),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              height: 159,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                dataService
                                                    .data!.location!.name!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  dataService.data!.current!
                                                      .weatherDescriptions![0],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 8, 15, 0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      dataService.data!.current!
                                                          .temperature!
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 40,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    const Text(
                                                      '°C',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "Feels like ${dataService.data!.current!.feelslike}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${dataService.data!.current!.windSpeed} km/hr",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${dataService.data!.current!.windDegree}° ${dataService.data!.current!.windDir!}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Humidity: ${dataService.data!.current!.humidity}%",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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

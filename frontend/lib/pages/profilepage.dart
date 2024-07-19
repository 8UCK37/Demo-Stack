import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:graphedemo/pages/editprofile.dart';
import 'package:graphedemo/services/auth_service.dart';
import 'package:graphedemo/services/data_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

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
  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: true);
    final userData = dataService.currentUser;
    return Scaffold(
      body: SafeArea(
        child: SliderDrawer(
          //key: _key,
          appBar: const SliderAppBar(
              appBarColor: Colors.white,
              title: Text("CRUD Demo",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700))),
          slider: Container(
            color: const Color.fromARGB(255, 235, 213, 212),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        cacheKey: dataService.profileImagecacheKey,
                        userData['profilePicture'] ?? ''),
                    radius: 50.0,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      userData['name'] ?? 'person doe',
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: GestureDetector(
                        onTap: () {
                          AuthService().signOut(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.logout_rounded),
                            SizedBox(width: 15),
                            Text(
                              'LogOut',
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height:
                        200.0, // Set the desired fixed height for the banner
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            cacheKey: dataService.bannerImagecacheKey,
                            userData['profileBanner'] ?? ''),
                        fit: BoxFit
                            .cover, // Set the fit property to determine how the image should be fitted
                      ),
                    ),
                  ),
                  //const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 150),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                cacheKey: dataService.profileImagecacheKey,
                                userData['profilePicture'] ?? ''),
                            radius: 50.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 200, left: 10),
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          //decoration: BoxDecoration(border: Border.all(color: Colors.green)),
                          width: MediaQuery.of(context).size.width - 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(userData['name'] ?? 'person doe',
                                      style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold)),
                                  Text(userData['userInfo']['bio'] ?? 'No Bio Given',
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal))
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/location.png",
                              scale: 3.5,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                  userData['userInfo']?['Country'] ??
                                      'No Info Given',
                                  style: const TextStyle(fontSize: 16.0)),
                            )
                          ],
                        ),
                        const SizedBox(width: 15.0),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const EditProfileInfo()),
                        // );
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const EditProfileInfo(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, color: Colors.deepPurpleAccent),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('Edit Profile',
                                  style: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1.0, height: 15),
              const Divider(height: 45.0),
            ],
          ),
        ),
      ),
    );
  }
}

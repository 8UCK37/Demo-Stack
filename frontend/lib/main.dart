import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:graphedemo/firebase_options.dart';
import 'package:graphedemo/pages/homepage.dart';
import 'package:graphedemo/pages/loginpage.dart';
import 'package:graphedemo/services/data_service.dart';
import 'package:provider/provider.dart';
import 'dependency_injection.dart';
import 'global.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //dotenv init
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
  DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataService>(create: (context) => DataService()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FreeWeatherApp',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: isLogin ? const HomePage() : const LoginPage(),
        navigatorKey: GlobalVariable.navState,
      ),
    );
  }
}

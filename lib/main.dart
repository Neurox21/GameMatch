import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gamematch/Controlers/authentication_controller.dart';
import 'package:gamematch/authentication_screen/login_screen.dart';
import 'package:gamematch/firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inject AuthenticationController using Get.put()
  Get.put(AuthenticationController());

  // Run the app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GameMatch',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const LoginScreen(),
    );
  }
}


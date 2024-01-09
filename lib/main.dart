import 'package:eduvista/db/hive.dart';
import 'package:eduvista/screen/splash.dart';
import 'package:eduvista/shared/web.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Web platform
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: WebConstants.apiKey,
        appId: WebConstants.appId,
        messagingSenderId: WebConstants.messagingSenderId,
        projectId: WebConstants.projectId,
      ),
    );
  } else {
    // Android or iOS platform
    await Firebase.initializeApp();
  }

  // Initialize Hive
  await Hive.initFlutter();
  await initalizeHiveandAdapter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const MaterialColor customPrimaryColor =
        MaterialColor(0XFF188F79, <int, Color>{
      50: Color(0XFF188F79),
      100: Color(0XFF188F79),
      200: Color(0XFF188F79),
      300: Color(0XFF188F79),
      400: Color(0XFF188F79),
      500: Color(0XFF188F79),
      600: Color(0XFF188F79),
      700: Color(0XFF188F79),
      800: Color(0XFF188F79),
      900: Color(0XFF188F79),
    });
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: customPrimaryColor,
          primaryColor: const Color(0XFF188F79),
          focusColor: const Color(0XFF188F79)),
      debugShowCheckedModeBanner: false,
      home: const SplashScrn(),
    );
  }
}

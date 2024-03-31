import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kittie_chat/firebase_options.dart';
import 'package:kittie_chat/screens/auth/login_scren.dart';
import 'package:kittie_chat/screens/home_screen.dart';
import 'package:kittie_chat/screens/splash_screen.dart';

late Size mq;

initialiseFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initialiseFirebase();
  runApp(const MyApp());
}

String hexColor = "#734F96"; // dark lavender
Color semiTransparentColor =
    Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0x80000000);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 197, 181, 226),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.normal),
            backgroundColor: semiTransparentColor,
          )),
      home: SplashScreen(),
    );
  }
}

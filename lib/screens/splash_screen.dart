import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:kittie_chat/screens/api.dart";
import "package:kittie_chat/screens/auth/login_scren.dart";
import "package:kittie_chat/screens/home_screen.dart";
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (APIs.auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(IconData(0xe4a1, fontFamily: 'MaterialIcons')),
        title: const Text('kittie chat :3'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * 0.15,
              // right: mq.width * .20,
              height: mq.height * .3,
              left: mq.width * .35,
              width: mq.width * .3,
              duration: const Duration(seconds: 1),
              child: Image.asset('images/logo.png')),
        ],
      ),
    );
  }
}

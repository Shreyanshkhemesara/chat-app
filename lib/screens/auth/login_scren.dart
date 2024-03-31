import "dart:developer";
import "dart:io";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:kittie_chat/helper/dialogs.dart";
import "package:kittie_chat/screens/api.dart";
import "package:kittie_chat/screens/home_screen.dart";
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _inAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      setState(() {
        _inAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick() {
    Dialogs.ShowProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log('user: ${user.user}');
        log('user: ${user.additionalUserInfo}');
        if (await APIs.userExists()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createuser().then((value) {
            log('user created here from app');
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      } else {
        Dialogs.ShowSnackBar(context, 'User found NULL');
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\nError at _signInWithGoogle: ${e}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(IconData(0xe4a1, fontFamily: 'MaterialIcons')),
        title: const Text('Login to kittie chat :3'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: _inAnimate ? mq.height * 0.15 : mq.height * .23,
              left: _inAnimate ? mq.width * .28 : mq.width * .35,
              width: _inAnimate ? mq.width * .5 : mq.width * .3,
              height: _inAnimate ? mq.width * .5 : mq.width * .3,
              duration: const Duration(milliseconds: 600),
              child: Image.asset('images/logo.png')),
          Positioned(
              bottom: mq.height * 0.15,
              left: mq.width * .17,
              width: mq.width * .7,
              height: mq.height * 0.07,
              child: ElevatedButton.icon(
                onPressed: () {
                  _handleGoogleBtnClick();
                },
                icon: Image.asset(
                  'images/google.png',
                  height: mq.height * .04,
                ),
                label: RichText(
                    text: TextSpan(children: [
                  TextSpan(text: 'Sign in with '),
                  TextSpan(
                      text: 'Google',
                      style: TextStyle(fontWeight: FontWeight.w500))
                ], style: TextStyle(color: Colors.black, fontSize: 19))),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 179, 140, 215),
                    shape: StadiumBorder(),
                    elevation: 1),
              )),
        ],
      ),
    );
  }
}

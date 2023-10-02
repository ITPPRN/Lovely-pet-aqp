import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lovly_pet_app/screen/landing_screen.dart';
import 'package:lovly_pet_app/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    AnimatedFlutterLogoState();
  }

  // ignore: non_constant_identifier_names
  void AnimatedFlutterLogoState() {
    Future.delayed(const Duration(seconds: 5), () {
      checkPreferences();
    });
  }

  Future<void> checkPreferences() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? tokenPrefer = preferences.getString('token');
      if (tokenPrefer != null && tokenPrefer.isNotEmpty) {
        routSer(const LandingPage());
      } else {
        routSer(const LoginPage());
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  void routSer(Widget myWidget) {
    MaterialPageRoute rout = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, rout, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          background(context),
        ],
      ),
    );
  }

  Container background(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 255, 160, 80),
          Color.fromARGB(255, 250, 160, 0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
      child: imageScreen(context),
    );
  }

  Column imageScreen(BuildContext context) {
    return Column(
      children: [
        imageCenter(context),
        orangeFoot(),
        whiteFoot(),
      ],
    );
  }

  Padding whiteFoot() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
      child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            alignment: Alignment.topLeft,
            height: 70,
            width: 70,
            child: Image.asset('images/foot1.png'),
          )),
    );
  }

  Padding orangeFoot() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
      child: Align(
          alignment: Alignment.topRight,
          child: Container(
            alignment: Alignment.topRight,
            height: 70,
            width: 70,
            child: Image.asset('images/foot3.png'),
          )),
    );
  }

  Padding imageCenter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
      child: Container(
        alignment: Alignment.center,
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('images/Untitled-1.png'),
            ),
            Image.asset('images/textlove.png'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lovly_pet_app/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logOut(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  MaterialPageRoute rout = MaterialPageRoute(
    builder: (context) => const LoginPage(),
  );
  Navigator.pushAndRemoveUntil(context, rout, (route) => false);
}

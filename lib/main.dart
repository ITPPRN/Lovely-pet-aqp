import 'package:flutter/material.dart';
import 'package:lovly_pet_app/screen/splash_screen.dart';
import 'package:lovly_pet_app/unity/refresh_token.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      title: 'Lovely PET',
      home: const SplashScreen(),
    ),
  );
  RefreshToken().startFetchingDataPeriodically();
}

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:jwt_decode_full/jwt_decode_full.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefreshToken {
  void fetchDataFromApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    if (token != null) {
      final jwtData = jwtDecode(token);

      final int exp = jwtData.payload['exp'];

      // คำนวณเวลาปัจจุบันในรูปแบบ timestamp
      final int currentTimeInSeconds =
          DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

      int answer = exp - currentTimeInSeconds;

      if (answer < 1600) {
        refreshToken(token);
      }
    } else {
      print('Token is null, cannot fetch data.');
    }
  }

  Future<void> refreshToken(String? oldToken) async {
    final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.refreshToken}");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $oldToken',
        },
        // ระบุข้อมูลที่จำเป็นเพื่อขอ Token ใหม่ (อาจจะมีการส่ง Token เดิมไปด้วย)
      );

      if (response.statusCode == 200) {
        print('old = $oldToken');
        print('new = ${response.body}');
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('token', response.body);
      } else {
        throw Exception('ไม่สามารถขอ Token ใหม่ได้');
      }
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการขอ Token ใหม่: $e');
    }
  }

  Future<void> startFetchingDataPeriodically() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    if (token != null) {
      const Duration interval = Duration(minutes: 30);
      Timer.periodic(interval, (Timer timer) {
        fetchDataFromApi();
      });
    }
  }
}

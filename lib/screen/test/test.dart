import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:lovly_pet_app/unity/get_name_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final imageService = ImageService();

  String? token;
  Uint8List? imageData;

  List<String> images = [];

  Future<void> findU() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    setState(() {});
    gg();
  }

  @override
  void initState() {
    super.initState();
    findU();
  }

  void gg() async {
    try {
      images =
          await imageService.getImageName(token, SubPath.getListHotelImage, 1);
      setState(() {});
    } catch (e) {
      print("ผิดพลาดที่หน้านี้ $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // กำหนดแนวนอน
      child: Row(
        children: images.map((imageUrl) {
          return GestureDetector(
            onTap: () {
              print('กด $imageUrl');
            },
            child: FutureBuilder<dynamic>(
              future:
                  imageService.getImage(token, SubPath.getHotelImage, imageUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.memory(
                      snapshot.data!,
                      width: 300,
                    ),
                  );
                } else {
                  return Container(
                    height: 100,
                    width: 100,
                    color: Colors.amber,
                  );
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

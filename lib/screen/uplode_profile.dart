import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lovly_pet_app/screen/login_screen.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';

class UplodeProfile extends StatefulWidget {
  const UplodeProfile({super.key});

  @override
  State<UplodeProfile> createState() => _UplodeProfileState();
}

class _UplodeProfileState extends State<UplodeProfile> {
  int id4 = 1;
  int? id;
  File? image;

  // Future<void> findU() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   id = preferences.getInt('id')!;
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    //findU();
  }

  void navigateToLoginPage(BuildContext context) {
    final MaterialPageRoute<void> route = MaterialPageRoute(
      builder: (context) => const LoginPage(),
    );
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      route,
      (route) => false,
    );
  }

  var dio = Dio();

  Future<void> uploadImage() async {
    if (image == null) {
      errorDialog(context, 'กรุณาเพิ่มรูปภาพ');
      return;
    }
    var formData = FormData();
    formData.files.add(
      MapEntry(
        'file',
        await MultipartFile.fromFile(
          image!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      ),
    );
    formData.fields.add(
      MapEntry('id', id4.toString()),
    );
    try {
      // Send the form data to the backend
      await dio.post('${ApiRouter.pathAPI}/hotel/upload-image', data: formData);
      // ignore: use_build_context_synchronously
      navigateToLoginPage(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      errorDialog(context, '$e');
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('เพิ่มรูปโปรไฟลล์',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white)),
        ),
      ),
      body: buildBody(context),
    );
  }

  Column buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              displayImage(),
              groupButtonPickImage(),
            ],
          ),
        ),
        groupActionButton(context),
      ],
    );
  }

  Padding groupActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          skripButton(context),
          nextButton(),
        ],
      ),
    );
  }

  TextButton nextButton() {
    return TextButton(
      onPressed: () => uploadImage(),
      child: const Text(
        'ถัดไป',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromARGB(255, 255, 160, 0)),
      ),
    );
  }

  TextButton skripButton(BuildContext context) {
    return TextButton(
      onPressed: () => navigateToLoginPage(context),
      child: const Text(
        'ข้าม',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
      ),
    );
  }

  Padding groupButtonPickImage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          pickCamera(),
          pickGaller(),
        ],
      ),
    );
  }

  ElevatedButton pickGaller() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        minimumSize: const Size(150, 60),
      ),
      onPressed: pickImage,
      child: const Icon(
        Icons.image,
        size: 40,
      ),
    );
  }

  ElevatedButton pickCamera() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        minimumSize: const Size(150, 60),
      ),
      onPressed: pickImageFromCamera,
      child: const Icon(
        Icons.camera_alt_outlined,
        size: 40,
      ),
    );
  }

  Container displayImage() {
    return Container(
      width: 300,
      height: 300,
      decoration: const ShapeDecoration(
        color: Colors.grey,
        shape: CircleBorder(),
      ),
      child: image == null
          ? const Icon(
              Icons.person,
              size: 250,
            )
          : SizedBox(
              width: 250, // ปรับขนาดของ Container ให้เหมาะสม
              height: 250, // ปรับขนาดของ Container ให้เหมาะสม
              child: ClipOval(
                child: FittedBox(
                  fit: BoxFit
                      .cover, // ใช้ BoxFit.cover เพื่อปรับขนาดรูปให้เต็มตาม Container
                  child: Image.file(image!),
                ),
              ),
            ),
    );
  }
}

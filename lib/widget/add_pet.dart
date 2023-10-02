import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lovly_pet_app/model/pet_profile.dart';

class AddPet extends StatefulWidget {
  const AddPet({super.key});

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  final formKey = GlobalKey<FormState>();
  PetProfile petProfile = PetProfile();
  File? image;

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: buildListView(),
    );
  }

  ListView buildListView() {
    return ListView(
      children: [
        buildTextHeader(),
        buildBoxInputData(),
      ],
    );
  }

  Padding buildBoxInputData() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // สีพื้นหลังของ Container
          boxShadow: [
            BoxShadow(
              color: Colors.grey, // สีของเงา
              offset: Offset(0, 3), // ตำแหน่งเงาในแนวแกน x และ y
              blurRadius: 4, // ความคมชัดของเงา
              spreadRadius: 2, // การกระจายของเงา
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildComputImage(),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            "ชื่อ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                          child: TextFormField(
                            validator: RequiredValidator(
                                errorText: "กรุณากรอก ชื่อสัตว์เลี้ยง"),
                            onSaved: (name) {
                              petProfile.name = name;
                            },
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildLineUnderInput(),
                  Row(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            "ประเภท",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 130,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                          child: TextFormField(
                            validator: RequiredValidator(
                                errorText: "กรุณากรอก ประเภท"),
                            onSaved: (type) {
                              petProfile.type = type;
                            },
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildLineUnderInput(),
                  Row(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            "วันเกิด",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 130,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                          child: TextFormField(
                            validator: RequiredValidator(
                                errorText: "กรุณากรอก วันเกิด"),
                            onSaved: (birthday) {
                              petProfile.birthday = birthday;
                            },
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildLineUnderInput(),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding buildLineUnderInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        height: 1,
        color: Colors.black,
      ),
    );
  }

  Row buildComputImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [buildDisplayImage(), buildButtonPickImage()],
    );
  }

  Padding buildButtonPickImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [buildButtonPickImageFromCamera(), buildButtonPickGaller()],
      ),
    );
  }

  Padding buildButtonPickGaller() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Colors.amber.shade700), // สีพื้นหลัง
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
            ),
          ),
          elevation: MaterialStateProperty.all<double>(20),
          minimumSize: MaterialStateProperty.all<Size>(
              const Size(140, 50)), // ขนาดขั้นต่ำของปุ่ม
        ),
        onPressed: pickImage,
        child: const Icon(
          Icons.image,
          size: 40,
        ),
      ),
    );
  }

  ElevatedButton buildButtonPickImageFromCamera() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Colors.amber.shade700), // สีพื้นหลัง
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
          ),
        ),
        elevation: MaterialStateProperty.all<double>(20),
        minimumSize: MaterialStateProperty.all<Size>(
            const Size(140, 50)), // ขนาดขั้นต่ำของปุ่ม
      ),
      onPressed: pickImageFromCamera,
      child: const Icon(
        Icons.camera_alt_outlined,
        size: 40,
      ),
    );
  }

  Padding buildDisplayImage() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 150,
        height: 150,
        decoration: const ShapeDecoration(
          color: Colors.grey,
          shape: CircleBorder(),
        ),
        child: image == null
            ? const Icon(
                Icons.pets,
                size: 140,
              )
            : SizedBox(
                width: 130, // ปรับขนาดของ Container ให้เหมาะสม
                height: 130, // ปรับขนาดของ Container ให้เหมาะสม
                child: ClipOval(
                  child: FittedBox(
                    fit: BoxFit
                        .cover, // ใช้ BoxFit.cover เพื่อปรับขนาดรูปให้เต็มตาม Container
                    child: Image.file(image!),
                  ),
                ),
              ),
      ),
    );
  }

  Padding buildTextHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(10, 50, 0, 0),
      child: Text(
        'ข้อมูลสัตว์เลี้ยง',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

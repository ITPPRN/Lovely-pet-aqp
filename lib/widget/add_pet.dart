import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/pet_profile_j_to_d.dart';
import 'package:lovly_pet_app/model/pet_profile.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class AddPet extends StatefulWidget {
  final String? token;
  const AddPet({super.key, required this.token});

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  final format = DateFormat("dd/MM/yyyy");
  String? dateB;

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

  ////////////////////////////////////////////////////////////////
  Future<void> addData() async {
    if (widget.token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.addPet}");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: json.encode(
            {
              "name": petProfile.name,
              "birthday": petProfile.birthday,
              "type": petProfile.type
            },
          ),
        );

        if (response.statusCode == 200) {
          print(response.body);
          if (image != null) {
            PetProfileJToD petData =
                PetProfileJToD.fromJson(jsonDecode(response.body));
            uploadImage(petData.id);
          }
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));
          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} stats = ${response.statusCode}');
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(
            context, '$e'); // Return an empty list in case of an exception
      }
    } else {}
  }

  //////////////////////////////////////////////////////////////////
  var dio = Dio();

  Future<void> uploadImage(int? id) async {
    if (image == null) {
      return;
    }
    var formData = FormData();

    // Add the image file to the form data
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
      MapEntry('id', id.toString()),
    );

    try {
      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      // Send the form data to the backend
      await dio.post(
        '${ApiRouter.pathAPI}${SubPath.uploadImagePet}',
        data: formData,
        options: options,
      );
      print('Image uploaded successfully');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
  //////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: buildListView(),
      bottomNavigationBar: buildBottomAppBar(),
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.grey), // สีพื้นหลัง
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
                    ),
                  ),
                  elevation: MaterialStateProperty.all<double>(20),
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(120, 40)), // ขนาดขั้นต่ำของปุ่ม
                ),
                onPressed: () {
                  cancelDialog(context, 'ยกเลิกการเพิ่มข้อมูลสัตว์เลี้ยง');
                },
                child: const Text(
                  'ยกเลิก',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.amber.shade700), // สีพื้นหลัง
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
                    ),
                  ),
                  elevation: MaterialStateProperty.all<double>(20),
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(120, 40)), // ขนาดขั้นต่ำของปุ่ม
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState?.save();
                    formKey.currentState?.reset();
                    addData();
                  }
                },
                child: const Text(
                  'บันทึก',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ));
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
                          padding: const EdgeInsets.fromLTRB(10, 5, 20, 0),
                          child: TextFormField(
                            controller: TextEditingController(
                                text: dateB), // กำหนดค่าเริ่มต้นจาก petProfile
                            readOnly: true, // ทำให้ไม่สามารถแก้ไขค่าได้โดยตรง
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(), // กำหนดวันเริ่มต้น
                                firstDate: DateTime(1900), // กำหนดวันแรก
                                lastDate: DateTime(2100), // กำหนดวันสุดท้าย
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  dateB = DateFormat('dd/MM/yyyy')
                                      .format(pickedDate)
                                      .toString(); // เมื่อเลือกวันที่แล้วให้กำหนดค่าใน petProfile
                                });
                                // อัพเดตค่า pickedDate ด้วยค่าใหม่ที่เลือก
                                // this.pickedDate = pickedDate;
                              }
                            },
                            decoration: const InputDecoration(
                              border:
                                  InputBorder.none, // ซ่อนเส้นขอบของ TextField
                            ),
                            onSaved: (date) {
                              // อัพเดตค่า petProfile.birthday ด้วยค่าวันที่ที่เลือกใน date
                              petProfile.birthday = date;
                            },
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

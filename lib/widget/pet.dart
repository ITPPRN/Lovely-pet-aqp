import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/pet_profile_j_to_d.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:lovly_pet_app/unity/get_name_image.dart';
import 'package:lovly_pet_app/widget/add_pet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetList extends StatefulWidget {
  const PetList({super.key});

  @override
  State<PetList> createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  String? token;
  List<PetProfileJToD> pets = [];

  final imageService = ImageService();

  Future<void> findU() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    setState(() {});
    // await getData();
  }

  //////////////////////////////////////////////////////////
  Future<void> getData1() async {
    if (token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.getMyPet}");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> jsonList = jsonDecode(response.body);
          pets = jsonList.map((json) => PetProfileJToD.fromJson(json)).toList();
          setState(() {}); // รีเฟรชหน้าจอ
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));
          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} stats = ${response.statusCode}');
          return; // ออกจากฟังก์ชันในกรณีข้อผิดพลาด
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(context, '$e');
        return; // ออกจากฟังก์ชันในกรณีข้อผิดพลาด
      }
    } else {
      return; // ออกจากฟังก์ชันถ้า token เป็น null
    }
  }

  //////////////////////////////////////////////////////////
  Future<List<PetProfileJToD>> getData() async {
    if (token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.getMyPet}");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> jsonList = jsonDecode(response.body);
          pets = jsonList.map((json) => PetProfileJToD.fromJson(json)).toList();
          return pets; // Return the list of clinics
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));
          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} stats = ${response.statusCode}');
          return []; // Return an empty list in case of an error
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(context, '$e');
        return []; // Return an empty list in case of an exception
      }
    } else {
      return [];
    }
  }
  //////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    findU();
  }

  void navigateAddPet() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddPet(token: token);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPetList(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  ///////////////////////////////////////////////////////
  FutureBuilder<List<PetProfileJToD>> buildPetList() {
    return FutureBuilder<List<PetProfileJToD>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // ในขณะที่รอข้อมูล
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // หากเกิดข้อผิดพลาด
          return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // หากไม่มีข้อมูลหรือข้อมูลว่างเปล่า
          return const Text('ไม่มีรายชื่อคลีนิก');
        } else {
          // หากมีข้อมูลและไม่มีข้อผิดพลาด
          return RefreshIndicator(
            onRefresh: getData1,
            child: buildListView(snapshot),
          );
        }
      },
    );
  }

  ListView buildListView(AsyncSnapshot<List<PetProfileJToD>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final clinic = snapshot.data![index];

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              buildComponentPets(clinic, context),
            ],
          ),
        );
      },
    );
  }

  GestureDetector buildComponentPets(
      PetProfileJToD clinic, BuildContext context) {
    String? ageText;
    ageText = calculateAge(clinic.birthday);
    return GestureDetector(
      onTap: () {
        //navigate(clinic);
      },
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildImageProfilePet(clinic),
                  Text(
                    ageText,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ชื่อ: ${clinic.petName}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'ประเภท: ${clinic.petTyName}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'วันเกิด: ${clinic.birthday}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildImageProfilePet(PetProfileJToD clinic) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 100,
        height: 100,
        decoration: const ShapeDecoration(
          color: Colors.grey,
          shape: CircleBorder(),
        ),
        child: clinic.photoPath == null
            ? const Icon(
                Icons.pets,
                size: 90,
              )
            : SizedBox(
                width: 90, // ปรับขนาดของ Container ให้เหมาะสม
                height: 90, // ปรับขนาดของ Container ให้เหมาะสม
                child: ClipOval(
                  child: FittedBox(
                    fit: BoxFit
                        .cover, // ใช้ BoxFit.cover เพื่อปรับขนาดรูปให้เต็มตาม Container
                    child: FutureBuilder<dynamic>(
                      future: imageService.getImagePet(
                          token, SubPath.getPetImage, clinic.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white, // สีพื้นหลังของ Container
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey, // สีของเงา
                                  offset: Offset(
                                      0, 3), // ตำแหน่งเงาในแนวแกน x และ y
                                  blurRadius: 4, // ความคมชัดของเงา
                                  spreadRadius: 2, // การกระจายของเงา
                                ),
                              ],
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: Image.memory(
                              snapshot.data!,
                            ),
                          );
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            color: Colors.amber,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  ///////////////////////////////////////////////////////
  // สร้างฟังก์ชันสำหรับคำนวณอายุ
  String calculateAge(String? birthday) {
    // แปลงวันที่เป็นรูปแบบที่ถูกต้อง
    List<String> dateParts = birthday!.split('/');
    String formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
    // วันที่ที่เป็น String
    DateTime birthDate = DateTime.parse(formattedDate);

    // คำนวณอายุ
    DateTime currentDate = DateTime.now();
    int years = currentDate.year - birthDate.year;
    int months = currentDate.month - birthDate.month;
    int days = currentDate.day - birthDate.day;

    if (currentDate.day < birthDate.day) {
      months--;
    }

    // แสดงผลลัพธ์
    String ageText;
    if (years >= 1) {
      ageText = 'อายุ $years ปี';
    } else if (months >= 1) {
      ageText = 'อายุ $months เดือน';
    } else if (days >= 1) {
      ageText = 'อายุ $days วัน';
    } else {
      ageText = 'อายุน้อยกว่า 1 วัน';
    }

    return ageText;
  }
  //////////////////////////////////////////////////////

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        navigateAddPet();
      },
      child: const Icon(Icons.add), // ใส่ไอคอนในปุ่ม
    );
  }
}

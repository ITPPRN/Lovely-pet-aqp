import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/list_clinic.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:lovly_pet_app/unity/get_name_image.dart';
import 'package:lovly_pet_app/widget/data_clinic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClinicList extends StatefulWidget {
  const ClinicList({Key? key}) : super(key: key);

  @override
  State<ClinicList> createState() => _ClinicListState();
}

class _ClinicListState extends State<ClinicList> {
  String? token;
  String? username;
  String? password;
  List<ListClinicModel> hotels = [];

  final imageService = ImageService();

  Future<void> findU() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    username = preferences.getString('userName');
    password = preferences.getString('passWord');
    setState(() {});
    // await getData();
  }

  /////////////////////////////////////
  Future<void> postData() async {
    final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.login}");
    try {
      //print("sent data");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'userName': username,
            'passWord': password,
          },
        ),
      ); // ข้อมูลที่จะส่ง

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        routSer(response.body, context);
      } else {
        ExceptionLogin exceptionModel =
            ExceptionLogin.fromJson(jsonDecode(response.body));
        // ignore: use_build_context_synchronously
        errorDialog(context, '${exceptionModel.error}');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      errorDialog(context, '$e');
    }
  }

  Future<void> routSer(String token, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', token);
    findU();
  }

  ////////////////////////////////////

  Future<List<String>> getNameListImages(int? id) async {
    try {
      List<String> nameImages1 =
          await imageService.getImageName(token, SubPath.getListHotelImage, id);
      return nameImages1;
    } catch (e) {
      // ignore: use_build_context_synchronously
      errorDialog(context, 'getNameListImages = $e');
      return [];
    }
  }

  Future<List<ListClinicModel>> getData() async {
    if (token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.getHotelList}");
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
          hotels =
              jsonList.map((json) => ListClinicModel.fromJson(json)).toList();
          return hotels; // Return the list of clinics
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));
          if (exceptionModel.error == "Forbidden") {
            postData();
            //findU();
          } else {
            // ignore: use_build_context_synchronously
            errorDialog(context,
                '${exceptionModel.error} stats = ${response.statusCode}');
          }
          return [];
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

  @override
  void initState() {
    super.initState();
    findU();
  }

  void navigate(ListClinicModel? id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DataClinic(
        id: id,
        token: token,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildClinicList(),
    );
  }

  FutureBuilder<List<ListClinicModel>> buildClinicList() {
    return FutureBuilder<List<ListClinicModel>>(
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
          return buildListView(snapshot);
        }
      },
    );
  }

  ListView buildListView(AsyncSnapshot<List<ListClinicModel>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final clinic = snapshot.data![index];

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              buildImages(clinic),
              buildComponentClinic(clinic, context),
            ],
          ),
        );
      },
    );
  }

  GestureDetector buildComponentClinic(
      ListClinicModel clinic, BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(clinic);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textNameClenic(clinic),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: buildStarRating(clinic),
                ),
                buildTestLocation(clinic)
              ],
            ),
            buildValueReview(clinic)
          ],
        ),
      ),
    );
  }

  Padding buildValueReview(ListClinicModel clinic) {
    List<String> stringList = [
      "ไม่มีคะแนน",
      "แย่",
      "พอใช้",
      "ดี",
      "ดีมาก",
      "ดีเยี่ยม"
    ];
    String text = stringList[clinic.rating!.floor()];
    String level = '${clinic.rating!.toStringAsFixed(1)} $text';

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text("$level จำนวนรีวิว"),
      ),
    );
  }

  Padding buildTestLocation(ListClinicModel clinic) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 50),
            child: Icon(Icons.location_on),
          ),
          Text('ที่อยู่: ${clinic.location}'),
        ],
      ),
    );
  }

  List<Widget> buildStarRating(ListClinicModel clinic) {
    return List.generate(clinic.rating!.floor(), (index) {
      return const Icon(Icons.star,
          color: Colors.yellow, size: 30); // แสดงดาวสีเหลืองขนาด 30 พิกเซล
    });
  }

  Padding textNameClenic(ListClinicModel clinic) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        '${clinic.hotelName}',
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////
  FutureBuilder<List<String>> buildImages(ListClinicModel clinic) {
    return FutureBuilder<List<String>>(
      future: getNameListImages(clinic.id),
      builder: (context, snapshot) {
        //final images = snapshot.data![index];
        if (snapshot.connectionState == ConnectionState.waiting) {
          // ในขณะที่รอข้อมูล
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // หากเกิดข้อผิดพลาด
          return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // หากไม่มีข้อมูลหรือข้อมูลว่างเปล่า
          return fakeImage(context);
        } else {
          List<String> images = snapshot.data!;
          // หากมีข้อมูลและไม่มีข้อผิดพลาด
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // กำหนดแนวนอน
            child: Row(
              children: images.map((imageUrl) {
                return GestureDetector(
                  onTap: () {
                    navigate(clinic);
                  },
                  child: FutureBuilder<dynamic>(
                    future: imageService.getImage(
                        token, SubPath.getHotelImage, imageUrl),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                offset:
                                    Offset(0, 3), // ตำแหน่งเงาในแนวแกน x และ y
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
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }

  Container fakeImage(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context)
          .size
          .width, // ทำให้ container ขยายตามความกว้างของหน้าจอ
      padding: const EdgeInsets.all(16.0), // กำหนด padding ตามความต้องการ
      decoration: const BoxDecoration(
        color: Colors.amber, // สีพื้นหลังของ Container
        boxShadow: [
          BoxShadow(
            color: Colors.grey, // สีของเงา
            offset: Offset(0, 3), // ตำแหน่งเงาในแนวแกน x และ y
            blurRadius: 4, // ความคมชัดของเงา
            spreadRadius: 2, // การกระจายของเงา
          ),
        ],
      ),
    );
  }
}

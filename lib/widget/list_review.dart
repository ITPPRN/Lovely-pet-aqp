import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/review_json_to_dart.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';

import '../unity/get_name_image.dart';

class ListReview extends StatefulWidget {
  final String? token;
  final String? hotelName;
  final int? id;

  const ListReview(
      {super.key,
      required this.id,
      required this.token,
      required this.hotelName});

  @override
  State<ListReview> createState() => _ListReviewState();
}

class _ListReviewState extends State<ListReview> {
  List<ReviewJsonToDart> listReview = [];
  final imageService = ImageService();

  Future<List<ReviewJsonToDart>> getData() async {
    if (widget.token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.listReview}");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: json.encode(
            {
              'id': widget.id,
            },
          ),
        );

        if (response.statusCode == 200) {
          final List<dynamic> jsonList = jsonDecode(response.body);
          listReview =
              jsonList.map((json) => ReviewJsonToDart.fromJson(json)).toList();
          return listReview; // Return the list of clinics
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));

          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} stats = ${response.statusCode}');

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

  Future<void> getData1() async {
    if (widget.token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.getMyPet}");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> jsonList = jsonDecode(response.body);
          listReview =
              jsonList.map((json) => ReviewJsonToDart.fromJson(json)).toList();
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

  @override
  void initState() {
    super.initState();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4, // ความสูงของเงาของการ์ด
                margin: const EdgeInsets.all(8), // ระยะห่างของการ์ดจากขอบอื่น ๆ
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // รูปร่างของการ์ด
                ),
                child: SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, // กำหนดความกว้างของการ์ด
                  height: 100, // กำหนดความสูงของการ์ด
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    // ระยะห่างของเนื้อหาภายในการ์ด
                    child: Center(
                      child: Text(
                        'สถานบริการรับฝากสัตว์เลี้ยง: ${widget.hotelName}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )),
          const Padding(
            padding: EdgeInsets.only(left: 30, bottom: 8, right: 8, top: 8),
            child: Text(
              'รีวิวสถานรับฝากสัตว์เลี้ยง',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: buildPetList(),
          ),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////
  FutureBuilder<List<ReviewJsonToDart>> buildPetList() {
    return FutureBuilder<List<ReviewJsonToDart>>(
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

  ListView buildListView(AsyncSnapshot<List<ReviewJsonToDart>> snapshot) {
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
      ReviewJsonToDart clinic, BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ผู้รีวิว: ${clinic.nameUser}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  buildImageProfile(clinic),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                ' ${clinic.comment}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      // แสดงดาวจากข้อมูล rating
                      ...List.generate(clinic.rating!.floor(), (index) {
                        return const Icon(Icons.star,
                            color: Colors.yellow,
                            size: 30); // แสดงดาวสีเหลืองขนาด 30 พิกเซล
                      }),
                      // แสดงดาวเปล่าที่ไม่มีคะแนน
                      ...List.generate(5 - clinic.rating!.floor(), (index) {
                        return const Icon(Icons.star_border,
                            color: Colors.grey,
                            size: 30); // แสดงดาวเปล่าสีเทาขนาด 30 พิกเซล
                      }),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

/*
* Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ผู้รีวิว: ${clinic.nameUser}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      ' ${clinic.comment}',
                      style: const TextStyle(
                          fontSize: 20,),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5,right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildImageProfile(clinic),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                        children: [
                          // แสดงดาวจากข้อมูล rating
                          ...List.generate(clinic.rating!.floor(), (index) {
                            return const Icon(Icons.star,
                                color: Colors.yellow,
                                size: 30); // แสดงดาวสีเหลืองขนาด 30 พิกเซล
                          }),
                          // แสดงดาวเปล่าที่ไม่มีคะแนน
                          ...List.generate(5 - clinic.rating!.floor(), (index) {
                            return const Icon(Icons.star_border,
                                color: Colors.grey,
                                size: 30); // แสดงดาวเปล่าสีเทาขนาด 30 พิกเซล
                          }),
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),*/
  Padding buildImageProfile(ReviewJsonToDart clinic) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 50,
        height: 50,
        decoration: const ShapeDecoration(
          color: Colors.grey,
          shape: CircleBorder(),
        ),
        child: clinic.imageUser == null
            ? const Icon(
                Icons.person,
                size: 40,
              )
            : SizedBox(
                width: 90, // ปรับขนาดของ Container ให้เหมาะสม
                height: 90, // ปรับขนาดของ Container ให้เหมาะสม
                child: ClipOval(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    // ใช้ BoxFit.cover เพื่อปรับขนาดรูปให้เต็มตาม Container
                    child: FutureBuilder<dynamic>(
                      future: imageService.getImagePet(
                          widget.token, SubPath.getPetImage, clinic.id),
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
}

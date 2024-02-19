import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/booking_list_j_to_d.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:lovly_pet_app/widget/review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list_room.dart';

class HistoryService extends StatefulWidget {
  const HistoryService({Key? key}) : super(key: key);

  @override
  State<HistoryService> createState() => _HistoryServiceState();
}

class _HistoryServiceState extends State<HistoryService> {
  String? token;
  List<BookingListJToD> bookings = [];


  void navigateReview(BookingListJToD? booking) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Rating(
        booking: booking!,
        token: token,
      );
    }));
  }

  Future<List<BookingListJToD>> getData() async {
    if (token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.history}");
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
          bookings =
              jsonList.map((json) => BookingListJToD.fromJson(json)).toList();
          return bookings; // Return the list of clinics
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

  Future<void> findU() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    setState(() {});
    // await getData();
  }

  @override
  void initState() {
    super.initState();
    findU();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildBoxTextHead(),
            buildImageHead(),
            buildBookingList(),
          ],
        ),
      ),
    );
  }

  Image buildImageHead() {
    return Image.asset(
      'images/rec.png',
      width: 150,
      height: 150,
    );
  }

  Padding buildBoxTextHead() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 100,
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
        child: const Center(
          child: Text(
            'ประวัติการใช้บริการ',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  void navigateReBook(BookingListJToD? booking) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ListRoom(id: booking!.hotelId,token: token,);
    }));
  }

  FutureBuilder<List<BookingListJToD>> buildBookingList() {
    return FutureBuilder<List<BookingListJToD>>(
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

  ListView buildListView(AsyncSnapshot<List<BookingListJToD>> snapshot) {
    return ListView.builder(
      shrinkWrap: true, // จัดหน้าประวัติให้ไม่มีข้อผิดพลาด
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final clinic = snapshot.data![index];

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: buildComponentBookingList(clinic, context),
        );
      },
    );
  }

  GestureDetector buildComponentBookingList(
      BookingListJToD clinic, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigate(clinic);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListTile(
            title: Text('Clinic name: ${clinic.nameHotel}'),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('room number: ${clinic.roomNumber}'),
                Text(
                    'start: ${clinic.bookingStartDate} - end: ${clinic.bookingEndDate}'),
                Text('pet: ${clinic.pet!.petName}'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible:
                          !clinic.feedback!, // ระบุว่าจะแสดงหรือซ่อน TextButton
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            navigateReview(clinic);
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                'images/score.png',
                                width: 50,
                                height: 50,
                              ),
                              const Text(
                                'ให้คะแนน',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.amber.shade700), // สีพื้นหลัง
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
                            ),
                          ),
                          elevation: MaterialStateProperty.all<double>(20),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(100, 40)), // ขนาดขั้นต่ำของปุ่ม
                        ),
                        onPressed: () {
                          navigateReBook(clinic);
                        },
                        child: const Text(
                          'จองอีกครั้ง',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

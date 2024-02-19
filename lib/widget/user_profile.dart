import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/booking_list_j_to_d.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/user_profile_j_to_d.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:lovly_pet_app/widget/approve_widget.dart';
import 'package:lovly_pet_app/widget/cancle_widget.dart';
import 'package:lovly_pet_app/widget/edit_profile.dart';
import 'package:lovly_pet_app/widget/success_widget.dart';
import 'package:lovly_pet_app/widget/waite_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../unity/get_name_image.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? image;
  String? token;
  UserProfileJToD? profile;
  final imageService = ImageService();
  List<BookingListJToD> bookings = [];
  List<BookingListJToD> cancelBookings = [];
  List<BookingListJToD> successBookings = [];
  List<BookingListJToD> waitBookings = [];
  List<BookingListJToD> approveBooking = [];
  List<BookingListJToD> disapprovalBookings = [];

  Future<void> getBooking() async {
    if (token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.getBookingList}");
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

          cancelBookings =
              bookings.where((booking) => booking.state == "cancel").toList();
          successBookings =
              bookings.where((booking) => booking.state == "complete").toList();
          waitBookings =
              bookings.where((booking) => booking.state == "waite").toList();
          approveBooking =
              bookings.where((booking) => booking.state == "approve").toList();
          disapprovalBookings = bookings
              .where((booking) => booking.state == "disapproval")
              .toList();

          setState(() {});
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));

          if (exceptionModel.error != 'booking.booking.not.found') {
            // ignore: use_build_context_synchronously
            errorDialog(context,
                '${exceptionModel.error} stats = ${response.statusCode}');
          }
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(context, '$e');
      }
    }
  }

  Future<void> findU() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    setState(() {});
    getData();
    getBooking();
  }

  Future<void> getData() async {
    if (token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.getMyProfile}");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          profile = UserProfileJToD.fromJson(jsonDecode(response.body));
          setState(() {});
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));
          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} stats = ${response.statusCode}');
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(context, '$e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    findU();
  }

  void navigateAddPet() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditProfile(
        token: token,
      );
    }));
  }

  void navigateState(Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildListView());
  }

  Padding buildListView() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
      child: ListView(
        children: [
          buildHead(),
          buildTextStateService(),
          buildMenuBarStateService(),
          buildComponentTextUser(),
        ],
      ),
    );
  }

  Padding buildComponentTextUser() {
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
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'ข้อมูลผู้ใช้',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'ชื่อ-สกุล : ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        profile?.name == null ? '' : profile!.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                buildLineUnderInput(),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      const Text(
                        'อีเมลล์ : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          profile?.email == null ? '' : profile!.email!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                buildLineUnderInput(),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      const Text(
                        'เบอร์โทร : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          profile?.phoneNumber == null
                              ? ''
                              : profile!.phoneNumber!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: buildLineUnderInput(),
                ),
              ],
            ),
          )),
    );
  }

  Padding buildLineUnderInput() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        height: 1,
        color: Colors.black,
      ),
    );
  }

  Padding buildMenuBarStateService() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          //height: 100,
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
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildWait(),
                buildApprove(),
                buildRecord(),
                buildCancle(),
              ],
            ),
          )),
    );
  }

  Padding buildCancle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          navigateState(CancleWidget(
            cancelBookings: cancelBookings,
            token: token,
          ));
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Image.asset(
                        'images/cancle.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const Text('ยกเลิก'),
                  ], // ชิดด้านล่าง
                ),
              ],
            ),
            Visibility(
              visible: cancelBookings
                  .isNotEmpty, // แสดง Container ถ้า cancelBookings ไม่ว่าง
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 255, 13, 0), // สีพื้นหลังของ Container
                  borderRadius:
                      BorderRadius.circular(8), // รูปร่างของ Container
                ),
                child: Text(
                  cancelBookings.length
                      .toString(), // แสดงจำนวนรายการใน cancelBookings
                  style: const TextStyle(
                    color: Colors.white, // สีข้อความ
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        // ตั้งค่าการจัดตำแหน่งข้อความภายใน InkWell
      ),
    );
  }

  Padding buildRecord() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          navigateState(SuccessWidget(
            succeedBooking: successBookings,
            token: token,
          ));
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    'images/record.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                const Text('สำเร็จ'),
              ], // ชิดด้านล่าง
            ),
            Visibility(
              visible: successBookings
                  .isNotEmpty, // แสดง Container ถ้า cancelBookings ไม่ว่าง
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 255, 13, 0), // สีพื้นหลังของ Container
                  borderRadius:
                      BorderRadius.circular(8), // รูปร่างของ Container
                ),
                child: Text(
                  successBookings.length
                      .toString(), // แสดงจำนวนรายการใน cancelBookings
                  style: const TextStyle(
                    color: Colors.white, // สีข้อความ
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        // ตั้งค่าการจัดตำแหน่งข้อความภายใน InkWell
      ),
    );
  }

  Padding buildApprove() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          navigateState(ApproveWidget(
            approveBooking: approveBooking,
          ));
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    'images/approve.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                const Text('อนุมัติ'),
              ], // ชิดด้านล่าง
            ),
            Visibility(
              visible: approveBooking
                  .isNotEmpty, // แสดง Container ถ้า cancelBookings ไม่ว่าง
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 255, 13, 0), // สีพื้นหลังของ Container
                  borderRadius:
                      BorderRadius.circular(8), // รูปร่างของ Container
                ),
                child: Text(
                  approveBooking.length
                      .toString(), // แสดงจำนวนรายการใน cancelBookings
                  style: const TextStyle(
                    color: Colors.white, // สีข้อความ
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        // ตั้งค่าการจัดตำแหน่งข้อความภายใน InkWell
      ),
    );
  }

  Padding buildWait() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          navigateState(WaiteWidget(
            waitBookings: waitBookings,
            disapprovalBookings: disapprovalBookings,
            token: token,
          ));
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'images/wait.png',
                  height: 60,
                  width: 70,
                ),
                const Text('รออนุมัติ'),
              ], // ชิดด้านล่าง
            ),
            Visibility(
              visible: waitBookings.isNotEmpty ||
                  disapprovalBookings
                      .isNotEmpty, // แสดง Container ถ้า cancelBookings ไม่ว่าง
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 255, 13, 0), // สีพื้นหลังของ Container
                  borderRadius:
                      BorderRadius.circular(8), // รูปร่างของ Container
                ),
                child: Text(
                  (waitBookings.length + disapprovalBookings.length)
                      .toString(), // แสดงจำนวนรายการใน cancelBookings
                  style: const TextStyle(
                    color: Colors.white, // สีข้อความ
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        // ตั้งค่าการจัดตำแหน่งข้อความภายใน InkWell
      ),
    );
  }

  Padding buildTextStateService() {
    return const Padding(
      padding: EdgeInsets.only(top: 20, left: 20),
      child: Text(
        'สถานะการบริการ',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Row buildHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildImage(),
        buildTextNexToImage(),
      ],
    );
  }

  Padding buildTextNexToImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile?.email == null ? '' : profile!.email!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(profile?.name == null ? '' : profile!.name!),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 2),
            child: InkWell(
              onTap: () {
                navigateAddPet();
              },
              child: Text(
                'แก้ไขข้อมูล >',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.amber.shade600, fontWeight: FontWeight.bold),
              ),
              // ตั้งค่าการจัดตำแหน่งข้อความภายใน InkWell
            ),
          ),
        ],
      ),
    );
  }

  Container buildImage() {
    String? photo;
    if (profile != null) {
      photo = profile!.userPhoto;
    }
    return Container(
      width: 150,
      height: 150,
      decoration: const ShapeDecoration(
        color: Colors.grey,
        shape: CircleBorder(),
      ),
      child: photo == null
          ? const Icon(
              Icons.person,
              size: 140,
            )
          : SizedBox(
              width: 90, // ปรับขนาดของ Container ให้เหมาะสม
              height: 90, // ปรับขนาดของ Container ให้เหมาะสม
              child: ClipOval(
                child: FittedBox(
                  fit: BoxFit
                      .cover, // ใช้ BoxFit.cover เพื่อปรับขนาดรูปให้เต็มตาม Container
                  child: FutureBuilder<dynamic>(
                    future: imageService.getImageProfile(token),
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
                          height: 200,
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
    );
  }
}

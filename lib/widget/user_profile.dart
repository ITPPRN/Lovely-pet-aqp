import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/user_profile_j_to_d.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:lovly_pet_app/widget/approve_widget.dart';
import 'package:lovly_pet_app/widget/cancle_widget.dart';
import 'package:lovly_pet_app/widget/edit_profile.dart';
import 'package:lovly_pet_app/widget/succeed_widget.dart';
import 'package:lovly_pet_app/widget/waite_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? image;
  String? token;
  UserProfileJToD? profile;

  Future<void> findU() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    setState(() {});
    getData();
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
      return const EditProfile();
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
          navigateState(const CancleWidget());
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
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red, // สีพื้นหลังของกรอบสี่เหลี่ยม
                borderRadius:
                    BorderRadius.circular(8), // ปรับรูปร่างของกรอบสี่เหลี่ยม
              ),
              child: const Text(
                '5', // แทนด้วยตัวเลขที่คุณต้องการแสดง
                style: TextStyle(
                  color: Colors.white, // สีข้อความ
                  fontWeight: FontWeight.bold,
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
          navigateState(const SucceedWidget());
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
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red, // สีพื้นหลังของกรอบสี่เหลี่ยม
                borderRadius:
                    BorderRadius.circular(8), // ปรับรูปร่างของกรอบสี่เหลี่ยม
              ),
              child: const Text(
                '5', // แทนด้วยตัวเลขที่คุณต้องการแสดง
                style: TextStyle(
                  color: Colors.white, // สีข้อความ
                  fontWeight: FontWeight.bold,
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
          navigateState(const ApproveWidget());
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
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red, // สีพื้นหลังของกรอบสี่เหลี่ยม
                borderRadius:
                    BorderRadius.circular(8), // ปรับรูปร่างของกรอบสี่เหลี่ยม
              ),
              child: const Text(
                '5', // แทนด้วยตัวเลขที่คุณต้องการแสดง
                style: TextStyle(
                  color: Colors.white, // สีข้อความ
                  fontWeight: FontWeight.bold,
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
          navigateState(const WaiteWidget());
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
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red, // สีพื้นหลังของกรอบสี่เหลี่ยม
                borderRadius:
                    BorderRadius.circular(8), // ปรับรูปร่างของกรอบสี่เหลี่ยม
              ),
              child: const Text(
                '5', // แทนด้วยตัวเลขที่คุณต้องการแสดง
                style: TextStyle(
                  color: Colors.white, // สีข้อความ
                  fontWeight: FontWeight.bold,
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
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile?.email == null ? '' : profile!.email!,
            style: const TextStyle(fontSize: 20),
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
    return Container(
      width: 150,
      height: 150,
      decoration: const ShapeDecoration(
        color: Colors.grey,
        shape: CircleBorder(),
      ),
      child: image == null
          ? const Icon(
              Icons.person,
              size: 140,
            )
          : SizedBox(
              width: 140, // ปรับขนาดของ Container ให้เหมาะสม
              height: 140, // ปรับขนาดของ Container ให้เหมาะสม
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

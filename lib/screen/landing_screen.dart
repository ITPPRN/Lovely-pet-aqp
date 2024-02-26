import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lovly_pet_app/screen/test/map.dart';
import 'package:lovly_pet_app/unity/log_out.dart';
import 'package:lovly_pet_app/widget/clinic_list.dart';
import 'package:lovly_pet_app/widget/history_service.dart';
import 'package:lovly_pet_app/widget/list_booking.dart';
import 'package:lovly_pet_app/widget/pet.dart';
import 'package:lovly_pet_app/widget/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/exception_login.dart';
import '../model/json-to-dart-model/user_profile_j_to_d.dart';
import '../unity/alert_dialog.dart';
import '../unity/api_router.dart';

class LandingPage extends StatefulWidget {
  final Widget widget;

  const LandingPage({super.key, required this.widget});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Widget currentWidget = const ClinicList();
  String? token;
  UserProfileJToD? profile;


  void setCurrentWidget(Widget? widget) {
    currentWidget = widget!;
    setState(() {});
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

  Future<void> findU() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('token');
    });
  }

  @override
  void initState() {
    super.initState();
    findU();
    setCurrentWidget(widget.widget);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            headDrawer(),
            clinicList(),
            userProfile(),
            petList(),
            listBooking(),
            historyService(),
            singOut(),
          ],
        ),
      );

  UserAccountsDrawerHeader headDrawer() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/bg_dr.jpg'), fit: BoxFit.cover),
      ),
      currentAccountPicture: Container(
        width: 100,
        height: 100,
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: CircleBorder(),
          image: DecorationImage(
              image: AssetImage('images/Untitled-1.png'), fit: BoxFit.fill),
        ),
      ),
      accountName: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(
          "",
          style: TextStyle(color: Colors.white),
        ),
      ),
      accountEmail:const  Padding(
        padding:  EdgeInsets.only(left: 10),
        child: Text('Welcome',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),)
      ),
    );
  }

  ListTile clinicList() {
    return ListTile(
      leading: const Icon(Icons.home),
      title: const Text("หน้าหลัก"),
      onTap: () {
        currentWidget = const ClinicList();
        setState(() {});

        Navigator.pop(context);
      },
    );
  }

  ListTile userProfile() {
    return ListTile(
      leading: const Icon(Icons.person_2_outlined),
      title: const Text("ข้อมูลผู้ใช้"),
      onTap: () {
        currentWidget = const UserProfile();
        setState(() {});

        Navigator.pop(context);
      },
    );
  }

  ListTile petList() {
    return ListTile(
      leading: const Icon(Icons.pets),
      title: const Text("รายชื่อสัตว์เลี้ยง"),
      onTap: () {
        currentWidget = const PetList();
        setState(() {});

        Navigator.pop(context);
      },
    );
  }

  ListTile listBooking() {
    return ListTile(
      leading: const Icon(Icons.feed_outlined),
      title: const Text("รายการจอง"),
      onTap: () {
        currentWidget = const ListBooking();
        setState(() {});

        Navigator.pop(context);
      },
    );
  }

  ListTile historyService() {
    return ListTile(
      leading: const Icon(Icons.history),
      title: const Text("ประวัติการรับบริการ"),
      onTap: () {
        currentWidget = const HistoryService();
        setState(() {});

        Navigator.pop(context);
      },
    );
  }

  ListTile aa() {
    return ListTile(
      leading: const Icon(Icons.temple_buddhist_outlined),
      title: const Text("aa"),
      onTap: () {
        currentWidget = const MapScreen();
        setState(() {});

        Navigator.pop(context);
      },
    );
  }

  ListTile singOut() {
    return ListTile(
      leading: const Icon(Icons.exit_to_app),
      //icon: Icon(Icons.exit_to_app), onPressed: () => logOut(context))
      title: const Text("ออกจากระบบ"),
      onTap: () => logOut(context),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lovly_pet_app/screen/test/map.dart';
import 'package:lovly_pet_app/unity/log_out.dart';
import 'package:lovly_pet_app/widget/clinic_list.dart';
import 'package:lovly_pet_app/widget/history_service.dart';
import 'package:lovly_pet_app/widget/list_booking.dart';
import 'package:lovly_pet_app/widget/pet.dart';
import 'package:lovly_pet_app/widget/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  final Widget widget;

  const LandingPage({super.key, required this.widget});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Widget currentWidget = const ClinicList();
  String? token;

  void setCurrentWidget(Widget? widget) {
    currentWidget = widget!;
    setState(() {});
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
            headeDrawer(),
            clinicList(),
            userProfile(),
            petList(),
            listBooking(),
            historyService(),
            aa(),
            singOut(),
          ],
        ),
      );

  UserAccountsDrawerHeader headeDrawer() {
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
      accountEmail: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(
          "Wellcome",
          style: TextStyle(color: Colors.white),
        ),
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

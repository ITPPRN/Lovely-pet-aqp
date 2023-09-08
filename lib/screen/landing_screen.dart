import 'package:flutter/material.dart';
import 'package:lovly_pet_app/unity/log_out.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Widget currentWidget = LandingPage();
  String? token;

  Future<void> findU() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('token');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findU();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Landing Page"),
      ),
      drawer: showDrawer(),
      body: Center(
        child: Text(token == null ? 'Landing' : '$token'),
      ),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            headeDrawer(),
            clinicList(),
            userDataList(),
            shoppingCart(),
            singOut()
          ],
        ),
      );

  UserAccountsDrawerHeader headeDrawer() {
    return UserAccountsDrawerHeader(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg_dr.jpg'), fit: BoxFit.cover)),
        currentAccountPicture: Container(
          width: 100,
          height: 100,
          decoration: const ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
              image: DecorationImage(
                  image: AssetImage('images/Untitled-1.png'),
                  fit: BoxFit.fill)),
        ),
        accountName: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        accountEmail: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("Wellcome", style: TextStyle(color: Colors.white)),
        ));
  }

  ListTile clinicList() {
    return ListTile(
      leading: const Icon(Icons.home),
      title: const Text("หน้าหลัก"),
      onTap: () {
        setState(() {
          currentWidget = LandingPage();
        });

        Navigator.pop(context);
      },
    );
  }

  ListTile userDataList() {
    return ListTile(
      leading: const Icon(Icons.person),
      title: const Text("ข้อมูลผู้ใช้"),
      onTap: () {
        setState(() {
          currentWidget = LandingPage();
        });

        Navigator.pop(context);
      },
    );
  }

  ListTile shoppingCart() {
    return ListTile(
      leading: const Icon(Icons.shopping_cart),
      title: const Text("ตระกร้าสินค้า"),
      onTap: () {
        setState(() {
          currentWidget = LandingPage();
        });

        Navigator.pop(context);
      },
    );
  }

  ListTile singOut() {
    return ListTile(
      leading: const Icon(Icons
          .exit_to_app), //icon: Icon(Icons.exit_to_app), onPressed: () => logOut(context))
      title: const Text("ออกจากระบบ"),
      onTap: () => logOut(context),
    );
  }
}

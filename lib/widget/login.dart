import 'dart:convert';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/profile.dart';
import 'package:lovly_pet_app/screen/register.dart';
import 'package:lovly_pet_app/shape_screen/bottom_shape_clipper.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: fromLogin(context),
      ),
    );
  }

  Form fromLogin(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.amber.shade700,
            child: SafeArea(
              top: true,
              bottom: true,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ClipPath(
                      clipper: BottomShapeClipper(),
                      child: Container(
                        color: Colors.white,
                      )),
                  Column(
                    children: [
                      buildPicture(),
                      buildHeadName(),
                      textUserName(),
                      inputUserName(),
                      barUnderInput(),
                      textPassword(),
                      inputPassword(),
                      barUnderInput(),
                      buildButtonNoAccount(context),
                    ],
                  ),
                  buildButtonLogin()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding barUnderInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        height: 8,
        color: const Color.fromRGBO(255, 255, 255, 0.4),
      ),
    );
  }

  Align buildButtonLogin() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState?.save();
              formKey.currentState?.reset();
              postData();
            }
          },
          child: SizedBox(
            height: 140,
            width: 300,
            child: Image.asset('images/butlog.png'),
          )),
    );
  }

  Padding buildButtonNoAccount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Register();
              }));
            },
            child: const Text(
              "ยังไม่มีบัญชีผู้ใช้ ?",
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
      ),
    );
  }

  Padding inputPassword() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextFormField(
        validator: RequiredValidator(errorText: "กรุณากรอก รหัสผ่าน"),
        obscureText: true,
        style: const TextStyle(fontSize: 20, color: Colors.white),
        decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none)),
        onSaved: (passWord) {
          profile.passWord = passWord;
        },
      ),
    );
  }

  Padding textPassword() {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text(
              "รหัสผ่าน",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          )),
    );
  }

  Padding inputUserName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextFormField(
        validator: RequiredValidator(errorText: "กรุณากรอก ชื่อผู้ใช้"),
        onSaved: (userName) {
          profile.userName = userName;
        },
        style: const TextStyle(fontSize: 20, color: Colors.white),
        decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }

  Align textUserName() {
    return const Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text(
            "ชื่อผู้ใช้งาน",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ));
  }

  Text buildHeadName() {
    return const Text("เข้าสู่ระบบ",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white));
  }

  Padding buildPicture() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        height: 120,
        width: 120,
        child: Image.asset('images/Untitled-1.png'),
      ),
    );
  }

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
            'userName': profile.userName,
            'passWord': profile.passWord,
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

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}

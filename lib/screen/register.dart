import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/profile.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/response_register.dart';
import 'package:lovly_pet_app/screen/uplode_profile.dart';
import 'package:lovly_pet_app/shape_screen/bottom_shape_clipper_register.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: fromRegister(context),
      ),
    );
  }

  Form fromRegister(BuildContext context) {
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
                      clipper: BottomShapeClipperRegister(),
                      child: Container(
                        color: Colors.white,
                      )),
                  Column(
                    children: [
                      headNamePage(),
                      textUsername(),
                      inputUsername(),
                      textPassword(),
                      inputPassword(),
                      textName(),
                      inputName(),
                      textEmail(),
                      inputEmail(),
                      textTell(),
                      inputTell(),
                    ],
                  ),
                  buildButtonRegister()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Align buildButtonRegister() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              formKey.currentState?.reset();
              postData();
            }
          },
          child: SizedBox(
            height: 100,
            width: 250,
            child: Image.asset('images/regisbut.png'),
          )),
    );
  }

  Padding inputTell() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(35)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: TextFormField(
            validator: RequiredValidator(errorText: "กรุณากรอก เบอร์โทร"),
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 20, color: Colors.black),
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none)),
            onSaved: (phoneNumber) {
              profile.phoneNumber = phoneNumber?.trim();
            },
          ),
        ),
      ),
    );
  }

  Padding textTell() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(25, 5, 20, 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "เบอร์โทร",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Padding inputEmail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(35)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: TextFormField(
            validator: MultiValidator([
              RequiredValidator(errorText: "กรุณากรอก อีเมลล์"),
              EmailValidator(errorText: "รูปแบบอีเมลล์ไม่ถูกต้อง"),
            ]),
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 20, color: Colors.black),
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none)),
            onSaved: (email) {
              profile.email = email?.trim();
            },
          ),
        ),
      ),
    );
  }

  Padding textEmail() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(25, 5, 20, 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "อีเมลล์",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Padding inputName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(35)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: TextFormField(
            validator: RequiredValidator(errorText: "กรุณากรอก ชื่อ-สกุล"),
            style: const TextStyle(fontSize: 20, color: Colors.black),
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none)),
            onSaved: (name) {
              profile.name = name?.trim();
            },
          ),
        ),
      ),
    );
  }

  Padding textName() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(25, 5, 20, 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "ชื่อ-สกุล",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Padding inputPassword() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(35)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: TextFormField(
            validator: RequiredValidator(errorText: "กรุณากรอก รหัสผ่าน"),
            obscureText: true,
            style: const TextStyle(fontSize: 20, color: Colors.black),
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none)),
            onSaved: (passWord) {
              profile.passWord = passWord?.trim();
            },
          ),
        ),
      ),
    );
  }

  Padding textPassword() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(25, 5, 20, 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "รหัสผ่าน",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Padding inputUsername() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(35)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            validator: RequiredValidator(errorText: "กรุณากรอก ชื่อผู้ใช้"),
            style: const TextStyle(fontSize: 20, color: Colors.black),
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none)),
            onSaved: (userName) {
              profile.userName = userName?.trim();
            },
          ),
        ),
      ),
    );
  }

  Padding textUsername() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(25, 10, 20, 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "ชื่อผู้ใช้",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Text headNamePage() {
    return const Text(
      "สมัครสมาชิก",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
    );
  }

  String ipc = "192.168.1.114";

  Future<void> postData() async {
    final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.userRegister}");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'userName': profile.userName,
            'passWord': profile.passWord,
            'name': profile.name,
            'email': profile.email,
            'phoneNumber': profile.phoneNumber
          },
        ),
      ); // ข้อมูลที่จะส่ง

      if (response.statusCode == 200) {
        ResponseRegister res =
            ResponseRegister.fromJson(jsonDecode(response.body));
        // ignore: use_build_context_synchronously
        routSer(res.id!);
      } else {
        ExceptionLogin exceptionModel =
            ExceptionLogin.fromJson(jsonDecode(response.body));
        // ignore: use_build_context_synchronously
        errorDialog(context, '${exceptionModel.error}');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      errorDialog(context, '$e');
      print('$e');
    }
  }

  Future<void> routSer(int id) async {
    MaterialPageRoute rout = MaterialPageRoute(
      builder: (context) => UplodeProfile(id: id),
    );
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(context, rout, (route) => false);
  }
}

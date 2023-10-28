import 'package:flutter/material.dart';

class ApproveWidget extends StatefulWidget {
  const ApproveWidget({super.key});

  @override
  State<ApproveWidget> createState() => _ApproveWidgetState();
}

class _ApproveWidgetState extends State<ApproveWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          buildBoxTextHead(),
          buildImageHead(),
        ],
      ),
    );
  }

  Image buildImageHead() {
    return Image.asset(
      'images/approve.png',
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
              'อนุมัติ',
              style: TextStyle(fontSize: 20),
            ),
          )),
    );
  }
}

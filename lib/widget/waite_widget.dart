import 'package:flutter/material.dart';

class WaiteWidget extends StatefulWidget {
  const WaiteWidget({super.key});

  @override
  State<WaiteWidget> createState() => _WaiteWidgetState();
}

class _WaiteWidgetState extends State<WaiteWidget> {
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
      'images/wait.png',
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
              'รออนุมัติ',
              style: TextStyle(fontSize: 20),
            ),
          )),
    );
  }
}

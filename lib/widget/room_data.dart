import 'package:flutter/material.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/list_room.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/widget/list_room.dart';
import 'package:lovly_pet_app/widget/room_booking.dart';

class RoomData extends StatefulWidget {
  //const ListRoom({super.key});
  final ListRoomModelDart? id; // ตัวแปรสำหรับรับข้อมูล

  const RoomData({super.key, required this.id});

  @override
  State<RoomData> createState() => _RoomDataState();
}

class _RoomDataState extends State<RoomData> {
  void navigate(int? id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RoomBooking();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: buildListview(context),
      bottomNavigationBar: buildBottomAppBar(),
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.amber.shade700), // สีพื้นหลัง
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
                    ),
                  ),
                  elevation: MaterialStateProperty.all<double>(20),
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(120, 40)), // ขนาดขั้นต่ำของปุ่ม
                ),
                onPressed: () {
                  navigate(widget.id!.id);
                },
                child: const Text(
                  'จองห้อง',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ));
  }

  ListView buildListview(BuildContext context) {
    return ListView(
      children: [
        buildBoxImageDummy(context),
        buildComponentRoomData(),
      ],
    );
  }

  Padding buildComponentRoomData() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        elevation: 20, // ความลึกของเงา
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // ปรับรูปร่างของ Card
        ),
        child: Column(
          children: [
            buildTextRoomNumber(),
            buildTextRoomType(),
            buildTextRoomDetails(),
            buildTextRoomPrice()
          ],
        ),
      ),
    );
  }

  Align buildTextRoomPrice() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          'ราคา: ${widget.id!.roomPrice} บาท',
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Column buildTextRoomDetails() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'คำอธิบายเพิ่มเติม:',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '${widget.id!.roomDetails}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        )
      ],
    );
  }

  Align buildTextRoomType() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          'ประเภทห้อง: ${widget.id!.type}',
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Align buildTextRoomNumber() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          'ห้องเลขที่: ${widget.id!.roomNumber.toString()}',
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Padding buildBoxImageDummy(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        height: 200,
        child: PageView(
          scrollDirection: Axis.horizontal, // เลื่อนรูปภาพซ้าย-ขวา
          children: <Widget>[
            InkWell(
              onTap: () {
                errorDialog(context, 'red');
              },
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                color: Colors.red,
              ),
            ),
            InkWell(
              onTap: () {
                errorDialog(context, 'blue');
              },
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                color: Colors.blue,
              ),
            ),
            InkWell(
              onTap: () {
                errorDialog(context, 'green');
              },
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

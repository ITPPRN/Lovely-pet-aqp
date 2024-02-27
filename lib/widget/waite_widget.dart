import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/booking_list_j_to_d.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';

import 'list_room.dart';

class WaiteWidget extends StatefulWidget {
  final List<BookingListJToD> waitBookings;
  final List<BookingListJToD> disapprovalBookings;
  final String? token;
  const WaiteWidget(
      {super.key,
      required this.waitBookings,
      required this.disapprovalBookings,
      required this.token});

  @override
  State<WaiteWidget> createState() => _WaiteWidgetState();
}

class _WaiteWidgetState extends State<WaiteWidget> {
  Future<void> postCancel(int id) async {
    final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.cancel}");
    try {
      //print("sent data");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode(
          {"idBooking": id},
        ),
      ); // ข้อมูลที่จะส่ง

      if (response.statusCode == 200) {
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

  void navigateReBook(BookingListJToD? booking) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ListRoom(id: booking!.hotelId,token: widget.token,);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          buildBoxTextHead(),
          buildImageHead(),
          buildText('Waite'),
          buildListView(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: buildText('disapproval'),
          ),
          buildListViewDisapproval(),
        ],
      ),
    );
  }

  Card buildText(String text) {
    return Card(
      child: ListTile(title: Text(text)),
    );
  }

  Column buildListView() {
    return Column(
      children: widget.waitBookings.map((booking) {
        return buildBookingItem(booking);
      }).toList(),
    );
  }

  Widget buildBookingItem(BookingListJToD booking) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text('Clinic name: ${booking.nameHotel}'),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('room number: ${booking.roomNumber}'),
              Text(
                  'start: ${booking.bookingStartDate} - end: ${booking.bookingEndDate}'),
              Text('pet: ${booking.pet!.petName}'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red), // สีพื้นหลัง
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(20),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(100, 40)), // ขนาดขั้นต่ำของปุ่ม
                      ),
                      onPressed: () {
                        showCancelDialog(booking.id);
                      },
                      child: const Text(
                        'ยกเลิก',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showCancelDialog(int? id) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการยกเลิก?'),
          content: const Text('คุณต้องการยกเลิกการจองนี้หรือไม่?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                postCancel(id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Column buildListViewDisapproval() {
    return Column(
      children: widget.disapprovalBookings.map((booking) {
        return buildBookingItemDisapproval(booking);
      }).toList(),
    );
  }

  Widget buildBookingItemDisapproval(BookingListJToD booking) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text('Clinic name: ${booking.nameHotel}'),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('room number: ${booking.roomNumber}'),
              Text(
                  'start: ${booking.bookingStartDate} - end: ${booking.bookingEndDate}'),
              Text('pet: ${booking.pet!.petName}'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red), // สีพื้นหลัง
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(20),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(100, 40)), // ขนาดขั้นต่ำของปุ่ม
                      ),
                      onPressed: () {
                        showCancelDialog(booking.id);
                      },
                      child: const Text(
                        'ยกเลิก',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.amber.shade700), // สีพื้นหลัง
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(20),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(100, 40)), // ขนาดขั้นต่ำของปุ่ม
                      ),
                      onPressed: () {
                        navigateReBook(booking);
                      },
                      child: const Text(
                        'ทำการจองใหม่',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

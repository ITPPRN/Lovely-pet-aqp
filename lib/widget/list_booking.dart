import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/json-to-dart-model/booking_list_j_to_d.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/exception_login.dart';
import '../unity/alert_dialog.dart';
import '../unity/api_router.dart';

class ListBooking extends StatefulWidget {
  const ListBooking({Key? key});

  @override
  State<ListBooking> createState() => _ListBookingState();
}

class _ListBookingState extends State<ListBooking> {
  String? token;
  List<BookingListJToD> bookings = [];
  List<BookingListJToD> cancelBookings = [];
  List<BookingListJToD> successBookings = [];
  List<BookingListJToD> waitBookings = [];
  List<BookingListJToD> approveBooking = [];
  List<BookingListJToD> disapprovalBookings = [];

  Future<void> findU() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    setState(() {});
    getData();
  }

  Future<void> getData() async {
    if (token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.getBookingList}");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> jsonList = jsonDecode(response.body);
          bookings =
              jsonList.map((json) => BookingListJToD.fromJson(json)).toList();

          // แยกข้อมูลออกตามสถานะ
          cancelBookings =
              bookings.where((booking) => booking.state == 'cancel').toList();
          successBookings =
              bookings.where((booking) => booking.state == 'complete').toList();
          waitBookings =
              bookings.where((booking) => booking.state == 'waite').toList();
          approveBooking =
              bookings.where((booking) => booking.state == 'approve').toList();
          disapprovalBookings = bookings
              .where((booking) => booking.state == 'disapproval')
              .toList();
          setState(() {});
          //return bookings; // Return the list of clinics
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));

          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} stats = ${response.statusCode}');

          //return [];
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(context, '$e');
        //return []; // Return an empty list in case of an exception
      }
    } else {
      //return [];
    }
  }

  @override
  void initState() {
    super.initState();
    findU();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: <Widget>[
            const TabBar(
              tabs: <Widget>[
                Tab(text: 'รออนุมัติ'),
                Tab(text: 'อนุมัติ'),
                Tab(text: 'ไม่อนุมัติ'),
                Tab(text: 'สำเร็จ'),
                Tab(text: 'ยกเลิก'),
              ],
            ),
            SizedBox(
              height: 400, // ปรับความสูงตามต้องการ
              child: TabBarView(
                children: <Widget>[
                  buildListView(waitBookings),
                  buildListView(approveBooking),
                  buildListView(disapprovalBookings),
                  buildListView(successBookings),
                  buildListView(cancelBookings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildListView(List<BookingListJToD> bookingList) {
    return ListView.builder(
      itemCount: bookingList.length,
      itemBuilder: (context, index) {
        final booking = bookingList[index];

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: buildComponentBookingList(booking, context),
        );
      },
    );
  }

  GestureDetector buildComponentBookingList(
      BookingListJToD clinic, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigate(clinic);
      },
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
        child: Card(
          child: ListTile(
            title: Text('Clinic name: ${clinic.nameHotel}'),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('room number: ${clinic.roomNumber}'),
                Text(
                    'start: ${clinic.bookingStartDate} - end: ${clinic.bookingEndDate}'),
                Text('pet: ${clinic.pet!.petName}'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: clinic.state == "waite",
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.red), // สีพื้นหลัง
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                            //showCancelDialog(booking.id);
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
                    ),
                    Visibility(
                      visible: clinic.state == "approve",
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.amber.shade700), // สีพื้นหลัง
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                            //showCancelDialog(booking.id);
                          },
                          child: const Text(
                            'นำทาง',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: clinic.state == "disapproval",
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 10),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red), // สีพื้นหลัง
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
                                    ),
                                  ),
                                  elevation:
                                      MaterialStateProperty.all<double>(20),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      const Size(
                                          100, 40)), // ขนาดขั้นต่ำของปุ่ม
                                ),
                                onPressed: () {
                                  //showCancelDialog(booking.id);
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
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber.shade700), // สีพื้นหลัง
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
                                    ),
                                  ),
                                  elevation:
                                      MaterialStateProperty.all<double>(20),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      const Size(
                                          100, 40)), // ขนาดขั้นต่ำของปุ่ม
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'อัปเดตการจอง',
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
                      ),
                    ),
                    Visibility(
                      visible: clinic.state == "complete",
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: !clinic
                                .feedback!, // ระบุว่าจะแสดงหรือซ่อน TextButton
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  //navigateReview(booking);
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/score.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    const Text(
                                      'ให้คะแนน',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.amber.shade700), // สีพื้นหลัง
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        50), // ปรับขนาดโดยกำหนดรัศมีที่ต้องการ
                                  ),
                                ),
                                elevation:
                                    MaterialStateProperty.all<double>(20),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(100, 40)), // ขนาดขั้นต่ำของปุ่ม
                              ),
                              onPressed: () {},
                              child: const Text(
                                'จองอีกครั้ง',
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
                    ),
                    Visibility(
                      visible: clinic.state == "cancel",
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.amber.shade700), // สีพื้นหลัง
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                            //showCancelDialog(booking.id);
                          },
                          child: const Text(
                            'จองอีกครั้ง',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
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
      ),
    );
  }
}

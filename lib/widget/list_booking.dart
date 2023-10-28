import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/json-to-dart-model/booking_list_j_to_d.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/exception_login.dart';
import '../unity/alert_dialog.dart';
import '../unity/api_router.dart';

class ListBooking extends StatefulWidget {
  const ListBooking({super.key});

  @override
  State<ListBooking> createState() => _ListBookingState();
}

class _ListBookingState extends State<ListBooking> {
  String? token;
  List<BookingListJToD> bookings = [];

  Future<void> findU() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    setState(() {});
    // await getData();
  }

  Future<List<BookingListJToD>> getData() async {
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
          return bookings; // Return the list of clinics
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));

          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} stats = ${response.statusCode}');

          return [];
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(context, '$e');
        return []; // Return an empty list in case of an exception
      }
    } else {
      return [];
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
      body: buildBookingList(),
    );
  }

  FutureBuilder<List<BookingListJToD>> buildBookingList() {
    return FutureBuilder<List<BookingListJToD>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // ในขณะที่รอข้อมูล
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // หากเกิดข้อผิดพลาด
          return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // หากไม่มีข้อมูลหรือข้อมูลว่างเปล่า
          return const Text('ไม่มีรายชื่อคลีนิก');
        } else {
          // หากมีข้อมูลและไม่มีข้อผิดพลาด
          return buildListView(snapshot);
        }
      },
    );
  }

  ListView buildListView(AsyncSnapshot<List<BookingListJToD>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final clinic = snapshot.data![index];

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: buildComponentBookingList(clinic, context),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ชื่อคลีนิค: ${clinic.hotelId} '),
            Text('ห้องพักหมายเลข: ${clinic.roomNumber}'),
            Text('ชื่อสัตว์เลี้ยง: ${clinic.pet!.petName}'),
            Align(
              alignment: Alignment.centerRight,
              child: Text('สถานะ: ${clinic.state}'),
            )
          ],
        ),
      ),
    );
  }
}

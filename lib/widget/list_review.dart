import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/booking_list_j_to_d.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/review_json_to_dart.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:lovly_pet_app/widget/review.dart';

import 'list_room.dart';

class ListReview extends StatefulWidget {
  final String? token;
  final int? id;

  const ListReview({super.key, required this.id, required this.token});

  @override
  State<ListReview> createState() => _ListReviewState();
}

class _ListReviewState extends State<ListReview> {
  List<ReviewJsonToDart> bookings = [];

  void navigateReview(BookingListJToD? booking) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Rating(
        booking: booking!,
        token: widget.token,
      );
    }));
  }

  Future<List<ReviewJsonToDart>> getData() async {
    if (widget.token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.listReview}");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: json.encode(
            {
              'id': widget.id,
            },
          ),
        );

        if (response.statusCode == 200) {
          final List<dynamic> jsonList = jsonDecode(response.body);
          bookings =
              jsonList.map((json) => ReviewJsonToDart.fromJson(json)).toList();
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
    getData();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildBoxTextHead(),
            buildImageHead(),
            buildBookingList(),
          ],
        ),
      ),
    );
  }

  Image buildImageHead() {
    return Image.asset(
      'images/score.png',
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
            'คะเนนและรีวิว',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  void navigateReBook(BookingListJToD? booking) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ListRoom(id: booking!.hotelId);
    }));
  }

  FutureBuilder<List<ReviewJsonToDart>> buildBookingList() {
    return FutureBuilder<List<ReviewJsonToDart>>(
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

  ListView buildListView(AsyncSnapshot<List<ReviewJsonToDart>> snapshot) {
    return ListView.builder(
      shrinkWrap: true, // จัดหน้าประวัติให้ไม่มีข้อผิดพลาด
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
      ReviewJsonToDart clinic, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigate(clinic);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListTile(
            title: Text('Clinic name: ${clinic.hotelId}'),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${clinic.comment}'),
                Text('user name: ${clinic.userId}'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children:
                        List.generate(clinic.rating!.floor(), (index) {
                          return const Icon(Icons.star,
                              color: Colors.yellow,
                              size: 30); // แสดงดาวสีเหลืองขนาด 30 พิกเซล
                        }),
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

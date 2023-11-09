import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/booking_list_j_to_d.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';

class Rating extends StatefulWidget {
  final BookingListJToD? booking;
  final String? token;
  const Rating({super.key, required this.booking, required this.token});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  double rating = 0.0;
  TextEditingController feedback = TextEditingController();

  void popCon() {
    Navigator.of(context).pop();
  }

  Future<void> postReview() async {
    final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.review}");
    try {
      //print("sent data");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode(
          {
            "idHotel": widget.booking!.hotelId,
            "rating": rating,
            "comment": feedback.text,
            "bookingId": widget.booking!.id
          },
        ),
      ); // ข้อมูลที่จะส่ง

      if (response.statusCode == 200) {
        popCon();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildComponent(),
      bottomNavigationBar: buildBottomAppBar(),
    );
  }

  ListView buildComponent() {
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPicture(),
                buildServiceBox(),
                buildBoxRating(),
                buildFeedback()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding buildFeedback() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 100,
        //width: MediaQuery.of(context).size.width,
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
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                'ข้อเสนอแนะเพิ่มเติม',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 10),
                child: TextField(
                  controller: feedback,
                  decoration: const InputDecoration(),
                ),
              ),
              buildLineUnderInput(),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildLineUnderInput() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Container(
        height: 1,
        color: Colors.black,
      ),
    );
  }

  Padding buildServiceBox() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        //width: MediaQuery.of(context).size.width,
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
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'รายละเอียด',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(widget.booking!.nameHotel.toString()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                  '${widget.booking!.bookingStartDate.toString()} - ${widget.booking!.bookingEndDate.toString()}'),
            ),
          ],
        ),
      ),
    );
  }

  Container buildBoxRating() {
    return Container(
      height: 100,
      //width: MediaQuery.of(context).size.width,
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
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'ระดับความพึงพอใจ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: buildRatingBar(),
            ),
          ],
        ),
      ),
    );
  }

  RatingBar buildRatingBar() {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 40,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (newRating) {
        setState(() {
          rating = newRating;
        });
      },
    );
  }

  Padding buildPicture() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        height: 170,
        width: 170,
        child: Image.asset('images/score.png'),
      ),
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.grey), // สีพื้นหลัง
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
                  cancelDialog(context, 'ยกเลิกการให้คะแนน');
                },
                child: const Text(
                  'ยกเลิก',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                  if (widget.booking != null) {
                    postReview();
                  }
                },
                child: const Text(
                  'ส่ง',
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
}

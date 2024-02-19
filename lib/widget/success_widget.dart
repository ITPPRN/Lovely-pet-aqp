import 'package:flutter/material.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/booking_list_j_to_d.dart';
import 'package:lovly_pet_app/widget/list_room.dart';
import 'package:lovly_pet_app/widget/review.dart';

class SuccessWidget extends StatefulWidget {
  final List<BookingListJToD> succeedBooking;
  final String? token;

  const SuccessWidget(
      {super.key, required this.succeedBooking, required this.token});

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  void navigateReview(BookingListJToD? booking) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Rating(
        booking: booking!,
        token: widget.token,
      );
    }));
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
          buildListView(),
        ],
      ),
    );
  }

  Column buildListView() {
    return Column(
      children: widget.succeedBooking.map((booking) {
        return buildBookingItem(booking);
      }).toList(),
    );
  }

  Widget buildBookingItem(BookingListJToD? booking) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text('Clinic name: ${booking!.nameHotel}'),
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
                  Visibility(
                    visible:
                        !booking.feedback!, // ระบุว่าจะแสดงหรือซ่อน TextButton
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          navigateReview(booking);
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
            ],
          ),
        ),
      ),
    );
  }

  Image buildImageHead() {
    return Image.asset(
      'images/record.png',
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
              'สำเร็จ',
              style: TextStyle(fontSize: 20),
            ),
          )),
    );
  }
}

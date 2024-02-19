import 'package:flutter/material.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/booking_list_j_to_d.dart';

import 'list_room.dart';

class CancleWidget extends StatefulWidget {
  final List<BookingListJToD> cancelBookings;
  final String? token;

  const CancleWidget({super.key, required this.cancelBookings, required this.token});

  @override
  State<CancleWidget> createState() => _CancleWidgetState();
}

class _CancleWidgetState extends State<CancleWidget> {
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

  void navigateReBook(BookingListJToD? booking) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ListRoom(id: booking!.hotelId,token:widget.token,);
    }));
  }

  Column buildListView() {
    return Column(
      children: widget.cancelBookings.map((booking) {
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
      'images/cancle.png',
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
              'ยกเลิก',
              style: TextStyle(fontSize: 20),
            ),
          )),
    );
  }
}

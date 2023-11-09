import 'package:flutter/material.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/booking_list_j_to_d.dart';
import 'package:url_launcher/url_launcher.dart';

class ApproveWidget extends StatefulWidget {
  final List<BookingListJToD> approveBooking;
  const ApproveWidget({super.key, required this.approveBooking});

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
          buildListView(),
        ],
      ),
    );
  }

  Column buildListView() {
    return Column(
      children: widget.approveBooking.map((booking) {
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
                        _launchUrl(booking.latitude, booking.longitude);
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Uri buildGoogleMapsUrl(double? latitude, double? longitude) {
    return Uri.parse(
        'https://www.google.com/maps?q=${latitude.toString()},${longitude.toString()}');
  }

  Future<void> _launchUrl(double? latitude, double? longitude) async {
    if (!await launchUrl(buildGoogleMapsUrl(latitude, longitude))) {
      throw Exception('Could not launch buildGoogleMapsUrl()');
    }
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

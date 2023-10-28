import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';

class Rating extends StatefulWidget {
  const Rating({super.key});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  double rating = 0.0;
  String feedback = "";

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
      ),
    );
  }

  Padding buildServiceBox() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text('ระดับความพึงพอใจ'),
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
                  cancelDialog(context, 'ยกเลิกการเพิ่มข้อมูลสัตว์เลี้ยง');
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
                  // if (formKey.currentState!.validate()) {
                  //   formKey.currentState?.save();
                  //   formKey.currentState?.reset();
                  //   addData();
                  // }
                },
                child: const Text(
                  'บันทึก',
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

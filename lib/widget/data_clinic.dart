import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/list_clinic.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:lovly_pet_app/unity/get_name_image.dart';
import 'package:lovly_pet_app/unity/show_image.dart';
import 'package:lovly_pet_app/widget/list_review.dart';
import 'package:lovly_pet_app/widget/list_room.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/exception_login.dart';
import '../model/json-to-dart-model/review_json_to_dart.dart';

class DataClinic extends StatefulWidget {
  //const ListRoom({super.key});
  final ListClinicModel? id; // ตัวแปรสำหรับรับข้อมูล
  final String? token;

  const DataClinic({super.key, required this.id, required this.token});

  @override
  State<DataClinic> createState() => _DataClinicState();
}

class _DataClinicState extends State<DataClinic> {
  int idRoom = 0;
  final imageService = ImageService();

  void navigate(int? id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ListRoom(id: id,token: widget.token,);
    }));
  }

  void navigateListReview(int? id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ListReview(
        token: widget.token,
        id: id,
        hotelName: widget.id!.hotelName,
      );
    }));
  }

  void navigateShowImage(List<String>? images) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ShowImage(token: widget.token, images: images);
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: buildBody(context),
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
                  'ดูห้องพัก',
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

  ListView buildBody(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: SizedBox(
            height: 200,
            child: buildImages(widget.id),
          ),
        ),
        buildCardNameClinic(),
        buildCardAdditionalNotes(),
        buildCardLocation(),
      ],
    );
  }

  Card buildCardLocation() {
    return Card(
      elevation: 20, // ความลึกของเงา
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // ปรับรูปร่างของ Card
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'ที่อยู่',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(widget.id!.location.toString()),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
                width: 100,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    _launchUrl(widget.id!.latitude, widget.id!.longitude);
                  },
                  child: Image.asset('images/Google-maps.png'),
                )),
          )
        ],
      ),
    );
  }

  Uri buildGoogleMapsUrl(double? latitude, double? longitude) {
    return Uri.parse('https://www.google.com/maps/search/$latitude,$longitude');
  }

  Future<void> _launchUrl(double? latitude, double? longitude) async {
    if (!await launchUrl(buildGoogleMapsUrl(latitude, longitude))) {
      throw Exception('Could not launch buildGoogleMapsUrl()');
    }
  }

  Card buildCardAdditionalNotes() {
    return Card(
      elevation: 20, // ความลึกของเงา
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // ปรับรูปร่างของ Card
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: FractionalOffset.centerLeft,
              child: Text(
                'เกี่ยวกับ',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  widget.id!.additionalNotes
                      .toString()),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildCardNameClinic() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        elevation: 20, // ความลึกของเงา
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // ปรับรูปร่างของ Card
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.id!.hotelName.toString(),
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children:
                    List.generate(widget.id!.rating!.floor(), (index) {
                      return const Icon(Icons.star,
                          color: Colors.yellow,
                          size: 30); // แสดงดาวสีเหลืองขนาด 30 พิกเซล
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Icon(Icons.location_on),
                        ),
                        Text('ที่อยู่: ${widget.id!.location.toString()}'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            buildReviewButton()
          ],
        ),
      ),
    );
  }
  List<ReviewJsonToDart> listReview = [];
  Future<int> getDataReview(int? id) async {
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
              'id': id,
            },
          ),
        );

        if (response.statusCode == 200) {
          final List<dynamic> jsonList = jsonDecode(response.body);
          listReview =
              jsonList.map((json) => ReviewJsonToDart.fromJson(json)).toList();
          return listReview.length; // Return the number of reviews
        } else {
          ExceptionLogin exceptionModel =
          ExceptionLogin.fromJson(jsonDecode(response.body));

          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} stats = ${response.statusCode}');

          return 0; // Return 0 if there was an error
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(context, '$e');
        return 0; // Return 0 in case of an exception
      }
    } else {
      return 0; // Return 0 if token is null
    }
  }
  Align buildReviewButton() {
    List<String> stringList = [
      "ไม่มีคะแนน",
      "แย่",
      "พอใช้",
      "ดี",
      "ดีมาก",
      "ดีเยี่ยม"
    ];

    // ดึงข้อมูลจำนวนรีวิวผ่าน Future
    Future<int> countFuture = getDataReview(widget.id!.id);

    // กำหนดข้อความที่จะแสดงบนปุ่ม
    String text = stringList[widget.id!.rating!.floor()];
    String level = '${widget.id!.rating!.toStringAsFixed(1)}/5.0 $text'; // แสดงทศนิยมหนึ่งตำแหน่ง

    return Align(
      alignment: Alignment.bottomLeft, // จัดแสดงในมุมล่างซ้าย
      child: FutureBuilder<int>(
        future: countFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // แสดงอินดิเคเตอร์กำลังโหลดข้อมูล
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // แสดงข้อผิดพลาดหากเกิดข้อผิดพลาดในการดึงข้อมูล
          } else {
            // แสดงปุ่มเมื่อข้อมูลพร้อมใช้งาน
            int count = snapshot.data ?? 0; // ใช้ข้อมูลจำนวนรีวิวที่ได้รับจาก Future
            return TextButton(
              onPressed: () {
                navigateListReview(widget.id!.id); // นำทางไปยังรายการรีวิวเมื่อปุ่มถูกกด
              },
              child: Text(
                "$level จำนวนรีวิว $count รีวิว >", // แสดงระดับการให้คะแนนและจำนวนรีวิว
                style: const TextStyle(color: Colors.black), // กำหนดสีของข้อความเป็นสีดำ
              ),
            );
          }
        },
      ),
    );
  }



  ////////////////////////////////////////////////////////////////////////////

  Future<List<String>> getNameListImages(int? id) async {
    try {
      List<String> nameImages1 = await imageService.getImageName(
          widget.token, SubPath.getListHotelImage, id);
      return nameImages1;
    } catch (e) {
      // ignore: use_build_context_synchronously
      errorDialog(context, 'getNameListImages = $e');
      return [];
    }
  }

  FutureBuilder<List<String>> buildImages(ListClinicModel? clinic) {
    return FutureBuilder<List<String>>(
      future: getNameListImages(clinic!.id),
      builder: (context, snapshot) {
        //final images = snapshot.data![index];
        if (snapshot.connectionState == ConnectionState.waiting) {
          // ในขณะที่รอข้อมูล
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // หากเกิดข้อผิดพลาด
          return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // หากไม่มีข้อมูลหรือข้อมูลว่างเปล่า
          return fakeImage(context);
        } else {
          List<String> images = snapshot.data!;
          // หากมีข้อมูลและไม่มีข้อผิดพลาด
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // กำหนดแนวนอน
            child: Row(
              children: images.map((imageUrl) {
                return GestureDetector(
                  onTap: () {
                    navigateShowImage(images);
                  },
                  child: FutureBuilder<dynamic>(
                    future: imageService.getImage(
                        widget.token, SubPath.getHotelImage, imageUrl),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white, // สีพื้นหลังของ Container
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey, // สีของเงา
                                offset:
                                Offset(0, 3), // ตำแหน่งเงาในแนวแกน x และ y
                                blurRadius: 4, // ความคมชัดของเงา
                                spreadRadius: 2, // การกระจายของเงา
                              ),
                            ],
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 300,
                          child: Image.memory(
                            snapshot.data!,
                          ),
                        );
                      } else {
                        return Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 300,
                          color: Colors.amber,
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }

  Container fakeImage(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery
          .of(context)
          .size
          .width, // ทำให้ container ขยายตามความกว้างของหน้าจอ
      padding: const EdgeInsets.all(16.0), // กำหนด padding ตามความต้องการ
      decoration: const BoxDecoration(
        color: Colors.amber, // สีพื้นหลังของ Container
        boxShadow: [
          BoxShadow(
            color: Colors.grey, // สีของเงา
            offset: Offset(0, 3), // ตำแหน่งเงาในแนวแกน x และ y
            blurRadius: 4, // ความคมชัดของเงา
            spreadRadius: 2, // การกระจายของเงา
          ),
        ],
      ),
    );
  }
}

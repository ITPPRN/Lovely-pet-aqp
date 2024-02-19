import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/list_room.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:lovly_pet_app/unity/get_name_image.dart';
import 'package:lovly_pet_app/widget/room_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListRoom extends StatefulWidget {
  final int? id;
  final String? token;

  const ListRoom({super.key, required this.id, required this.token});

  @override
  State<ListRoom> createState() => _ListRoomState();
}

class _ListRoomState extends State<ListRoom> {
  List<ListRoomModelDart> rooms = [];

  final imageService = ImageService();


  Future<List<ListRoomModelDart>> getData() async {
    if (widget.token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}/room/list-all-room");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: json.encode(
            {"hotelId": widget.id},
          ),
        );

        if (response.statusCode == 200) {
          //print(response.body);
          final List<dynamic> jsonList = jsonDecode(response.body);
          rooms =
              jsonList.map((json) => ListRoomModelDart.fromJson(json)).toList();
          return rooms; // Return the list of clinics
        } else {
          //print(response.body);
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));
          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} stats = ${response.statusCode}');
          return []; // Return an empty list in case of an error
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(context, '$e');
        //print('$e');
        return []; // Return an empty list in case of an exception
      }
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();

  }

  void navigate(ListRoomModelDart? id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RoomData(
        id: id,
        token: widget.token,
        idHotel: widget.id,
      );
    }));
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
      body: buildBody(),
    );
  }

  Stack buildBody() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: FutureBuilder<List<ListRoomModelDart>>(
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
          ),
        ),
        //buildIconFilter(),
      ],
    );
  }
 
  ListView buildListView(AsyncSnapshot<List<ListRoomModelDart>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final clinic = snapshot.data![index];
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: buildComponentRoom(clinic, context),
        );
      },
    );
  }

  GestureDetector buildComponentRoom(
      ListRoomModelDart clinic, BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(clinic);
      },
      child: buildBaseGestureDetector(clinic),
    );
  }

  Container buildBaseGestureDetector(ListRoomModelDart clinic) {
    return Container(
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
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildImages(clinic),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                buildTextRoomNumber(clinic),
              ],
            ),
          ),
          buildTextRoomTypeAndPrice(clinic),
        ],
      ),
    );
  }

  Padding buildTextRoomTypeAndPrice(ListRoomModelDart clinic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'ประเภทห้อง: ${clinic.type}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              'ราคา: ${clinic.roomPrice} บาท',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildTextRoomNumber(ListRoomModelDart clinic) {
    return Padding(
      padding: const EdgeInsets.only(left: 9),
      child: Text(
        'ห้องเลขที่: ${clinic.roomNumber}',
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////

  Future<List<String>> getNameListImages(int? id) async {
    try {
      List<String> nameImages1 = await imageService.getImageNameRoom(
          widget.token, SubPath.getListRoomImage, id);
      //print('pull images successfuly');
      //print(nameImages1);
      return nameImages1;
    } catch (e) {
      // ignore: use_build_context_synchronously
      errorDialog(context, 'getNameListImages = $e');
      return [];
    }
  }

  FutureBuilder<List<String>> buildImages(ListRoomModelDart clinic) {
    return FutureBuilder<List<String>>(
      future: getNameListImages(clinic.id),
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
          return fakeImage(context, clinic);
        } else {
          List<String> images = snapshot.data!;
          // หากมีข้อมูลและไม่มีข้อผิดพลาด
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // กำหนดแนวนอน
            child: Row(
              children: images.map((imageUrl) {
                return GestureDetector(
                  onTap: () {
                    navigate(clinic);
                  },
                  child: FutureBuilder<dynamic>(
                    future: imageService.getImageRoom(
                        widget.token, SubPath.getRoomImage, imageUrl),
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
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: Image.memory(
                            snapshot.data!,
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            navigate(clinic);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            color: Colors.amber,
                          ),
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

  GestureDetector fakeImage(BuildContext context, ListRoomModelDart clinic) {
    return GestureDetector(
      onTap: () {
        navigate(clinic);
      },
      child: Container(
        height: 300,
        width: MediaQuery.of(context)
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
      ),
    );
  }
}

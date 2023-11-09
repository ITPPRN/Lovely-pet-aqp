import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/additional_service_j_to_d.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/list_room.dart';
import 'package:lovly_pet_app/model/json-to-dart-model/pet_profile_j_to_d.dart';
import 'package:lovly_pet_app/unity/alert_dialog.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:lovly_pet_app/widget/list_booking.dart';

import '../screen/landing_screen.dart';

class RoomBooking extends StatefulWidget {
  final String? token;
  final int? idHotel;
  final ListRoomModelDart? room;

  const RoomBooking(
      {super.key,
      required this.token,
      required this.idHotel,
      required this.room});

  @override
  State<RoomBooking> createState() => _RoomBookingState();
}

class _RoomBookingState extends State<RoomBooking> {
  final formKey = GlobalKey<FormState>();
  String? did;
  String? dim;
  String? diy;
  String? dod;
  String? dom;
  String? doy;
  String? dateIn;
  String? dateOut;
  List<PetProfileJToD> pets = [];
  PetProfileJToD? pet;
  List<AdditionalServiceDartModel> additionalServices = [];
  AdditionalServiceDartModel? additionalService;
  List<String> items = [
    'cash payment',
    'Pay with mobile banking'
  ]; // รายการ Dropdown
  String selectedListItem = '';
  File? image;
  double? price;

  Future<void> reserve() async {
    if (widget.token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.reserve}");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: json.encode(
            {
              "hotelId": widget.idHotel,
              "roomId": widget.room!.id,
              "petId": pet!.id,
              "start": dateIn,
              "end": dateOut,
              "paymentMethod": selectedListItem,
              "additionService": additionalService!.id,
              "totalPrice": price
            },
          ),
        );

        if (response.statusCode == 200) {
          print(response.body);
          // สร้าง Pattern ในรูปแบบของ Regular Expression
          RegExp regExp = RegExp(r'\d+');

          // ค้นหาค่าตรงกับ Pattern ในข้อความ
          Match match = regExp.firstMatch(response.body)!;

          // หากพบตรงกับ Pattern ในข้อความ
          String number = match.group(0)!;
          print("Booking number: $number");
          if (selectedListItem == 'Pay with mobile banking') {
            uploadImage(number);
          }
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));
          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} stats = ${response.statusCode}');
        }
        MaterialPageRoute rout = MaterialPageRoute(
          builder: (context) => const LandingPage(widget: ListBooking()),
        );
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(context, rout, (route) => false);
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(
            context, '$e'); // Return an empty list in case of an exception
      }
    } else {}
  }

  var dio = Dio();

  Future<void> uploadImage(String? id) async {
    if (image == null) {
      errorDialog(context, 'กรุณาเพิ่มรูปภาพ');
      return;
    }
    var formData = FormData();
    formData.files.add(
      MapEntry(
        'file',
        await MultipartFile.fromFile(
          image!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      ),
    );
    formData.fields.add(
      MapEntry('id', id!),
    );
    try {
      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      // Send the form data to the backend
      await dio.post(
        '${ApiRouter.pathAPI}${SubPath.uploadSlip}',
        data: formData,
        options: options,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      errorDialog(context, '$e');
    }
  }

  int differenceDay() {
    if (dateIn != null && dateOut != null) {
      DateFormat format = DateFormat('dd/MM/yyyy');
      DateTime? dateTimeIn = format.parse(dateIn!);
      DateTime? dateTimeOut = format.parse(dateOut!);

      Duration difference = dateTimeOut.difference(dateTimeIn);
      int daysDifference = difference.inDays;
      if (daysDifference != 0) {
        return daysDifference;
      } else {
        return 1;
      }
    } else {
      return 1;
    }
  }

  Future<void> getMyPet() async {
    if (widget.token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.getMyPet}");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
        );

        if (response.statusCode == 200) {
          //print(response.body);
          final List<dynamic> jsonList = jsonDecode(response.body);
          pets = jsonList.map((json) => PetProfileJToD.fromJson(json)).toList();
          setState(() {});
          pet = pets[0];
          //print(pets);
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));
          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} stats = ${response.statusCode}');
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(context, '$e');
      }
    }
  }

  Future<void> getAdditionalService() async {
    if (widget.token != null) {
      final url =
          Uri.parse("${ApiRouter.pathAPI}${SubPath.getAdditionalService}");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: json.encode(
            {'id': widget.idHotel},
          ),
        );

        if (response.statusCode == 200) {
          //print('addition = ${response.body}');
          final List<dynamic> jsonList = jsonDecode(response.body);
          additionalServices = jsonList
              .map((json) => AdditionalServiceDartModel.fromJson(json))
              .toList();
          setState(() {});
          AdditionalServiceDartModel newService = AdditionalServiceDartModel(
            id: null, // ใส่ค่า id ที่เหมาะสม
            name: "no", // ใส่ชื่อบริการที่เหมาะสม
            price: 0.0, // ใส่ราคาที่เหมาะสม (ใช้เลขทศนิยม)
          );
          additionalServices.add(newService);
          additionalService = additionalServices.last;
          // print(additionalServices);
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));
          // ignore: use_build_context_synchronously
          errorDialog(context,
              '${exceptionModel.error} add stats = ${response.statusCode}');
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        errorDialog(context, '$e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    selectedListItem = items[0];
    getMyPet();
    getAdditionalService();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: buildLlistView(),
      bottomNavigationBar: buildBottomAppBar(),
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  minimumSize: MaterialStateProperty.all<Size>(Size(
                      MediaQuery.of(context).size.width - 100,
                      50)), // ขนาดขั้นต่ำของปุ่ม
                ),
                onPressed: () {
                  reserve();
                },
                child: const Text(
                  'จอง',
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

  ListView buildLlistView() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDatePicker(),
                buildPickPet(),
                buildAdditionalService(),
                buildPaymentMethod(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Visibility(
                    visible: selectedListItem == 'Pay with mobile banking',
                    child: GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: image == null
                          ? Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color:
                                        Colors.white, // สีพื้นหลังของ Container
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        // สีของเงา
                                        offset: Offset(0, 3),
                                        // ตำแหน่งเงาในแนวแกน x และ y
                                        blurRadius: 4,
                                        // ความคมชัดของเงา
                                        spreadRadius: 2, // การกระจายของเงา
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 250,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                            'แตะเพื่อแนบหลักฐานการโอนเงฺิน'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: Image.file(image!),
                            ),
                    ),
                  ),
                ),
                buildPriceBox(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
      });
    }
  }

  Padding buildPickPet() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextPet(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 130,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: TextFormField(
                    controller: TextEditingController(
                      text: pet?.petName,
                    ),
                    readOnly: true,
                    onTap: () async {
                      final selectedValue = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Choose an item'),
                            content: DropdownButtonFormField<PetProfileJToD?>(
                              value: pet, // ค่าที่ถูกเลือก
                              items: pets.map((PetProfileJToD? item) {
                                String? ss = item!.petName;
                                return DropdownMenuItem<PetProfileJToD?>(
                                  value: item,
                                  child: Text(ss!),
                                );
                              }).toList(),
                              onChanged: (PetProfileJToD? newValue) {
                                setState(() {
                                  pet = newValue!;
                                });
                                //print('pet id = ${pet!.id}');
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop(selectedListItem);
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (selectedValue != null) {
                        setState(() {
                          selectedListItem = selectedValue;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onSaved: (date) {},
                  ),
                ),
              ),
              buildLine(),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildPaymentMethod() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text('เลือกวิธีจ่ายเงิน'),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 130,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: TextFormField(
                    controller: TextEditingController(
                      text: selectedListItem,
                    ),
                    readOnly: true,
                    onTap: () async {
                      final selectedValue = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Choose an item'),
                            content: DropdownButtonFormField<String>(
                              value: selectedListItem, // ค่าที่ถูกเลือก
                              items: items.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedListItem = newValue!;
                                });
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop(selectedListItem);
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (selectedValue != null) {
                        setState(() {
                          selectedListItem = selectedValue;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onSaved: (date) {},
                  ),
                ),
              ),
              buildLine(),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildAdditionalService() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text('บริการเสริม'),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 130,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: TextFormField(
                    controller: TextEditingController(
                      text: additionalService?.name,
                    ),
                    readOnly: true,
                    onTap: () async {
                      final selectedValue = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Choose an item'),
                            content: DropdownButtonFormField<
                                AdditionalServiceDartModel?>(
                              value: additionalService, // ค่าที่ถูกเลือก
                              items: additionalServices
                                  .map((AdditionalServiceDartModel? item) {
                                return DropdownMenuItem<
                                    AdditionalServiceDartModel?>(
                                  value: item,
                                  child: Text(item!.name!),
                                );
                              }).toList(),
                              onChanged:
                                  (AdditionalServiceDartModel? newValue) {
                                setState(() {
                                  additionalService = newValue!;
                                });
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop(selectedListItem);
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (selectedValue != null) {
                        setState(() {
                          selectedListItem = selectedValue;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onSaved: (date) {},
                  ),
                ),
              ),
              buildLine(),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildPriceBox() {
    double? addPrice = additionalService?.price ?? 0.0;
    price = ((widget.room!.roomPrice! + addPrice) * differenceDay());
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Container(
          height: 50,
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
          child: Center(
            child: Text('ราคา $price บาท'),
          )),
    );
  }

  Padding buildDatePicker() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextIn(),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text('วัน'), // ข้อความ "gg"
                            Container(
                              width: 100,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(did == null ? '' : did!)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('เดือน'), // ข้อความ "gg"
                            Container(
                              width: 100,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(dim == null ? '' : dim!)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('ปี'), // ข้อความ "gg"
                            Container(
                              width: 100,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(diy == null ? '' : diy!)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: buildDatePickerIn(context),
                    ),
                  ],
                ),
                buildTextOut(),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text('วัน'), // ข้อความ "gg"
                            Container(
                              width: 100,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(dod == null ? '' : dod!)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('เดือน'), // ข้อความ "gg"
                            Container(
                              width: 100,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(dom == null ? '' : dom!)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('ปี'), // ข้อความ "gg"
                            Container(
                              width: 100,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(doy == null ? '' : doy!)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: buildDatePickerOut(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Padding buildTextOut() {
    return const Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Text('วันที่จะออก'),
    );
  }

  Padding buildTextIn() {
    return const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text('วันที่จะเข้าพัก'),
    );
  }

  Padding buildTextPet() {
    return const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text('สัตว์เลี้ยงที่จะเข้าพัก'),
    );
  }

  Padding buildLine() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        height: 1,
        color: Colors.black,
      ),
    );
  }

  SizedBox buildDatePickerIn(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: TextFormField(
          controller: TextEditingController(text: '' /*dateIn*/),
          // กำหนดค่าเริ่มต้นจาก petProfile
          readOnly: true,
          // ทำให้ไม่สามารถแก้ไขค่าได้โดยตรง
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), // กำหนดวันเริ่มต้น
              firstDate: DateTime(1900), // กำหนดวันแรก
              lastDate: DateTime(2100), // กำหนดวันสุดท้าย
            );
            if (pickedDate != null) {
              setState(() {
                dateIn = DateFormat('dd/MM/yyyy').format(pickedDate).toString();
                did = pickedDate.day.toString();
                dim = pickedDate.month
                    .toString(); // เมื่อเลือกวันที่แล้วให้กำหนดค่าใน petProfile
                diy = pickedDate.year.toString();
              });
              // อัพเดตค่า pickedDate ด้วยค่าใหม่ที่เลือก
              // this.pickedDate = pickedDate;
            }
          },
          decoration: const InputDecoration(
            border: InputBorder.none, // ซ่อนเส้นขอบของ TextField
          ),
          onSaved: (date) {
            // อัพเดตค่า petProfile.birthday ด้วยค่าวันที่ที่เลือกใน date
            //petProfile.birthday = date;
          },
        ),
      ),
    );
  }

  SizedBox buildDatePickerOut(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 130,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: TextFormField(
          controller: TextEditingController(text: ''),
          // กำหนดค่าเริ่มต้นจาก petProfile
          readOnly: true,
          // ทำให้ไม่สามารถแก้ไขค่าได้โดยตรง
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), // กำหนดวันเริ่มต้น
              firstDate: DateTime(1900), // กำหนดวันแรก
              lastDate: DateTime(2100), // กำหนดวันสุดท้าย
            );
            if (pickedDate != null) {
              setState(() {
                dateOut = DateFormat('dd/MM/yyyy')
                    .format(pickedDate)
                    .toString(); // เมื่อเลือกวันที่แล้วให้กำหนดค่าใน petProfile

                dod = pickedDate.day.toString();
                dom = pickedDate.month.toString();
                doy = pickedDate.year.toString();
              });
              // อัพเดตค่า pickedDate ด้วยค่าใหม่ที่เลือก
              // this.pickedDate = pickedDate;
            }
          },
          decoration: const InputDecoration(
            border: InputBorder.none, // ซ่อนเส้นขอบของ TextField
          ),
          onSaved: (date) {
            // อัพเดตค่า petProfile.birthday ด้วยค่าวันที่ที่เลือกใน date
            //petProfile.birthday = date;
          },
        ),
      ),
    );
  }
}

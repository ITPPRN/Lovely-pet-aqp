import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/exception_login.dart';
import '../unity/alert_dialog.dart';
import '../unity/api_router.dart';

class EditProfile extends StatelessWidget {
  final String? token;

  // Variables to store the values of Name and Phone Number fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  EditProfile({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Text('Edit Profile'),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  // You can set the profile picture here
                  backgroundImage: AssetImage('images/2.png'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  // Assigning controller for Name field
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneNumberController,
                  // Assigning controller for Phone Number field
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  maxLength: 10,
                  // Setting max length for Phone Number
                  keyboardType:
                      TextInputType.phone, // Setting keyboard type to phone
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    postData(context);
                    // Add your save/update logic here
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> postData(BuildContext context) async {
    final url = Uri.parse("${ApiRouter.pathAPI}${SubPath.updateProfile}");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(
          {
            'name': nameController.text,
            // Using controller's value for Name
            'phoneNumber': phoneNumberController.text,
            // Using controller's value for Phone Number
          },
        ),
      );

      if (response.statusCode == 200) {
        //routSer(response.body);
      } else {
        ExceptionLogin exceptionModel =
            ExceptionLogin.fromJson(jsonDecode(response.body));
        errorDialog(context, '${exceptionModel.error}');
      }
    } catch (e) {
      errorDialog(context, '$e');
    }
  }
}

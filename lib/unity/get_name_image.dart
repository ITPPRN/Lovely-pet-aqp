import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lovly_pet_app/model/exception_login.dart';
import 'package:lovly_pet_app/unity/api_router.dart';

class ImageService {
  List<String> images = [];

  Future<List<String>> getImageName(
      String? token, String? path, int? id) async {
    if (token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}$path");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(
            {'idHotel': id},
          ),
        );

        if (response.statusCode == 200) {
          print(response.body);
          final List<dynamic> responseData = json.decode(response.body);
          images = responseData.map((dynamic item) => item.toString()).toList();
          return images;
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));
          print(response.body);
          print('getImage exception = ${exceptionModel.error}');
          return [];
          // ignore: use_build_context_synchronously
          //errorDialog(context,
          //    'eqqqqq = ${exceptionModel.error} stats = ${response.statusCode}');
          //return []; // Return an empty list in case of an error
        }
      } catch (e) {
        print('getImage catch = $e');
        return [];
        // ignore: use_build_context_synchronously
        //errorDialog(context, '$e');
        //return []; // Return an empty list in case of an exception
      }
    } else {
      return [];
      //return [];
    }
  }

  //get image
  Future<dynamic> getImage(String? token, String? path, String? name) async {
    if (token != null) {
      final url = Uri.parse("${ApiRouter.pathAPI}$path");
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(
            {'name': name},
          ),
        );

        if (response.statusCode == 200) {
          final responseData = Uint8List.fromList(response.bodyBytes);
          return responseData;
        } else {
          ExceptionLogin exceptionModel =
              ExceptionLogin.fromJson(jsonDecode(response.body));
          print(response.body);
          print('getImage exception = ${exceptionModel.error}');
          return null;
        }
      } catch (e) {
        print('getImage catch = $e');
        return null;
      }
    }
    return null;
  }
}

import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lovly_pet_app/unity/api_router.dart';

class ImageUploader extends StatefulWidget {
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File? _image;
  int id = 1;

  var dio = Dio();

  Future<void> _uploadImage() async {
    if (_image == null) {
      return;
    }
    var formData = FormData();

    // Add the image file to the form data
    formData.files.add(
      MapEntry(
        'file',
        await MultipartFile.fromFile(
          _image!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      ),
    );

    formData.fields.add(
      MapEntry('id', id.toString()),
    );

    try {
      Options options = Options(
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJIb3RlbFBldFNlcnZpY2UiLCJwcmluY2lwYWwiOjEsInJvbGUiOiJVU0VSIiwiZXhwIjoxNjk2NzM1ODM0fQ.CCSN_Xs12YLymgZP4Z2kiFtBT_RaiFULcv9GgaFbO9I',
        },
      );
      // Send the form data to the backend
      await dio.post(
        '${ApiRouter.pathAPI}/room/upload-image',
        data: formData,
        options: options,
      );
      print('Image uploaded successfully');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Uploader'),
      ),
      body: Center(
        child:
            _image == null ? Text('No image selected.') : Image.file(_image!),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _pickImage,
            tooltip: 'Pick Image',
            child: Icon(Icons.image),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _uploadImage,
            tooltip: 'Upload Image',
            child: Icon(Icons.cloud_upload),
          ),
        ],
      ),
    );
  }
}

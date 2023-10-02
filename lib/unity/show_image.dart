import 'package:flutter/material.dart';
import 'package:lovly_pet_app/unity/api_router.dart';
import 'package:lovly_pet_app/unity/get_name_image.dart';

class ShowImage extends StatefulWidget {
  final String? token;
  final List<String>? images;
  const ShowImage({super.key, required this.token, required this.images});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  final imageService = ImageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, // กำหนดแนวนอน
          child: Column(
            children: widget.images!.map((imageUrl) {
              return GestureDetector(
                onTap: () {
                  print('กด $imageUrl');
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.memory(
                          snapshot.data!,
                          width: 300,
                        ),
                      );
                    } else {
                      return Container(
                        height: 100,
                        width: 100,
                        color: Colors.amber,
                      );
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

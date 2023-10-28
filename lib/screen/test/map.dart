import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Google Maps'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _launchUrl();
          },
          child: Text('Open Google Maps'),
        ),
      ),
    );
  }

  double? latitude = 20.7563;
  double? longitude = 100.5018;
  Uri buildGoogleMapsUrl() {
    return Uri.parse(
        'https://www.google.com/maps?q=${latitude.toString()},${longitude.toString()}');
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(buildGoogleMapsUrl())) {
      throw Exception('Could not launch buildGoogleMapsUrl()');
    }
  }
}


//   void openGoogleMaps() async {
//     final url = 'https://maps.google.com'; // URL for Google Maps
//     if (await canLaunchUrl(url as Uri)) {
//       await launchUrl(url as Uri);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }

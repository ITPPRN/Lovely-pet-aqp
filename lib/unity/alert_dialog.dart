import 'package:flutter/material.dart';
import 'package:lovly_pet_app/screen/login_screen.dart';

Future<void> errorDialog(BuildContext context, String message) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            backgroundColor: Colors.black38,
            title: Text(
              message,
              style: TextStyle(color: Colors.red[400]),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                      onPressed: (() => Navigator.pop(context)),
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.orange,
                        ),
                      )),
                ],
              ),
            ],
          ));
}

Future<void> successfullyApplied(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      backgroundColor: Colors.black38,
      title: Text(
        message,
        style: TextStyle(color: Colors.green[400]),
        textAlign: TextAlign.center,
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }));
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

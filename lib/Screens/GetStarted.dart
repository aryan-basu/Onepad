import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        Image.asset(
          "assets/images/icon.png",
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 20,
        ),
        Text("Welcome to Onepad",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 20,
        ),
        Text("Daily Notes"),
        SizedBox(
          height: 20,
        ),
        Text(
            "Take notes, reminders, set targets, collect resources and secure privacy"),
        SizedBox(
          height: 40,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Get Started"),
          style: TextButton.styleFrom(
              backgroundColor: Colors.yellow,
              primary: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18))),
        )
      ],
    ));
  }
}

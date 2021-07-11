import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        Image.asset(
          "assets/images/icon.png",
          fit: BoxFit.scaleDown,
        ),
        SizedBox(
          height: 20,
        ),
        Helper.text("Welcome to Onepad!", 14, 2, darktextcolor),
        SizedBox(
          height: 20,
        ),
        Helper.text("Daily Notes", 10, 2, darktextcolor),
        SizedBox(
          height: 20,
        ),
        Helper.text(
            "Take notes, reminders, set targets, collect resources and secure privacy",
            8,
            2,
            darktextcolor),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: Text(
            "Get Started",
            style: TextStyle(
              fontFamily: GoogleFonts.ubuntu(fontSize: 20).fontFamily,
            ),
          ),
          style: TextButton.styleFrom(
              backgroundColor: lightcolor,
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18))),
        )
      ],
    ));
  }
}

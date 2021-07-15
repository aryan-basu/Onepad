import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Helpers/colorhelper.dart';

class Helper {
  int radius = 10;
  int maxradius = 40;
  static Widget text(String msg, int size, int spacing, Color color) {
    return Text(
      msg,
      textAlign: TextAlign.center,
      style: GoogleFonts.ubuntu(
          fontWeight: FontWeight.bold,
          fontSize: size.toDouble(),
          color: color,
          letterSpacing: spacing.toDouble()),
    );
  }

  static Widget subtext(String msg, int size, int spacing, Color color) {
    return Text(
      msg,
      textAlign: TextAlign.center,
      style: GoogleFonts.ubuntu(
          fontWeight: FontWeight.normal,
          fontSize: size.toDouble(),
          color: color,
          letterSpacing: spacing.toDouble()),
    );
  }

  static Widget button(String msg, int radius) {
    return Container(
      child: Center(
        child: Helper.subtext(msg, 14, 0, lighttextcolor),
      ),
      height: 50,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius.toDouble()),
          color: darkcolor
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Helpers/helpers.dart';

class StarredNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Helper.text('Starred Notes', 20, 0)),
    );
  }
}

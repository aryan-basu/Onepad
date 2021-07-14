import 'package:flutter/material.dart';
import 'package:onepad/Helpers/colorhelper.dart';

class Notes extends StatefulWidget {
  const Notes({Key key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
    );
  }
}

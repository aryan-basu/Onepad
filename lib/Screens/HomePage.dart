import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Container(
              child: Text("Click on the + button to start a new note")),
        ),
      ),
    );
  }
}

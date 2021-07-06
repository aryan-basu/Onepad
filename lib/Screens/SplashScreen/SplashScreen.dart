import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        image: new Image.asset('assets/images/splashscreen.gif'),
        backgroundColor: Colors.black,
        photoSize: 100.0);
  }
}

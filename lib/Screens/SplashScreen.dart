import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/GetStarted.dart';
import 'package:onepad/Screens/HomeScreen/homeScreen.dart';
import 'package:onepad/Screens/Onboarding/Onboarding.dart';
import 'package:onepad/Services/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String userid = Onepad.sharedPreferences.getString('username');

  @override
  void initState() {
    // TODO: implement initState
    print(Onepad.sharedPreferences.getString('username'));
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (b) =>
                    userid == null ? OnboardScreen() : HomeScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 4,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}

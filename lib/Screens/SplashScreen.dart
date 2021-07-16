import 'dart:async';

import 'package:flutter/material.dart';

import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Screens/Onboarding/Onboarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (b) => OnboardingScreen())));
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
                height: MediaQuery.of(context).size.height / 1.5,
                child:
                    Image.asset('assets/images/Splash.gif', fit: BoxFit.cover),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}

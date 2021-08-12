import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onepad/Screens/HomeScreen/homeScreen.dart';
import 'package:onepad/Screens/Onboarding/Onboarding.dart';
import 'package:onepad/Services/const.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String uid = Onepad.sharedPreferences.getString('uid');

  get brightness => null;
  @override
  void initState() {
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (b) => uid == null ? OnboardScreen() : HomeScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 1.5,
                child:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Image.asset('assets/images/splash2.gif',
                            fit: BoxFit.cover)
                        : Image.asset('assets/images/Splash.gif',
                            fit: BoxFit.cover),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}

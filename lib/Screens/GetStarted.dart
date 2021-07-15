import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/SignInScreen/SignInScreen.dart';

import 'SingupScreen/SignupScreen.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"))),
          ),
          SizedBox(
            height: 20,
          ),
          Helper.text("Welcome to Onepad!", 18, 1, darktextcolor),
          SizedBox(
            height: 10,
          ),
          Helper.subtext("Read | Write | Repeat", 10, 1, darkcolor),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (b) => SignUpScreen()));
              },
              child: Helper.button('Get Started', 10))
        ],
      ),
    ));
  }
}

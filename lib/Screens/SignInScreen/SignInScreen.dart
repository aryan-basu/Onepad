import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/SingupScreen/SignupScreen.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _passwordvisible = false;
  String email = '';
  String password = '';

  void _signin() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/bg.jfif',
                  ),
                  fit: BoxFit.cover),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Helper.text('Login ', 35, 1, darktextcolor),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: boxcolor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: GoogleFonts.ubuntu(
                              fontSize: 15,
                              color: darktextcolor,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: boxcolor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: !_passwordvisible,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: GoogleFonts.ubuntu(
                              fontSize: 15,
                              color: darktextcolor,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordvisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: darkcolor,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordvisible = !_passwordvisible;
                                });
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                        onTap: () {
                          _signin();
                        },
                        child:
                            Center(child: Helper.button("SignIn", maxradius))),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (b) => SignInScreen()));
                        },
                        child: Helper.text(
                            'Do not have an account ? Create a new one !',
                            10,
                            1,
                            lighttextcolor),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}

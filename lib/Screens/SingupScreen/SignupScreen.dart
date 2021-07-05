import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/SignInScreen/SignInScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _passwordvisible = false;
  bool _confirmpassvisible = false;
  String email = '';
  String username = '';
  String confirmpassword = '';
  String password = '';

  void _signup() async {}
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
                        Helper.text('Welcome Champ', 35, 1, darktextcolor),
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
                          username = value;
                        },
                        decoration: InputDecoration(
                            hintText: 'Username',
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
                                  size: 20,),
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
                          confirmpassword = value;
                        },
                        obscureText: !_confirmpassvisible,
                        decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            hintStyle: GoogleFonts.ubuntu(
                              fontSize: 15,
                              color: darktextcolor,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _confirmpassvisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: darkcolor,
                                  size: 20,),
                              onPressed: () {
                                setState(() {
                                  _confirmpassvisible = !_confirmpassvisible;
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
                          _signup();
                        },
                        child:
                            Center(child: Helper.button("Signup", maxradius))),
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
                        child: Helper.text('Already have an account ? Login',
                            10, 1, lighttextcolor),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}

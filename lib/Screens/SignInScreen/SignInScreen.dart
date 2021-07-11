import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/Errors/Alert.dart';
import 'package:onepad/Screens/HomeScreen/homeScreen.dart';
import 'package:onepad/Screens/SingupScreen/SignupScreen.dart';

import 'package:onepad/Services/const.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  bool isloading = false;
  bool passwordvisibility = false;

  final formKey = GlobalKey<FormState>();

  Future<void> _signin() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      print(emailcontroller.text);
      print(passwordcontroller.text);
      print(namecontroller.text);
      User firebaseUser;

      await _firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailcontroller.text.toString(),
              password: passwordcontroller.text.toString())
          .then((auth) {
        firebaseUser = auth.user;
      }).catchError((error) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return AlertErrorDialog(message: error.message.toString());
            });
      });
      if (firebaseUser != null) {
        uploaddata(firebaseUser).then((value) {
          Route route = MaterialPageRoute(builder: (c) => HomeScreen());
          Navigator.pushReplacement(context, route);
        });
      }
    }
  }

  uploaddata(User user) async {
    FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      "uid": user.uid,
      "email": user.email,
    });
    Onepad.sharedPreferences.setString('uid', user.uid);
    Onepad.sharedPreferences.setString('email', user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/login.png'))),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: lightcolor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(40)),
                          child: TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Please provide a valid email";
                            },
                            controller: emailcontroller,
                            style: GoogleFonts.ubuntu(color: darktextcolor),
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: darkcolor,
                                  size: 15,
                                ),
                                hintText: 'Email',
                                hintStyle:
                                    GoogleFonts.ubuntu(color: darktextcolor),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: lightcolor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(40)),
                          child: TextFormField(
                            controller: passwordcontroller,
                            validator: (val) {
                              return val.length < 4
                                  ? 'Provide a strong password'
                                  : null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  size: 15,
                                  color: darkcolor,
                                ),
                                hintText: 'Password',
                                hintStyle:
                                    GoogleFonts.ubuntu(color: darktextcolor),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordvisibility = !passwordvisibility;
                                    });
                                  },
                                  icon: passwordvisibility
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                  color: darkcolor,
                                  iconSize: 15,
                                )),
                            obscureText: !passwordvisibility,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            _signin();
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: darkcolor,
                                borderRadius: BorderRadius.circular(40)),
                            child: Center(
                                child: Helper.text(
                                    'SignIn', 20, 1, lighttextcolor)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (b) => SignUpScreen()));
                          },
                          child: Helper.text('Do not have an account? Signup',
                              10, 1, darkcolor),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

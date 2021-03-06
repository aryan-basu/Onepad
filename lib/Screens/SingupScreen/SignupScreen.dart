import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/Errors/Alert.dart';
import 'package:onepad/Screens/Info/Gettinginfo.dart';
import 'package:onepad/Screens/SignInScreen/SignInScreen.dart';
import 'package:onepad/Services/const.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  bool isloading = false;
  bool passwordvisibility = false;

  final formKey = GlobalKey<FormState>();

  Future<void> _signup() async {
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
          Route route = MaterialPageRoute(builder: (c) => GettingInfo());
          Navigator.pushReplacement(context, route);
        });
      }
    }
  }

  uploaddata(User user) async {
    FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      "uid": user.uid,
      "email": user.email,
      "username": namecontroller.text.trim(),
    });
    Onepad.sharedPreferences.setString('uid', user.uid);
    Onepad.sharedPreferences.setString('email', user.email);
    Onepad.sharedPreferences
        .setString('username', namecontroller.text.trim())
        .then((value) {
      print('Firebase set properly');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: background,
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
                          image: AssetImage('assets/images/signup.png'))),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(84, 140, 168, 1),
                              borderRadius: BorderRadius.circular(40)),
                          child: TextFormField(
                            controller: namecontroller,
                            validator: (val) {
                              return val.length < 4
                                  ? 'Provide a valid username'
                                  : null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                size: 15,
                              ),
                              hintText: 'Username',
                              // hintStyle:
                              //     GoogleFonts.ubuntu(color: darktextcolor),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(84, 140, 168, 1),
                              borderRadius: BorderRadius.circular(40)),
                          child: TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Please provide a valid email address";
                            },
                            controller: emailcontroller,
                            //       style: GoogleFonts.ubuntu(color: darktextcolor),
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  size: 15,
                                ),
                                hintText: 'Email',
                                // hintStyle:
                                //     GoogleFonts.ubuntu(color: darktextcolor),
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
                              color: Color.fromRGBO(84, 140, 168, 1),
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
                                ),
                                hintText: 'Password',
                                // hintStyle:
                                //     GoogleFonts.ubuntu(color: darktextcolor),
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
                            _signup();
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(51, 66, 87, 1),
                                borderRadius: BorderRadius.circular(40)),
                            child: Center(
                                child: Text('Sign Up',
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.white,
                                        fontSize: 20,
                                        letterSpacing: 0))),
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
                                    builder: (b) => SignInScreen()));
                          },
                          child: Helper.text(
                              'Already have an account? Sign In', 10, 1),
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

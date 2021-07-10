import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/HomeScreen/homescreen.dart';
import 'package:onepad/Screens/SignInScreen/SignInScreen.dart';
import 'package:onepad/Services/const.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController usernamecontroller = new TextEditingController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool passwordvisibility = false;
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _signup() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      User firebaseUser;

      await _firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailcontroller.text.trim(),
              password: passwordcontroller.text.trim())
          .then((auth) {
        firebaseUser = auth.user;
      }).catchError((error) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              // return AlertErrorDialog(message: error.message.toString());
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
      "username": usernamecontroller.text.trim(),
    });
    Onepad.sharedPreferences.setString("uid", user.uid);
    Onepad.sharedPreferences.setString("email", user.email);
    Onepad.sharedPreferences
        .setString("username", usernamecontroller.text.trim())
        .then((value) {
      print('Firebase set properly');
      print(user.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.8,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://image.flaticon.com/icons/png/128/4508/4508684.png'))),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: lightcolor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(40)),
                          child: TextFormField(
                            validator: (val) {
                              return val.length < 4
                                  ? 'Provide a valid username'
                                  : null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                size: 15,
                                color: darkcolor,
                              ),
                              hintText: 'Username',
                              hintStyle:
                                  GoogleFonts.ubuntu(color: darktextcolor),
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
                              color: lightcolor.withOpacity(0.5),
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
                              color: lightcolor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(40)),
                          child: TextFormField(
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
                            _signup();
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: darkcolor,
                                borderRadius: BorderRadius.circular(40)),
                            child: Center(
                                child: Helper.text(
                                    'Signup', 20, 1, lighttextcolor)),
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
                          child: Helper.text('Alreay have an account? Signin',
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

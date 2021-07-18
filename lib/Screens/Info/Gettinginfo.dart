import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/HomeScreen/homeScreen.dart';
import 'package:onepad/Services/const.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:toast/toast.dart';

class GettingInfo extends StatefulWidget {
  const GettingInfo({Key key}) : super(key: key);

  @override
  _GettingInfoState createState() => _GettingInfoState();
}

class _GettingInfoState extends State<GettingInfo> {
  PickedFile image;

  void gallery() async {
    final _userimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image = PickedFile(_userimage.path);
    });
  }

  void camera() async {
    final _userimage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      image = PickedFile(_userimage.path);
    });
  }

  uploadimage() async {
    String fileName = basename(image.path); //Get File Name - Or set one
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    TaskSnapshot uploadTask =
        await firebaseStorageRef.putFile(File(image.path));
    String url = await uploadTask.ref.getDownloadURL();
    return url;
  }

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController status = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkcolor,
        child: Icon(Icons.arrow_forward_ios_outlined),
        onPressed: () {
          firstname.text.isEmpty &&
                  lastname.text.isEmpty &&
                  phonenumber.text.isEmpty &&
                  status.text.isEmpty
              ? Toast.show('Do fill the above form', context,
                  backgroundColor: darkcolor,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM)
              : uploadimage().then((url) {
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(Onepad.sharedPreferences.getString('uid'))
                      .collection('Profile')
                      .add({
                    "firstname": firstname.text.toString(),
                    "lastname": lastname.text.toString(),
                    "phonenumber": phonenumber.text.toString(),
                    "status": status.text.toString(),
                    "image": url
                  }).whenComplete(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (b) => HomeScreen()));
                  });
                });
        },
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Row(
                  children: [
                    Helper.subtext("Setup your'e profile", 18, 0, darkcolor),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
              ),
              Stack(children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[100],
                  backgroundImage: image == null
                      ? NetworkImage(
                          'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png')
                      : FileImage(File(image.path)),
                ),
                Positioned(
                  top: 100,
                  left: 100,
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                    child: Helper.text(
                                        "Choose a picture", 15, 1, darkcolor)),
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  child: Row(children: [
                                    IconButton(
                                        onPressed: () {
                                          gallery();
                                        },
                                        icon: Icon(
                                          Icons.image,
                                          size: 15,
                                          color: darkcolor,
                                        )),
                                    Helper.text(
                                        'From Gallery', 13, 0, darkcolor),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          camera();
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.camera,
                                          color: darkcolor,
                                          size: 15,
                                        )),
                                    Helper.text(
                                        'From Camera', 13, 0, darkcolor),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(FontAwesomeIcons.camera),
                    iconSize: 20,
                    color: darkcolor,
                  ),
                )
              ]),
              SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: lightcolor.withOpacity(0.2)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              controller: firstname,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: 'First Name',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      letterSpacing: 1),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent))),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, right: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: lightcolor.withOpacity(0.2)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: lastname,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        letterSpacing: 1),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent))),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Container(
                        decoration: BoxDecoration(
                            color: lightcolor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(40)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                              cursorColor: Colors.black,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                              controller: phonenumber,
                              decoration: InputDecoration(
                                  hintText: 'Phone number',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      letterSpacing: 1),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)))),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Container(
                        decoration: BoxDecoration(
                            color: lightcolor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(40)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                              cursorColor: Colors.black,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                              controller: status,
                              decoration: InputDecoration(
                                  hintText: 'Status',
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      letterSpacing: 1),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent)))),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

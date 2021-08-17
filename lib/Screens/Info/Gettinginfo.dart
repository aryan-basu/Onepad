import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(51, 66, 87, 1),
        child: Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.white,
        ),
        onPressed: () {
          firstname.text.isEmpty &&
                  lastname.text.isEmpty &&
                  phonenumber.text.isEmpty &&
                  status.text.isEmpty
              ? Toast.show('Do fill the above form', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM)
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
                    Helper.subtext("Setup your'e profile", 18, 0),
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
                                    child:
                                        Helper.text("Choose a picture", 15, 1)),
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
                                        )),
                                    Helper.text('From Gallery', 13, 0),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          camera();
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.camera,
                                          size: 15,
                                        )),
                                    Helper.text('From Camera', 13, 0),
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
                    icon: Icon(
                      FontAwesomeIcons.camera,
                      color: Color.fromRGBO(84, 140, 168, 1),
                    ),
                    iconSize: 20,
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
                            color: Color.fromRGBO(84, 140, 168, 1),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              controller: firstname,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: 'First Name',
                                  hintStyle: TextStyle(
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
                              color: Color.fromRGBO(84, 140, 168, 1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: lastname,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    hintStyle: TextStyle(
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
                            color: Color.fromRGBO(84, 140, 168, 1),
                            borderRadius: BorderRadius.circular(40)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                              controller: phonenumber,
                              decoration: InputDecoration(
                                  hintText: 'Phone number',
                                  hintStyle: TextStyle(
                                      // color: Colors.black,
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
                            color: Color.fromRGBO(84, 140, 168, 1),
                            borderRadius: BorderRadius.circular(40)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                              controller: status,
                              decoration: InputDecoration(
                                  hintText: 'Status',
                                  hintStyle: TextStyle(
                                      //color: Colors.black,
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

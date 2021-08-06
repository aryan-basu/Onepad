import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:onepad/Services/const.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/HomeScreen/homeScreen.dart';

class DetailScreen extends StatefulWidget {
  final QueryDocumentSnapshot onepad;
  DetailScreen({this.onepad});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String returnMonth(DateTime date) {
    return new DateFormat.MMMM().format(DateTime.now());
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.onepad['title']);
    super.initState();
  }

  PickedFile image;
  String imageurl = "";

  void gallery() async {
    final _userimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image = PickedFile(_userimage.path);
    });
    if (image == null) {
      print('Not selected');
    } else {
      print('File selected');
      uploadimage();
    }
  }

  void camera() async {
    final _userimage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      image = PickedFile(_userimage.path);
    });
    if (image == null) {
      print('Not selected');
    } else {
      print('File selected');
      uploadimage();
    }
  }

  uploadimage() async {
    String fileName = basename(image.path); //Get File Name - Or set one
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    TaskSnapshot uploadTask =
        await firebaseStorageRef.putFile(File(image.path));
    String url = await uploadTask.ref.getDownloadURL();

    setState(() {
      imageurl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentDate = DateTime.now();
    TextEditingController titlecontroller = TextEditingController();
    TextEditingController subtitlecontroller = TextEditingController();
    TextEditingController descontroller = TextEditingController();
    String title;
    String des;
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 60,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (b) => HomeScreen()));
                      },
                      icon: Icon(Icons.arrow_back_ios),
                      color: darkcolor,
                      iconSize: 20,
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(Onepad.sharedPreferences.getString('uid'))
                            .collection('Notes')
                            .doc(Onepad.sharedPreferences.getString('uid'))
                            .update({
                          'title': titlecontroller.text.toString(),
                          'subtitle': subtitlecontroller.text.toString(),
                          'description': descontroller.text.toString(),
                          'created':
                              '${currentDate.day} ${returnMonth(DateTime.now())} ',
                          'time': DateTime.now().millisecondsSinceEpoch,
                          'image':imageurl
                        });
                      },
                      icon: Icon(Icons.edit),
                      color: Colors.red,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titlecontroller,
                        cursorColor: darktextcolor,
                        decoration: InputDecoration.collapsed(
                            hintText: widget.onepad['title']),
                        style: GoogleFonts.ubuntu(
                            fontSize: 15,
                            color: Colors.black,
                            letterSpacing: 0),
                        onChanged: (val) {
                          title = val;
                        },
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                              controller: subtitlecontroller,
                              cursorColor: darktextcolor,
                              decoration: InputDecoration.collapsed(
                                  hintText: widget.onepad['subtitle']),
                              style: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  color: Colors.black,
                                  letterSpacing: 0),
                              onChanged: (val) {
                                title = val;
                              }),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          controller: descontroller,
                          onChanged: (val) {
                            des = val;
                          },
                          maxLines: 18,
                          cursorColor: darktextcolor,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            hintText: widget.onepad['description'],
                            hintStyle: GoogleFonts.ubuntu(
                                fontSize: 20,
                                color: Colors.black,
                                letterSpacing: 0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      widget.onepad['image'] == null
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(widget.onepad['image']),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: lightcolor.withOpacity(0.5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  gallery();
                                },
                                icon: Icon(Icons.image),
                                color: darkcolor,
                                iconSize: 25,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.settings_voice),
                                color: darkcolor,
                                iconSize: 25,
                              ),
                              IconButton(
                                onPressed: () {
                                  camera();
                                },
                                icon: Icon(FontAwesomeIcons.camera),
                                color: darkcolor,
                                iconSize: 25,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
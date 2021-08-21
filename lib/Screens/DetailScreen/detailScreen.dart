import 'package:intl/intl.dart';
import 'package:onepad/Services/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:onepad/Screens/HomeScreen/homeScreen.dart';
import 'package:toast/toast.dart';

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

  @override
  Widget build(BuildContext context) {
    var currentDate = DateTime.now();
    TextEditingController titlecontroller = TextEditingController();
    TextEditingController subtitlecontroller = TextEditingController();
    TextEditingController descontroller = TextEditingController();
    String title = "";
    String des = "";
    String subtitle = "";
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                        iconSize: 20,
                      ),
                      Spacer(),
                      Positioned(
                        child: IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(
                                      Onepad.sharedPreferences.getString("uid"))
                                  .collection("Starred")
                                  .add({
                                "title": widget.onepad['title'],
                                "image": widget.onepad['image'],
                                "description": widget.onepad['description'],
                                "subtitile": widget.onepad['subtitle'],
                                "created": widget.onepad['created'],
                              }).whenComplete(() {
                                Toast.show("Starred your'e notes 💥", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.CENTER);
                              });
                            },
                            icon: Icon(
                              Icons.star,
                              color: Colors.red,
                            )),
                      ),
                      IconButton(
                        onPressed: () {
                          title.length.toInt() == 0
                              ? print("Null")
                              : print(title.length);

                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(Onepad.sharedPreferences.getString('uid'))
                              .collection('Notes')
                              .doc(widget.onepad['id'])
                              .update({
                            'title': title.length.toInt() == 0
                                ? widget.onepad['title']
                                : title,
                            'subtitle': subtitle.length.toInt() == 0
                                ? widget.onepad['subtitle']
                                : subtitle,
                            'description': des.length.toInt() == 0
                                ? widget.onepad['description']
                                : des,
                            'created':
                                '${currentDate.day} ${returnMonth(DateTime.now())} ',
                            'time': DateTime.now().millisecondsSinceEpoch,
                          }).whenComplete(() {
                            Navigator.pop(context);
                          });
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.red,
                      ),
                      IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(Onepad.sharedPreferences.getString('uid'))
                              .collection('Notes')
                              .doc(widget.onepad['id'])
                              .delete()
                              .whenComplete(() {
                            Navigator.pop(context);
                          });
                        },
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
                          decoration: InputDecoration.collapsed(
                              hintText: widget.onepad['title']),
                          style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              //color: Colors.black,
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
                                decoration: InputDecoration.collapsed(
                                    hintText: widget.onepad['subtitle']),
                                style: GoogleFonts.ubuntu(
                                    fontSize: 15,
                                    //color: Colors.black,
                                    letterSpacing: 0),
                                onChanged: (val) {
                                  subtitle = val;
                                }),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          padding: const EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            controller: descontroller,
                            onChanged: (val) {
                              des = val;
                            },
                            maxLines: 18,
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
                                  //color: Colors.black,
                                  letterSpacing: 0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        widget.onepad['image'] == null
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              widget.onepad['image']),
                                          fit: BoxFit.fitHeight)),
                                ),
                              ),
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

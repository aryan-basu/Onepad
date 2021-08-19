import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onepad/Screens/HomeScreen/homeScreen.dart';
import 'package:path/path.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:onepad/Services/const.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:toast/toast.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button for description';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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

  String returnMonth(DateTime date) {
    return new DateFormat.MMMM().format(DateTime.now());
  }

  String title;

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController subtitlecontroller = TextEditingController();
  DateTime id = DateTime.now();
  var currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          child: Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        title.isEmpty
                            ? Toast.show("Enter the title", context,
                                duration: Toast.LENGTH_LONG,
                                textColor: Colors.white,
                                gravity: Toast.CENTER)
                            : FirebaseFirestore.instance
                                .collection('Users')
                                .doc(Onepad.sharedPreferences.getString('uid'))
                                .collection('Notes')
                                .doc(id.toString())
                                .set({
                                'title': title,
                                'description': _text,
                                'subtitle': subtitlecontroller.text,
                                'created':
                                    '${currentDate.day} ${returnMonth(DateTime.now())} ',
                                'time': DateTime.now().millisecondsSinceEpoch,
                                'image': imageurl,
                                'id': id.toString()
                              }).whenComplete(() => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (b) => HomeScreen())));
                      },
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      )),
                ],
              ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Color.fromRGBO(84, 140, 168, 1),
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          backgroundColor: Color.fromRGBO(84, 140, 168, 1),
          onPressed: _listen,
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            children: [
              TextFormField(
                controller: titlecontroller,
                decoration: InputDecoration.collapsed(
                  hintText: "Title",
                ),
                style: GoogleFonts.ubuntu(fontSize: 20, letterSpacing: 0),
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
                        hintText: 'SubTitle',
                      ),
                      style: GoogleFonts.ubuntu(fontSize: 18, letterSpacing: 0),
                      onChanged: (val) {
                        title = val;
                      }),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration.collapsed(
                  hintText: _text,
                ),
                maxLines: 20,
                style: GoogleFonts.ubuntu(fontSize: 20, letterSpacing: 0),
              ),
              image != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 20, right: 20.0, bottom: 0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: FileImage(File(image.path)),
                              fit: BoxFit.fitHeight,
                            )),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
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
                                    child: Text('Upload a picture',
                                        style: GoogleFonts.josefinSans(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    child: Row(children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            gallery();
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.image,
                                            size: 15,
                                            color:
                                                Color.fromRGBO(84, 140, 168, 1),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'From gallery',
                                        style: GoogleFonts.josefinSans(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 100,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            camera();
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.camera,
                                            color:
                                                Color.fromRGBO(84, 140, 168, 1),
                                            size: 15,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Take a photo',
                                        style: GoogleFonts.josefinSans(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://image.flaticon.com/icons/png/128/3892/3892835.png"))),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}

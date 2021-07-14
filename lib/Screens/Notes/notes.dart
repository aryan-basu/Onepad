import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Helpers/colorhelper.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  String title;
  String des;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: lightcolor,
          child: Icon(
            Icons.settings_voice,
            size: 30,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.check))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          cursorColor: darktextcolor,
                          decoration: InputDecoration.collapsed(
                            hintText: "Title",
                          ),
                          style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              color: Colors.black,
                              letterSpacing: 1),
                          onChanged: (val) {
                            title = val;
                          },
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          padding: const EdgeInsets.only(top: 12.0),
                          child: TextFormField(
                            onChanged: (val) {
                              des = val;
                            },
                            maxLines: 20,
                            cursorColor: darktextcolor,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              hintText: "Description",
                              hintStyle: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  color: Colors.black,
                                  letterSpacing: 1),
                            ),
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

  // void add() async {
  //   // save to db
  //   CollectionReference ref = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser.uid)
  //       .collection('notes');

  //   var data = {
  //     'title': title,
  //     'description': des,
  //     'created': DateTime.now(),
  //   };

  //   ref.add(data);

  //   //

  //   Navigator.pop(context);
  // }
}

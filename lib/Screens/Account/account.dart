import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/HomeScreen/homeScreen.dart';
import 'package:onepad/Screens/SignInScreen/SignInScreen.dart';
import 'package:onepad/Screens/SplashScreen.dart';
import 'package:onepad/Services/const.dart';

import '../AppInfo.dart';

class Account extends StatefulWidget {
  const Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await Onepad.sharedPreferences.clear().whenComplete(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (b) => SplashScreen()));
    });
  }

  String username = Onepad.sharedPreferences.getString('username');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            signOut();
          },
          backgroundColor: Color.fromRGBO(84, 140, 168, 1),
          child: Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(Onepad.sharedPreferences.getString('uid'))
                      .collection("Profile")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(),
                      );
                    } else {
                      return Container(
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          snapshot.data.docs[index]['image']),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(40)),
                                ),
                              ),
                              Positioned(
                                  top: 10,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (b) => HomeScreen()));
                                    },
                                    icon: Icon(Icons.arrow_back),
                                  )),
                              Positioned(
                                bottom: 50,
                                right: 0,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data.docs[index]['firstname'] +
                                          " " +
                                          snapshot.data.docs[index]['lastname'],
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        snapshot.data.docs[index]['status'],
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        snapshot.data.docs[index]
                                            ['phonenumber'],
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]);
                          },
                        ),
                      );
                    }
                  }),
            ),
            ListTile(
              title: Text(
                "App info ",
                style: GoogleFonts.ubuntu(),
              ),
              leading: Icon(Icons.info),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (b) => AppInfo()));
                },
              ),
            ),
            ListTile(
              title: Text(
                "Your'e notes",
                style: GoogleFonts.ubuntu(),
              ),
              leading: Icon(Icons.info),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios_outlined),
                onPressed: () {},
              ),
            ),
            ListTile(
              title: Text(
                "Terms and conditions ",
                style: GoogleFonts.ubuntu(),
              ),
              leading: Icon(Icons.info),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (b) => AppInfo()));
                },
              ),
            ),
          ],
        ));
  }
}

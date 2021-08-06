import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/Account/account.dart';
import 'package:onepad/Screens/DetailScreen/detailScreen.dart';
import 'package:onepad/Screens/HomeScreen/notes_visible.dart';
import 'package:onepad/Screens/Notes/notes.dart';
import 'package:onepad/Services/const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final random = Random();
  String username = Onepad.sharedPreferences.getString('username');
  int _currentindex = 0;
  List<Widget> options = <Widget>[NotesVisible(), Account()];

  void itemtap(int index) {
    setState(() {
      _currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: new PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          child: Container(
            decoration: BoxDecoration(
              color: background,
            ),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Helper.subtext(
                        username == null
                            ? 'Hello '
                            : 'Hello ' + username + " !",
                        20,
                        0,
                        darktextcolor)),
                Spacer(),
                Container(
                    height: 30,
                    width: 50,
                    child: Image.asset('assets/images/logo.png'))
              ],
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (b) => Notes()));
        },
        backgroundColor: lightcolor,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: darkcolor,
        unselectedItemColor: darkcolor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (b) => NotesVisible()));
                  },
                  icon: Icon(Icons.widgets_outlined)),
              title: Helper.text('', 15, 0, Colors.black)),
          BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (b) => Account()));
                  },
                  icon: Icon(Icons.person)),
              title: Helper.text('', 15, 0, Colors.black)),
        ],
        currentIndex: _currentindex,
        onTap: itemtap,
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: Center(
          child: options.elementAt(_currentindex),
        ),
      ),
    );
  }
}

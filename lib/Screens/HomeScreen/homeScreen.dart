import 'dart:math';
import 'package:flutter/material.dart';

import 'package:onepad/Screens/StarredNotes.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/Account/account.dart';
import 'package:onepad/Screens/HomeScreen/notes_visible.dart';
import 'package:onepad/Screens/Notes/notes.dart';
import 'package:onepad/Services/const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: new PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          child: Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Helper.subtext("Welcome to Onepad", 20, 0)),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (b) => super.widget));
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Color.fromRGBO(84, 140, 168, 1),
                    )),
                Container(
                    height: 30,
                    width: 50,
                    child: Image.asset('assets/images/logo.png'))
              ],
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(84, 140, 168, 1),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (b) => Notes()));
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color.fromRGBO(84, 140, 168, 1),
        selectedItemColor: Colors.white,
        backgroundColor: Color.fromRGBO(51, 66, 87, 1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.widgets_outlined),
              title: Helper.text('', 15, 0)),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (b) => StarredNotes()));
                },
                icon: Icon(Icons.star),
              ),
              title: Helper.text('', 15, 0)),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (b) => Account()));
                },
                icon: Icon(Icons.person),
              ),
              title: Helper.text('', 15, 0)),
        ],
        currentIndex: _currentindex,
        onTap: itemtap,
      ),
      body: Container(
        child: Center(
          child: options.elementAt(_currentindex),
        ),
      ),
    );
  }
}

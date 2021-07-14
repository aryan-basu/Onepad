import 'package:flutter/material.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/Notes/notes.dart';
import 'package:onepad/Services/const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentindex = 0;
  List<Widget> options = <Widget>[
    Helper.text('Home', 20, 0, Colors.black),
    Helper.text('Account Profile', 20, 0, Colors.black),
  ];
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
                        'Hello ' +
                            '${(Onepad.sharedPreferences.getString('username'))} !',
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
              icon: Icon(
                Icons.list
              ),
              title: Helper.text('', 15, 0, Colors.black)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Helper.text('', 15, 0, Colors.black)),
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

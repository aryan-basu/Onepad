import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Screens/StarredNotes.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/HomeScreen/notes_visible.dart';
import 'package:onepad/Screens/Notes/notes.dart';
import 'package:onepad/Services/const.dart';
import '../AppInfo.dart';
import '../SplashScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentindex = 0;
  List<Widget> options = <Widget>[NotesVisible(), StarredNotes()];

  void itemtap(int index) {
    setState(() {
      _currentindex = index;
    });
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
    await Onepad.sharedPreferences.clear().whenComplete(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (b) => SplashScreen()));
    });
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

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
                IconButton(
                    onPressed: () {
                      scaffoldKey.currentState.openDrawer();
                    },
                    icon: Icon(Icons.menu)),
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
      key: scaffoldKey,
      drawer: Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0, left: 0),
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0)),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)),
                  width: 250,
                  child: Drawer(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(Onepad.sharedPreferences.getString('uid'))
                            .collection("Profile")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: SizedBox(),
                            );
                          } else {
                            return Container(
                              child: ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          snapshot.data.docs[index]['image']),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      snapshot.data.docs[index]['firstname'] +
                                          " " +
                                          snapshot.data.docs[index]['lastname'],
                                      style: GoogleFonts.ubuntu(fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data.docs[index]['status'],
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data.docs[index]['phonenumber'],
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(
                                      height: 10,
                                      color: Colors.grey,
                                    ),
                                    ListTile(
                                      title: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (b) => AppInfo()));
                                        },
                                        child: Text(
                                          "App info ",
                                          style: GoogleFonts.ubuntu(),
                                        ),
                                      ),
                                      leading: Icon(Icons.info),
                                    ),
                                    ListTile(
                                      title: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (b) => AppInfo()));
                                        },
                                        child: Text(
                                          "Terms and conditions ",
                                          style: GoogleFonts.ubuntu(),
                                        ),
                                      ),
                                      leading: Icon(Icons.code),
                                    ),
                                    ListTile(
                                      title: GestureDetector(
                                        onTap: () {
                                          signout();
                                        },
                                        child: Text(
                                          "Logout",
                                          style: GoogleFonts.ubuntu(),
                                        ),
                                      ),
                                      leading: Icon(
                                        (Icons.logout),
                                      ),
                                    ),
                                  ]);
                                },
                              ),
                            );
                          }
                        }),
                  )))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              icon: Icon(Icons.star), title: Helper.text('', 15, 0)),
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

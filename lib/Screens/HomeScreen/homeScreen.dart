import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/Account/account.dart';
import 'package:onepad/Screens/DetailScreen/detailScreen.dart';
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
                  onPressed: () {}, icon: Icon(Icons.widgets_outlined)),
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
        height: MediaQuery.of(context).size.height,
        width: 400,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(Onepad.sharedPreferences.getString('uid'))
                .collection('Notes')
                .orderBy('time')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 50),
                child: GridView.builder(
                    itemCount: snapshot.data.docs.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(
                                    random.nextInt(245),
                                    random.nextInt(245),
                                    random.nextInt(245),
                                    random.nextInt(245))
                                .withOpacity(0.1)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            snapshot.data.docs[index]['image'] == ""
                                ? SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (b) => DetailScreen()));
                                    },
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: NetworkImage(snapshot
                                                  .data.docs[index]['image']),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Helper.text(snapshot.data.docs[index]['title'], 15,
                                0, darkcolor),
                            Container(
                              child: Padding(
                                padding:
                                    snapshot.data.docs[index]['image'] == ""
                                        ? const EdgeInsets.only(
                                            top: 5,
                                            left: 20,
                                            right: 20,
                                            bottom: 10)
                                        : const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data.docs[index]['description'],
                                  maxLines:
                                      snapshot.data.docs[index]['image'] == ""
                                          ? 7
                                          : 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.ubuntu(
                                      letterSpacing: 0, fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              );
            }),
      ),
    );
  }
}

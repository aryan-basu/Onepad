import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Services/const.dart';

import 'DetailScreen/detailScreen.dart';

class StarredNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(Onepad.sharedPreferences.getString('uid'))
                      .collection('Starred')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null &&
                        snapshot.data.docs.length != 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          top: 20,
                          right: 20,
                        ),
                        child: GridView.builder(
                            itemCount: snapshot.data.docs.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  print(snapshot.data.docs[index]['created']);
                                  print("Onepad");
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 300,
                                      width: 300,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.blue.withOpacity(0.1)),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          snapshot.data.docs[index]['image'] ==
                                                  ""
                                              ? SizedBox()
                                              : Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ['image']),
                                                          fit: BoxFit
                                                              .fitHeight)),
                                                ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Helper.text(
                                            snapshot.data.docs[index]['title'],
                                            15,
                                            0,
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: snapshot.data.docs[index]
                                                          ['image'] ==
                                                      ""
                                                  ? const EdgeInsets.only(
                                                      top: 5,
                                                      left: 20,
                                                      right: 20,
                                                      bottom: 10)
                                                  : const EdgeInsets.only(
                                                      left: 10.0),
                                              child: Text(
                                                snapshot.data.docs[index]
                                                            ['description'] ==
                                                        null
                                                    ? Helper.subtext(
                                                        'No description',
                                                        20,
                                                        0,
                                                      )
                                                    : snapshot.data.docs[index]
                                                        ['description'],
                                                maxLines:
                                                    snapshot.data.docs[index]
                                                                ['image'] ==
                                                            ""
                                                        ? 7
                                                        : 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.ubuntu(
                                                    letterSpacing: 0,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://image.flaticon.com/icons/png/128/4076/4076549.png"))),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

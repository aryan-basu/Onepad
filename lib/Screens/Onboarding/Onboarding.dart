import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/SingupScreen/SignupScreen.dart';

class OnboardScreen extends StatefulWidget {
  static const String id = "onboard_screen";
  OnboardScreen({Key key}) : super(key: key);

  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final _controller = PageController();

  int _currentPage = 0;

  final List<Map<String, String>> splashData = [
    {
      "title": "Welcome to Onepad",
      "subtitle": "Write your first note ",
      "image": "assets/images/Onboard1.png"
    },
    {
      "title": "Save Images",
      "subtitle": "Upload your favourite images",
      "image": "assets/images/Onboard2.png"
    },
    {
      "title": "Voice Notes",
      "subtitle": "In a hurry? Just speak!",
      "image": "assets/images/Onboard3.png"
    },
  ];

  AnimatedContainer _buildDots({int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: _currentPage == index
            ? Color.fromRGBO(84, 140, 168, 1)
            : Colors.grey,
        // color: _currentPage == index ? darkcolor : lightcolor,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: splashData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 8,
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Image.asset('${(splashData[index]['image'])}')),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 12,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child:
                          Helper.text("${(splashData[index]['title'])}", 20, 0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 100),
                        child: Helper.text(
                            "${(splashData[index]['subtitle'])}", 18, 0),
                      ),
                    ),
                  ]);
                },
                onPageChanged: (value) => setState(() {
                  _currentPage = value;
                }),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(splashData.length,
                      (int index) => _buildDots(index: index)),
                )),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 70,
                child: _currentPage != 2
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (b) => SignUpScreen()));
                                  },
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        'Skip',
                                        style: GoogleFonts.ubuntu(
                                            color:
                                                Color.fromRGBO(84, 140, 168, 1),
                                            fontSize: 14,
                                            letterSpacing: 0),
                                      ),
                                    ),
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 30, bottom: 20.0),
                              child: GestureDetector(
                                  onTap: () {
                                    if (_currentPage == 2) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (b) => SignUpScreen()));
                                    }
                                    _controller.jumpToPage(++_currentPage);
                                  },
                                  child: Container(
                                    child: Center(
                                      child: Helper.subtext('Continue', 14, 0),
                                    ),
                                    height: 50,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: Color.fromRGBO(84, 140, 168, 1),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (b) => SignUpScreen()));
                            },
                            child: Container(
                              child: Center(
                                  child: Text('Get Started',
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.white,
                                          fontSize: 14,
                                          letterSpacing: 0))),
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(84, 140, 168, 1),
                                borderRadius: BorderRadius.circular(40),
                              ),
                            )),
                      )),
          ],
        ),
      ),
    );
  }
}

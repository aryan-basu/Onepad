import 'package:flutter/material.dart';
import 'package:onepad/Helpers/colorhelper.dart';
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
      "subtitle": "Make your'e first note ",
      "image": "assets/images/Onboard1.png"
    },
    {
      "title": "Save Images",
      "subtitle": "Upload your'e favourite images ",
      "image": "assets/images/Onboard2.png"
    },
    {
      "title": "Voice notes",
      "subtitle": "Lazy to write just speak",
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
        color: _currentPage == index ? darkcolor : lightcolor,
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
      backgroundColor: background,
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
                    // Spacer(flex: 1),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Helper.text("${(splashData[index]['title'])}", 20,
                          0, Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 100),
                        child: Helper.text("${(splashData[index]['subtitle'])}",
                            18, 0, Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 12,
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Image.asset('${(splashData[index]['image'])}')),
                    // Spacer(flex: 1),
                    // AspectRatio(
                    //   aspectRatio: 16 / 9,
                    //   child: Image.asset('${(splashData[index]['image'])}',
                    //       fit: BoxFit.contain),
                    // ),
                    // Spacer(),
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
                                      child: Helper.subtext(
                                          'Skip', 14, 0, lighttextcolor),
                                    ),
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: darkcolor),
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
                                      child: Helper.subtext(
                                          'Continue', 14, 0, darkcolor),
                                    ),
                                    height: 50,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.transparent),
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
                                child: Helper.subtext(
                                    'Get Started', 14, 0, lighttextcolor),
                              ),
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: darkcolor),
                            )),
                      )),
          ],
        ),
      ),
    );
  }
}

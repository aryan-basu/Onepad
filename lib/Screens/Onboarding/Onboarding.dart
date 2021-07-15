import 'package:flutter/material.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/SignUpScreen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> splashData = [
    {
      "subtitle": "Click on the '+' icon to start a new note",
      "image": "assets/images/Onboard1.png",
      "title": "Take Notes On The Go!",
    },
    {
      "title": "Add Images",
      "subtitle": "Add images from your Gallery",
      "image": "assets/images/Onboard2.png"
    },
    {
      "title": "Add Voice Notes",
      "subtitle": "In a hurry? Add a voice note!",
      "image": "assets/images/Onboard3.png"
    },
  ];
  AnimatedContainer _buildDots({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: darkcolor,
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
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _controller,
                itemCount: splashData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      Spacer(flex: 2),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            splashData[index]['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Helper.text(
                          splashData[index]['title']!, 18, 2, darktextcolor),
                      Spacer(
                        flex: 1,
                      ),
                      Helper.text(
                          splashData[index]['subtitle']!, 14, 2, darktextcolor),
                      Spacer(),
                    ],
                  );
                },
                onPageChanged: (value) => setState(() => _currentPage = value),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (int index) => _buildDots(index: index),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      // ignore: deprecated_member_use
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _currentPage + 1 == splashData.length
                                ? GestureDetector(
                                    onTap: () {
                                      _controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeIn,
                                      );
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (b) => SignUpScreen()));
                                    },
                                    child: Helper.button('Get Started', 20))
                                : Padding(
                                    padding: const EdgeInsets.only(top: 0.2),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (b) =>
                                                            SignUpScreen()));
                                              },
                                              child: Helper.button("Skip", 20)),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                _controller.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.easeIn,
                                                );
                                              },
                                              child:
                                                  Helper.button('Continue', 20))
                                        ]))
                          ]),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

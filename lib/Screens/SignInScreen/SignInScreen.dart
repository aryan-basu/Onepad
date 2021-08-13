import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Helpers/helpers.dart';
import 'package:onepad/Screens/Errors/LoadDialog.dart';
import 'package:onepad/Screens/HomeScreen/homeScreen.dart';
import 'package:onepad/Screens/Info/Gettinginfo.dart';
import 'package:onepad/Screens/SingupScreen/SignupScreen.dart';
import 'package:onepad/Services/const.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailcontroller = new TextEditingController();

  TextEditingController passwordcontroller = new TextEditingController();

  bool isloading = false;
  bool passwordvisibility = false;
  final formKey = GlobalKey<FormState>();
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  String _message = 'Log in/out by pressing the buttons below.';

  Future<void> _googleSignin() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuthentication.accessToken,
        );
        try {
          UserCredential userCredential =
              await _firebaseAuth.signInWithCredential(authCredential);
          final User user = userCredential.user;
          print(user.uid);
          Onepad.sharedPreferences.setString('uid', user.uid);
          Onepad.sharedPreferences.setString('username', user.displayName);
          Onepad.sharedPreferences.setString('email', user.email);
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Null> _login() async {
    final FacebookLoginResult result =
        await facebookSignIn.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken _accessToken = result.accessToken;

        AuthCredential fbcredential =
            FacebookAuthProvider.credential(_accessToken.token);

        _firebaseAuth.signInWithCredential(fbcredential).then((fbuser) {
          Onepad.sharedPreferences.setString('uid', fbuser.user.uid);
          Onepad.sharedPreferences
              .setString('username', fbuser.user.displayName);
          Onepad.sharedPreferences.setString('email', fbuser.user.email);
          print("SUZZESS");

          print(fbuser.user.email);

          print(fbuser.user.phoneNumber);

          print(fbuser.user.photoURL);

          print(fbuser.user.displayName);

          print(fbuser.user.uid);
        }).catchError((e) {
          print(e);

          print("ERROR");
        }).whenComplete(() {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (b) => GettingInfo()));
        });

        final FacebookAccessToken accessToken = result.accessToken;

        _showMessage('''

         Logged in!         

         Token: ${accessToken.token}

         User id: ${accessToken.userId}

         Expires: ${accessToken.expires}

         Permissions: ${accessToken.permissions}

         Declined permissions: ${accessToken.declinedPermissions}

         ''');

        break;

      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');

        break;

      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');

        break;
    }
  }

  Future<Null> _logOut() async {
    await facebookSignIn.logOut();
    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _signin() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      print(emailcontroller.text);
      print(passwordcontroller.text);

      User firebaseUser;

      await _firebaseAuth
          .signInWithEmailAndPassword(
              email: emailcontroller.text.toString(),
              password: passwordcontroller.text.toString())
          .then((auth) {
        firebaseUser = auth.user;
      }).catchError((error) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return LoadingErrorDialog(message: error.message.toString());
            });
      });
      if (firebaseUser != null) {
        readdata(firebaseUser).then((value) {
          Route route = MaterialPageRoute(builder: (c) => HomeScreen());
          Navigator.pushReplacement(context, route);
        });
      }
    }
  }

  readdata(User fuser) async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(fuser.uid)
        .get()
        .then((dataSnapshot) async {
      print(dataSnapshot.data()['uid']);
      print(dataSnapshot.data()['email']);
      print(dataSnapshot.data()['username']);
      Onepad.sharedPreferences
          .setString("username", dataSnapshot.data()["username"]);
      Onepad.sharedPreferences.setString("uid", dataSnapshot.data()["uid"]);
      Onepad.sharedPreferences.setString("email", dataSnapshot.data()["email"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.8,
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/login.png'))),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Form(
                    key: formKey,
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                            
                            borderRadius: BorderRadius.circular(40)),
                        child: TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? null
                                : "Please provide a valid email";
                          },
                          controller: emailcontroller,
                          // style: GoogleFonts.ubuntu(color: darktextcolor),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                              
                                size: 15,
                              ),
                              hintText: 'Email',
                              // hintStyle:
                              //     GoogleFonts.ubuntu(color: darktextcolor),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            
                            borderRadius: BorderRadius.circular(40)),
                        child: TextFormField(
                          controller: passwordcontroller,
                          validator: (val) {
                            return val.length < 4
                                ? 'Provide a strong password'
                                : null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                size: 15,
                               
                              ),
                              hintText: 'Password',
                              // hintStyle:
                              //     GoogleFonts.ubuntu(color: darktextcolor),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordvisibility = !passwordvisibility;
                                  });
                                },
                                icon: passwordvisibility
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                               
                                iconSize: 15,
                              )),
                          obscureText: !passwordvisibility,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _signin();
                        },
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                             
                              borderRadius: BorderRadius.circular(40)),
                          child: Center(
                              child: Text('Sign In',
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.white,
                                      fontSize: 20,
                                      letterSpacing: 0))),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _googleSignin().whenComplete(() {
                                FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(Onepad.sharedPreferences
                                        .getString('uid'))
                                    .set({
                                  "uid":
                                      Onepad.sharedPreferences.getString('uid'),
                                  "email": Onepad.sharedPreferences
                                      .getString('email'),
                                  "username": Onepad.sharedPreferences
                                      .getString('username'),
                                }).whenComplete(() {
                                  Onepad.sharedPreferences.getString('email') !=
                                          null
                                      ? Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (b) => HomeScreen()))
                                      : Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (b) => SignInScreen()));
                                });
                              });
                            },
                            child: Container(
                                height: 25,
                                child: Image.network(
                                    'https://image.flaticon.com/icons/png/128/2702/2702602.png')),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              _login().whenComplete(() {
                                FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(Onepad.sharedPreferences
                                        .getString('uid'))
                                    .set({
                                  "uid":
                                      Onepad.sharedPreferences.getString('uid'),
                                  "email": Onepad.sharedPreferences
                                      .getString('email'),
                                  "username": Onepad.sharedPreferences
                                      .getString('username'),
                                }).whenComplete(() {
                                  Onepad.sharedPreferences.getString('email') !=
                                          null
                                      ? Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (b) => HomeScreen()))
                                      : Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (b) => SignInScreen()));
                                });
                              });
                            },
                            child: Image.network(
                              "https://image.flaticon.com/icons/png/128/733/733547.png",
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (b) => SignUpScreen()));
                        },
                        child: Helper.text('New User ? Sign Up', 10, 1),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onepad/Screens/SingupScreen/SignupScreen.dart';

class AlertErrorDialog extends StatelessWidget {
  final String message;

  const AlertErrorDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (b)=>SignUpScreen()));
          },
          child: Center(
            child: Text('OK'),
          ),
        )
      ],
    );
  }
}
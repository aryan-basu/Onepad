import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onepad/Screens/SignInScreen/SignInScreen.dart';

class LoadingErrorDialog extends StatelessWidget {
  final String message;

  const LoadingErrorDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (b) => SignInScreen()));
          },
          child: Center(
            child: Text('OK'),
          ),
        )
      ],
    );
  }
}

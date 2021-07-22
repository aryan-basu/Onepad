import 'package:flutter/material.dart';
import 'package:onepad/Helpers/colorhelper.dart';
import 'package:onepad/Screens/Info/Gettinginfo.dart';
import 'package:intl/intl.dart';


class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  User user = User("");
  bool _isAdmin = false;
  TextEditingController _userCountryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: Provider.of(context).auth.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return displayUserInformation(context, snapshot);
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
   getProfileImage() {
    if(_firebaseAuth.currentUser.photoURL != null) {
      return Image.network(_firebaseAuth.currentUser.photoURL, height: 100, width: 100);
    } else {
      return Icon(Icons.account_circle, size: 100);
    }
  }
  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Provider.of(context).auth.getProfileImage(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Name: ${authData.displayName ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Email: ${authData.email ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Created: ${DateFormat('MM/dd/yyyy').format(authData.metadata.creationTime)}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        showSignOut(context, authData.isAnonymous),
        
      ],
    );
  }

  _getProfileData() async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
      );
  }

  Widget showSignOut(context, bool isAnonymous) {
    if (isAnonymous == true) {
      return RaisedButton(
        child: Text("Sign In To Save Your Data"),
        onPressed: () {
          Navigator.of(context).pushNamed('/convertUser');
        },
      );
    } else {
      return RaisedButton(
        child: Text("Sign Out"),
        onPressed: () {
          try {
            Provider.of(context).auth.signOut();
          } catch (e) {
            print(e);
          }
        },
      );
    }
  }
}

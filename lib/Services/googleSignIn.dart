import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onepad/Services/const.dart';

class Authentication {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> googleSignIn() async {
    final GoogleSignInAccount googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final GoogleAuthCredential googleAuthCredential =
        GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(googleAuthCredential);
    final User user = userCredential.user;
    assert(user.displayName != null);
    assert(user.email != null);
    final User currentUser = _firebaseAuth.currentUser;
    assert(currentUser.uid == user.uid);
    Onepad.sharedPreferences.setString('username', user.displayName);
    Onepad.sharedPreferences.setString('email', user.email);
  }

  Future<String> googleSignOut() async {
    await _googleSignIn.signOut();
  }
  
}

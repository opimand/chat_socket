import 'package:chat_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //create user obj based on FirebaseUser
  FireBaseUser _userFromFirebaseUser(User user) {
    return user != null ? FireBaseUser(uid: user.uid) : null;
  }

  // sign in anon
  //auth Stream
  Stream<FireBaseUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign in with google
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user;
      _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in facebook
  Future signInWithFacebook() async {
    try {

      dynamic result = await facebookLogin.logIn(['email']);

      final token = result.accessToken;
      print('TEST token: $token.');
      if (result.status == FacebookLoginStatus.loggedIn) {
        FacebookAccessToken myToken = result.accessToken;
        print('TEST myToken: $myToken');

        AuthCredential credential =
        FacebookAuthProvider.credential(myToken.token);
        var user = await FirebaseAuth.instance.signInWithCredential(credential);
        print('TEST USER: $user');
      }
    } catch (e) {
      print('Error: ${e.toString()}');

      return null;
    }
  }

// sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection('users');

class AuthProvider with ChangeNotifier {
  bool isAuthh = false;
  bool authSkipped = false;

  String username;
  String profilePhotoUrl;
  String email;

  bool get isAuth {
    return isAuth;
  }

  tryGoogleSignIn() {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error Signing In: $err');
    });

    googleSignIn
        .signInSilently(
      suppressErrors: false,
    )
        .then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error Silently Signing In: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print('User:  $account');
      username = account.displayName;
      profilePhotoUrl = account.photoUrl;
      email = account.email;

      // setState(() {
      isAuthh = true;
      notifyListeners();
      // });
    } else {
      // setState(() {
      isAuthh = false;
      notifyListeners();
      // });
    }
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }
}

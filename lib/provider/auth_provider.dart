import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/userdata.dart';
// import 'package:provider/provider.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection('users');
User currentUser;

class AuthProvider with ChangeNotifier {
  bool isAuthh = false;
  bool authSkippedd = false;

  String usernamee;
  String profilePhotoUrll;
  String emaill;

  bool get isAuth {
    return isAuthh;
  }

  bool get authSkipped {
    return authSkippedd;
  }

  String get username {
    return usernamee;
  }

  String get profilePhotoUrl {
    return profilePhotoUrll;
  }

  String get email {
    return emaill;
  }

  tryGoogleSignIn() {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignIn(account);
    }, onError: (err) {
      // isAuthh = false;
      // notifyListeners();
      print('Error Signing In: $err');
    });

    googleSignIn
        .signInSilently(
      suppressErrors: false,
    )
        .then((account) {
      handleSignIn(account);
    }).catchError((err) {
      // isAuthh = false;
      // notifyListeners();
      print('Error Silently Signing In: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      print('User:  $account');
      usernamee = account.displayName;
      profilePhotoUrll = account.photoUrl;
      emaill = account.email;
      await addUserToDatabase(emaill, usernamee, profilePhotoUrll);
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

  login() async {
    await googleSignIn.signIn().then((value) => isAuthh = true);

    notifyListeners();
  }

  logout() async {
    googleSignIn.signOut().then((value) => isAuthh = false);

    notifyListeners();
  }

  skipAuth() {
    authSkippedd = true;
    isAuthh = false;
    notifyListeners();
  }

  addUserToDatabase(
    String emaill,
    String usernamee,
    String profilePhotoUrll,
  ) async {
    DocumentSnapshot doc = await usersRef.document(emaill).get();

    if (!doc.exists) {
      print('yes');
      await usersRef.document(emaill).setData({
        "email": emaill,
        "photoUrl": profilePhotoUrll,
        "username": usernamee,
      });

      doc = await usersRef.document(emaill).get();
      notifyListeners();
    }
    currentUser = User.fromDocument(doc);
    notifyListeners();
  }
}

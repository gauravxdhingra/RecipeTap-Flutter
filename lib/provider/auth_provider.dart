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
      usernamee = account.displayName;
      profilePhotoUrll = account.photoUrl;
      emaill = account.email;
      addUserToDatabase(emaill, usernamee, profilePhotoUrll);
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
    
    googleSignIn.signIn().then(
          (value) => isAuthh = true,
        );
    notifyListeners();
  }

  logout() {
    googleSignIn.signOut().then(
          (value) => isAuthh = false,
        );
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

    if (doc.exists) {
      print(doc.data);
      print(doc.documentID);
      print(doc.exists);
      await usersRef.document(emaill).updateData({
        "email": emaill,
        "photoUrl": profilePhotoUrll,
        "username": usernamee,
      });
    } else {
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
  }
}

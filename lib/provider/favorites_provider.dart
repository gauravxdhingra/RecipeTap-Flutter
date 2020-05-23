import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipetap/provider/auth_provider.dart';
// import 'package:provider/provider.dart';



class FavoritesProvider with ChangeNotifier {
  String id;
  // String profilePhoto;String i;

  set setEmail(email) {
    id = email;
  }

  // set setProfilePhoto(email) {
  //   id = email;
  // }

  // set setUsername(email) {
  //   id = email;
  // }

  getUsersById() async {
    // final id = Provider.of<AuthProvider>(context).email;
    DocumentSnapshot doc = await usersRef.document(id).get();
    // then((DocumentSnapshot doc) {
    if (doc.exists) {
      print(doc.data);
      print(doc.documentID);
      print(doc.exists);
    } else {
      await usersRef.document(id).setData({});
    }
    // });
  }
}

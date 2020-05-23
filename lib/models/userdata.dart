import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String photoUrl;
  final String username;

  User({
    this.email,
    this.photoUrl,
    this.username,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      email: doc['email'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
    );
  }
}

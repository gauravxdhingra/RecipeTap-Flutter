import 'package:cloud_firestore/cloud_firestore.dart';

class RecentsModel {
  final String title;
  final String desc;
  final String coverPhotoUrl;
  final String recipeUrl;
  final Timestamp timestamp;

  RecentsModel({
    this.recipeUrl,
    this.title,
    this.desc,
    this.coverPhotoUrl,
    this.timestamp,
  });

  factory RecentsModel.fromDocument(DocumentSnapshot doc) {
    return RecentsModel(
      title: doc['title'],
      desc: doc['desc'],
      coverPhotoUrl: doc['coverImageUrl'],
      recipeUrl: doc['recipeUrl'],
      timestamp: doc['timestamp'],
    );
  }
}

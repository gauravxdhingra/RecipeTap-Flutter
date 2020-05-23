import 'package:cloud_firestore/cloud_firestore.dart';

class RecentsModel {
  final String title;
  final String desc;
  final String coverPhotoUrl;
  final Timestamp timestamp;

  RecentsModel({
    this.title,
    this.desc,
    this.coverPhotoUrl,
    this.timestamp,
  });

  factory RecentsModel.fromDocument(DocumentSnapshot doc) {
    return RecentsModel(
      title: doc['title'],
      desc: doc['userId'],
      coverPhotoUrl: doc['coverImageUrl'],
      timestamp: doc['timestamp'],
    );
  }
}

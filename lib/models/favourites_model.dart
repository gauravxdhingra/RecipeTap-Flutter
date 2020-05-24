import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesModel {
  final String title;
  final String desc;
  final String coverPhotoUrl;
  final String recipeUrl;
  final Timestamp timestamp;

  FavouritesModel({
    this.recipeUrl,
    this.title,
    this.desc,
    this.coverPhotoUrl,
    this.timestamp,
  });

  factory FavouritesModel.fromDocument(DocumentSnapshot doc) {
    return FavouritesModel(
      title: doc['title'],
      desc: doc['desc'],
      coverPhotoUrl: doc['coverImageUrl'],
      recipeUrl: doc['recipeUrl'],
      timestamp: doc['timestamp'],
    );
  }
}

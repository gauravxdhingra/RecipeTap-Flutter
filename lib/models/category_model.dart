import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String title;
  final String categoryUrl;
  final Timestamp timestamp;

  CategoryModel({
    this.categoryUrl,
    this.title,
    this.timestamp,
  });

  factory CategoryModel.fromDocument(DocumentSnapshot doc) {
    return CategoryModel(
      title: doc['title'],
      categoryUrl: doc['categoryUrl'],
      timestamp: doc['timestamp'],
    );
  }
}

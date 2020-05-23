import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipetap/models/recipe_model.dart';
import 'package:recipetap/models/userdata.dart';
import 'package:recipetap/provider/auth_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/recents_model.dart';
// import 'package:provider/provider.dart';

final recentsRef = Firestore.instance.collection('recentlyViewed');

class RecentsProvider with ChangeNotifier {
  RecipeModel recipe;
  List<RecentsModel> recentslist = [];
  String recipeId = Uuid().v4();

  addToRecents(RecipeModel recipe, String email) async {
    DocumentSnapshot doc = await recentsRef.document(currentUser.email).get();
    // if (doc.exists) {
    print(doc.data);
    print(doc.documentID);
    print(doc.exists);
    Timestamp timestamp = Timestamp.now();
    await recentsRef
        .document(email)
        .collection('recents')
        // .document(recipeId)
        .document()
        .setData({
      "title": recipe.title,
      "coverImageUrl": recipe.coverPhotoUrl[0],
      "desc": recipe.desc,
      "timestamp": timestamp,
    });

    // doc = await recentsRef.document(email).get();
    notifyListeners();
  }

  fetchRecentRecipes(email) async {
    QuerySnapshot recents = await recentsRef
        .document(email)
        .collection('recents')
        .orderBy(
          'timestamp',
          descending: true,
        )
        .limit(10)
        .getDocuments();

    recents.documents.forEach((DocumentSnapshot doc) {
      print(doc);
      recentslist.add(RecentsModel.fromDocument(doc));
      print(recentslist);
    });
  }

// TODO: Collapsing Home Search
// TODO: Search not adding more
}

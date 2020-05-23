import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipetap/models/recipe_model.dart';
import 'package:recipetap/models/userdata.dart';
import 'package:recipetap/provider/auth_provider.dart';
import 'package:uuid/uuid.dart';
// import 'package:provider/provider.dart';

final recentsRef = Firestore.instance.collection('recentlyViewed');

class RecentsProvider with ChangeNotifier {
  RecipeModel recipe;
  String recipeId = Uuid().v4();

  addToRecents(RecipeModel recipe, String email) async {
    DocumentSnapshot doc = await recentsRef.document(currentUser.email).get();

    if (doc.exists) {
      print(doc.data);
      print(doc.documentID);
      print(doc.exists);
    } else {
      await recentsRef.document(email).setData({
        recipeId: {
          "title": recipe.title,
          "coverImageUrl": recipe.coverPhotoUrl[0],
          "desc": recipe.desc,
        }
      });

      doc = await recentsRef.document(email).get();
      notifyListeners();
    }
    // currentUser = User.fromDocument(doc);
  }

// TODO: Collapsing Home Search
// TODO: Search not adding more
}

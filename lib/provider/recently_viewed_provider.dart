import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipetap/models/recipe_model.dart';
import 'package:recipetap/models/userdata.dart';
import 'package:recipetap/provider/auth_provider.dart';
import 'package:recipetap/provider/favorites_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/recents_model.dart';
import '../models/favourites_model.dart';
// import 'package:provider/provider.dart';

final recentsRef = Firestore.instance.collection('recentlyViewed');
final favoritesRef = Firestore.instance.collection('favoriteRecipes');

class RecentsProvider with ChangeNotifier {
  RecipeModel recipe;
  List<RecentsModel> recentslist = [];
  String recipeId = Uuid().v4();

  List<FavouritesModel> favouritesList = [];

  List<RecentsModel> get recentRecipes {
    return recentslist;
  }

  List<FavouritesModel> get favRecipes {
    return favouritesList;
  }

  addToRecents(RecipeModel recipe, String email) async {
    DocumentSnapshot doc = await recentsRef.document(currentUser.email).get();
    print(doc.data);
    print(doc.documentID);
    print(doc.exists);
    Timestamp timestamp = Timestamp.now();

    final documents =
        await recentsRef.document(email).collection('recents').getDocuments();

    final recipeurl1 = recipe.recipeUrl.split("/recipe/")[1];
    final recipeurll =
        recipeurl1.split("/")[0] + "-" + recipeurl1.split("/")[1];

    documents.documents.forEach((doc) {
      if (doc.documentID == recipeurll) {
        return;
      }
    });

    await recentsRef
        .document(email)
        .collection('recents')
        // .document(recipeId)
        .document('$recipeurll')
        .setData({
      "title": recipe.title,
      "coverImageUrl": recipe.coverPhotoUrl[0],
      "desc": recipe.desc,
      "recipeUrl": recipe.recipeUrl,
      "timestamp": timestamp,
    });
    notifyListeners();
  }

  fetchRecentRecipes(email) async {
    List<RecentsModel> _recentslist = [];
    QuerySnapshot recents = await recentsRef
        .document(email)
        .collection('recents')
        .orderBy(
          'timestamp',
          descending: true,
        )
        .limit(10)
        .getDocuments();

    // recentslist = recents.documents;
    recents.documents.forEach((DocumentSnapshot doc) {
      print(doc);
      _recentslist.add(RecentsModel.fromDocument(doc));
      print(recentslist);
    });
    recentslist = _recentslist;
    notifyListeners();
  }

  addToFavourites(RecipeModel recipe, String email) async {
    DocumentSnapshot doc = await favoritesRef.document(currentUser.email).get();
    print(doc.data);
    print(doc.documentID);
    print(doc.exists);
    Timestamp timestamp = Timestamp.now();

    final documents = await favoritesRef
        .document(email)
        .collection('favoriteRecipes')
        .getDocuments();

    final recipeurl1 = recipe.recipeUrl.split("/recipe/")[1];
    final recipeurll =
        recipeurl1.split("/")[0] + "-" + recipeurl1.split("/")[1];

    documents.documents.forEach((doc) {
      if (doc.documentID == recipeurll) {
        return;
      }
    });

    await favoritesRef
        .document(email)
        .collection('favs')
        // .document(recipeId)
        .document('$recipeurll')
        .setData({
      "title": recipe.title,
      "coverImageUrl": recipe.coverPhotoUrl[0],
      "desc": recipe.desc,
      "recipeUrl": recipe.recipeUrl,
      "timestamp": timestamp,
    });
    notifyListeners();
  }

// TODO ZERO RECENTS START ADDING - MESSAGE
// TODO: Collapsing Home Search
// TODO: Search not adding more
}

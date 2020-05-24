// ALso Includes Favourites Provider Functions and others

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipetap/models/recipe_model.dart';
import 'package:recipetap/models/userdata.dart';
import 'package:recipetap/provider/auth_provider.dart';
import 'package:recipetap/provider/favorites_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/recents_model.dart';
import '../models/favourites_model.dart';
import '../models/category_model.dart';
// import 'package:provider/provider.dart';

final recentsRef = Firestore.instance.collection('recentlyViewed');
final favoritesRef = Firestore.instance.collection('favoriteRecipes');
final favoriteCategoriesRef =
    Firestore.instance.collection('favoriteCategories');

class RecentsProvider with ChangeNotifier {
  RecipeModel recipe;
  String recipeId = Uuid().v4();

  List<RecentsModel> recentslist = [];

  List<FavouritesModel> favouritesList = [];

  List<CategoryModel> favouriteCategoriesList = [];

  List<RecentsModel> get recentRecipes {
    return recentslist;
  }

  List<FavouritesModel> get favRecipes {
    return favouritesList;
  }

  List<CategoryModel> get getFavouriteCategoriesList {
    return favouriteCategoriesList;
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
// TODO crud delete - check if favourite
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

  fetchFavoriteRecipes(email) async {
    List<FavouritesModel> _favslist = [];
    QuerySnapshot recents = await favoritesRef
        .document(email)
        .collection('favs')
        .orderBy(
          'timestamp',
          descending: true,
        )
        // .limit(10)
        .getDocuments();

    // recentslist = recents.documents;
    recents.documents.forEach((DocumentSnapshot doc) {
      print(doc);
      _favslist.add(FavouritesModel.fromDocument(doc));
      // print(recentslist);
    });
    favouritesList = _favslist;
    notifyListeners();
  }

  Future<bool> checkIfFav(String url, String email) async {
    final recipeurl1 = url.split("/recipe/")[1];
    final recipeurll =
        recipeurl1.split("/")[0] + "-" + recipeurl1.split("/")[1];
    DocumentSnapshot doc = await favoritesRef
        .document(email)
        .collection('favs')
        .document(recipeurll)
        .get();

    if (doc.exists) {
      print("Is a fav checked");

      return true;
    }
    print("Is Not a fav Checked");
    return false;
  }

  removeFav(String url, String email) async {
    bool isAlreadyFav = await checkIfFav(url, email);

    final recipeurl1 = url.split("/recipe/")[1];
    final recipeurll =
        recipeurl1.split("/")[0] + "-" + recipeurl1.split("/")[1];

    if (isAlreadyFav) {
      await favoritesRef
          .document(email)
          .collection('favs')
          .document(recipeurll)
          .delete();
      notifyListeners();
      print("Removed From Fav");
    } else {
      notifyListeners();
      print("Not a fav");
    }
  }

  //
  //
  //
  //
  //
  //
  //
  //
  // CATEGORY FAVS
  addToFavouriteCategories(CategoryModel category, String email) async {
    DocumentSnapshot doc =
        await favoriteCategoriesRef.document(currentUser.email).get();
    print(doc.data);
    print(doc.documentID);
    print(doc.exists);
    Timestamp timestamp = Timestamp.now();

    final documents = await favoriteCategoriesRef
        .document(email)
        .collection('favoriteRecipes')
        .getDocuments();

    // final recipeurl1 = recipe.recipeUrl.split("/recipe/")[1];
    // final recipeurll =
    //     recipeurl1.split("/")[0] + "-" + recipeurl1.split("/")[1];

    documents.documents.forEach((doc) {
      if (doc.documentID == category.title) {
        return;
      }
    });
// TODO crud delete - check if favourite
    await favoriteCategoriesRef
        .document(email)
        .collection('favs')
        // .document(recipeId)
        .document('${category.title}')
        .setData({
      "title": category.title,
      "categoryUrl": category.categoryUrl,
      "timestamp": timestamp,
    });
    notifyListeners();
  }

  fetchFavoriteCategories(email) async {
    List<CategoryModel> _favcatslist = [];
    QuerySnapshot recents = await favoriteCategoriesRef
        .document(email)
        .collection('favs')
        .orderBy(
          'timestamp',
          descending: true,
        )
        // .limit(10)
        .getDocuments();

    // recentslist = recents.documents;
    recents.documents.forEach((DocumentSnapshot doc) {
      print(doc);
      _favcatslist.add(CategoryModel.fromDocument(doc));
      // print(recentslist);
    });
    favouriteCategoriesList = _favcatslist;
    notifyListeners();
  }

  Future<bool> checkIfFavCategory(String category, String email) async {
    // final recipeurl1 = url.split("/recipe/")[1];
    // final recipeurll =
    //     recipeurl1.split("/")[0] + "-" + recipeurl1.split("/")[1];
    print(category+"*************************************************************************");
    DocumentSnapshot doc = await favoriteCategoriesRef
        .document(email)
        .collection('favs')
        .document(category)
        .get();

    if (doc.exists) {
      print("Is a fav cat checked");
      return true;
    }
    print("Is Not a fav cat Checked");
    return false;
  }

  removeFavCategory(String category, String email) async {
    bool isAlreadyFav = await checkIfFavCategory(category, email);

    // final recipeurl1 = url.split("/recipe/")[1];
    // final recipeurll =
    //     recipeurl1.split("/")[0] + "-" + recipeurl1.split("/")[1];

    if (isAlreadyFav) {
      await favoriteCategoriesRef
          .document(email)
          .collection('favs')
          .document(category)
          .delete();
      notifyListeners();
      print("Removed From Fav");
    } else {
      notifyListeners();
      print("Not a fav");
    }
  }

// TODO Reload Favourites page at every click
// TODO ZERO RECENTS START ADDING - MESSAGE
// TODO: Collapsing Home Search
// TODO: Search not adding more
}

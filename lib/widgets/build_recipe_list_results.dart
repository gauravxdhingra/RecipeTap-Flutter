import 'package:flutter/material.dart';
import 'package:recipetap/models/recipe_card.dart';
import 'package:recipetap/pages/recipe_view_page.dart';

class BuildRecipeListResults extends StatelessWidget {
  const BuildRecipeListResults({
    Key key,
    @required this.recipeCards,
  }) : super(key: key);

  final List<RecipeCard> recipeCards;

// TODO : Pagination Support

// /?page=3

  goToRecipe(url, coverImageUrl, context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeViewPage(
                  url: url,
                  coverImageUrl: coverImageUrl,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),
        itemCount: recipeCards.length,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () =>
              goToRecipe(recipeCards[i].href, recipeCards[i].photoUrl, context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: GridTile(
              child: Image.network(
                recipeCards[i].photoUrl,
                fit: BoxFit.cover,
              ),
              header: Container(
                child: Text(
                  recipeCards[i].title,
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
              footer: Container(
                child: Text(
                  recipeCards[i].desc,
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

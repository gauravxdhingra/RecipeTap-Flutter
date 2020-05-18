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
          childAspectRatio: 4 / 3,
          mainAxisSpacing: 20,
        ),
        physics: BouncingScrollPhysics(),
        itemCount: recipeCards.length,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () =>
              goToRecipe(recipeCards[i].href, recipeCards[i].photoUrl, context),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
            child: GridTile(
              child: Image.network(
                recipeCards[i].photoUrl,
                fit: BoxFit.cover,
              ),
              header: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Text(
                  recipeCards[i].title,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  overflow: TextOverflow.ellipsis,
                ),
                color: Colors.black54,
              ),
              footer: Container(
                padding: EdgeInsets.only(
                  left: 25,
                  top: 10,
                  bottom: 10,
                  right: 15,
                ),
                child: Text(
                  recipeCards[i].desc,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

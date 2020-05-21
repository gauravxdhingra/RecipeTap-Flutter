import 'package:flutter/material.dart';
import 'package:recipetap/interactive_recipe_pages/start_cooking_ingredients.dart';
import 'package:recipetap/models/recipe_model.dart';

class StartCooking extends StatelessWidget {
  const StartCooking({Key key, @required this.recipe}) : super(key: key);

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: Column(
        children: <Widget>[
          Image.network(
            recipe.coverPhotoUrl,
            fit: BoxFit.cover,
          ),

          // ROW
          // desc
          // serves
          // time
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StartCookingIngredients(
                        recipe: recipe,
                      )));
        },
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('I Am Ready'),
            Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }
}

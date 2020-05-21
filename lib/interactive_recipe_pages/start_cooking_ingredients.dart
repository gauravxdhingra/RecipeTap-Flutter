import 'package:flutter/material.dart';
import 'package:recipetap/interactive_recipe_pages/start_cooking_steps.dart';
import 'package:recipetap/models/recipe_model.dart';

class StartCookingIngredients extends StatefulWidget {
  StartCookingIngredients({Key key, this.recipe}) : super(key: key);

  final RecipeModel recipe;
  @override
  _StartCookingIngredientsState createState() =>
      _StartCookingIngredientsState();
}

class _StartCookingIngredientsState extends State<StartCookingIngredients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ingredients',
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text('Grab The Following Ingredients and Mark The Following'),
            Container(
              height: 400,
              child: ListView.builder(
                itemCount: widget.recipe.ingredients.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: Icon(
                      Icons.check_box_outline_blank,
                    ),
                    title: Text(
                      widget.recipe.ingredients[i],
                    ),
                    // TODO add Recipe Ingredinets Divide Acc TO Servings
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StartCookingSteps(
                        recipe: widget.recipe,
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

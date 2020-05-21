import 'package:flutter/material.dart';
import 'package:recipetap/interactive_recipe_pages/start_cooking_bon_appetit.dart';
import 'package:recipetap/models/recipe_model.dart';

class StartCookingSteps extends StatefulWidget {
  StartCookingSteps({Key key, this.recipe}) : super(key: key);

  final RecipeModel recipe;

  @override
  _StartCookingStepsState createState() => _StartCookingStepsState();
}

class _StartCookingStepsState extends State<StartCookingSteps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Text('Mark After Every Step'),
            Container(
              height: 450,
              child: ListView.builder(
                itemCount: widget.recipe.steps.length - 1,
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('# ${i + 1}'),
                    ),
                    title: Text(
                      widget.recipe.steps[i],
                    ),
                  );
                },
              ),
            ),
            if (widget.recipe.cooksNotes.isNotEmpty)
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: widget.recipe.cooksNotes.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('# ${i + 1}'),
                      ),
                      title: Text(
                        widget.recipe.cooksNotes[i],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        // TODO highlight current step and transparent next steps
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StartCookingBonAppetit(
                      // recipe: widget.recipe,
                      )));
        },
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Finish'),
            Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }
}

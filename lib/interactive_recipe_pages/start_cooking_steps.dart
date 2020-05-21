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
      appBar: AppBar(
        title: Text("Directions"),
      ),
      body: Container(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                child: Text(
                  'Mark After Every Step',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                        height: 1.4,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('# ${i + 1}'),
                      ),
                      title: Text(
                        widget.recipe.steps[i],
                      ),
                    ),
                  );
                },
                childCount: widget.recipe.steps.length - 1,
              ),
            ),
            if (widget.recipe.cooksNotes.isNotEmpty)
              SliverToBoxAdapter(
                child: Divider(),
              ),
            if (widget.recipe.cooksNotes.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text(
                    'Cook\'s Notes',
                    style: Theme.of(context).textTheme.headline3.copyWith(
                          height: 1.4,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (widget.recipe.cooksNotes.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ListTile(
                        title: Text(
                          widget.recipe.cooksNotes[i].toString().trim(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                  childCount: widget.recipe.cooksNotes.length,
                ),
              ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 70,
              ),
            )
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

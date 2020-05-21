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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> done = [];
  @override
  void initState() {
    widget.recipe.steps.forEach((element) {
      done.add(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                      onTap: () {
                        done[i] = !done[i];
                        setState(() {});
                      },
                      leading: CircleAvatar(
                        child: done[i]
                            ? Icon(
                                Icons.check,
                              )
                            : Text('# ${i + 1}'),
                      ),
                      title: Text(
                        widget.recipe.steps[i],
                        style: done[i]
                            ? TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              )
                            : TextStyle(
                                color: Colors.black,
                              ),
                      ),
                    ),
                  );
                },
                childCount: widget.recipe.steps.length - 1,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: RaisedButton(
                  child: Text("Mark All"),
                  onPressed: () {
                    for (int i = 0; i < done.length; i++) {
                      done[i] = true;
                    }
                    setState(() {});
                  },
                  color: Theme.of(context).primaryColor,
                ),
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
          for (int i = 0; i < done.length; i++) {
            if (done[i] == true) {
            } else {
              _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  duration: Duration(milliseconds: 700),
                  content: new Text("Finish All Steps To Proceed!")));
              return;
            }
          }

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

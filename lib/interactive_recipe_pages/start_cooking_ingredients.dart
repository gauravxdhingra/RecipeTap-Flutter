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
  List<bool> grabbed = [];
  bool next = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    int i = 0;
    widget.recipe.ingredients.forEach((element) {
      i++;
      grabbed.add(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Ingredients',
        ),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Text(
                'Grab The Following Ingredients and Mark Them In The List',
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
                return GestureDetector(
                  onTap: () {
                    grabbed[i] = !grabbed[i];
                    setState(() {});
                  },
                  child: ListTile(
                    leading: grabbed[i]
                        ? Icon(
                            Icons.check_box,
                          )
                        : Icon(
                            Icons.check_box_outline_blank,
                          ),
                    title: Text(widget.recipe.ingredients[i],
                        style: grabbed[i]
                            ? TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              )
                            : TextStyle(
                                color: Colors.black,
                              )),
                  ),
                );
              },
              childCount: widget.recipe.ingredients.length,
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
                  for (int i = 0; i < grabbed.length; i++) {
                    grabbed[i] = true;
                  }
                  setState(() {});
                },
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 70,
            ),
          ),
        ],
        // child: Container(
        //   child: Column(
        //     children: <Widget>[
        //       Container(
        //         height: 400,
        //         child: ListView.builder(
        //           itemCount: widget.recipe.ingredients.length,
        //           itemBuilder: (context, i) {
        //             return ListTile(
        //               leading: Icon(
        //                 Icons.check_box_outline_blank,
        //               ),
        //               title: Text(
        //                 widget.recipe.ingredients[i],
        //               ),
        //               // TODO add Recipe Ingredinets Divide Acc TO Servings
        //             );
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // grabbed.add(false);
          for (int i = 0; i < grabbed.length; i++) {
            if (grabbed[i] == true) {
            } else {
              _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  duration: Duration(milliseconds: 700),
                  content: new Text("Select All Items To Proceed!")));
              return;
            }
          }
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

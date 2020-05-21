import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:recipetap/interactive_recipe_pages/start_cooking_ingredients.dart';
import 'package:recipetap/models/recipe_model.dart';

class StartCooking extends StatelessWidget {
  const StartCooking({Key key, @required this.recipe}) : super(key: key);

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Container(
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Swiper(
                  // itemHeight: 100,
                  itemCount: recipe.coverPhotoUrl.length,
                  itemBuilder: (BuildContext context, int index) {
                    return
                        // Text(recipe.coverPhotoUrl[index]);
                        ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(45),
                      ),
                      child: Image.network(
                        recipe.coverPhotoUrl[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },

                  pagination: SwiperPagination(
                    builder: SwiperPagination.fraction,
                    alignment: Alignment.bottomCenter,
                  ),
                  fade: 0.7,
                  // outer: true,
                  physics: BouncingScrollPhysics(),
                  viewportFraction: 0.8,
                  scale: 0.85,
                  loop: false,
                ),

                // ClipRRect(
                //   borderRadius: BorderRadius.circular(20),
                //   child: Image.network(
                //     recipe.coverPhotoUrl,
                //     fit: BoxFit.cover,
                //   ),
                // ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (recipe.time.isNotEmpty || recipe.time.trim() != '--')
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 5,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.timer),
                          Text("Time"),
                          Text(recipe.time ?? ""),
                        ],
                      ),
                    ),
                  if (recipe.servings.isNotEmpty ||
                      recipe.servings.trim() != "--")
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 5,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.people_outline),
                          Text("Serves".toUpperCase()),
                          Text(recipe.servings ?? "--"),
                        ],
                      ),
                    ),
                  if (recipe.yeild.toString().isNotEmpty)
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 5,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.fastfood),
                          Text("YEILDS"),
                          Text(
                            recipe.yeild ?? "--",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                recipe.desc,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
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

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:readmore/readmore.dart';
import 'package:recipetap/models/recipe_model.dart';
import 'package:sliver_fab/sliver_fab.dart';

class RecipeViewPageWidget extends StatelessWidget {
  const RecipeViewPageWidget({
    Key key,
    @required this.headline,
    @required this.images,
    @required this.desc,
    @required this.timeExists,
    @required this.time,
    @required this.servingsExist,
    @required this.servings,
    @required this.nutritionalFactsExits,
    @required this.oldWebsite,
    @required this.nutritionalFacts,
    @required this.nutritionalFactsNew,
    @required this.yeildExists,
    @required this.yeild,
    @required this.ingredients,
    @required this.directions,
    @required this.cooksNotesExits,
    @required this.newWebsiteFooterNotesExist,
    @required this.cooksNotes,
    @required this.recipe,
  }) : super(key: key);

  final String headline;
  final List<String> images;
  final String desc;
  final bool timeExists;
  final String time;
  final bool servingsExist;
  final String servings;
  final bool nutritionalFactsExits;
  final bool oldWebsite;
  final List nutritionalFacts;
  final List nutritionalFactsNew;
  final bool yeildExists;
  final String yeild;
  final List ingredients;
  final List directions;
  final bool cooksNotesExits;
  final bool newWebsiteFooterNotesExist;
  final List cooksNotes;
  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SliverFab(
        floatingWidget: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 25,
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.favorite_border,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ),

        // TODO Adjust max resolution for loading Images
        floatingPosition:
            FloatingPosition(left: MediaQuery.of(context).size.width * 0.8),
        expandedHeight: MediaQuery.of(context).size.height / 3,
        slivers: <Widget>[
          SliverAppBar(
            // title: Text(headline),
            // elevation: 0.1,
            expandedHeight: MediaQuery.of(context).size.height / 3,

            pinned: true,
            // backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // floating: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black38,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 6,
                ),
                child: Text(
                  headline ?? "",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
              background: Container(
                height: 200,
                color: Colors.white,
                child: Swiper(
                  itemHeight: 200,
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(45),
                        bottomRight: Radius.circular(45),
                      ),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },

                  pagination: SwiperPagination(
                    builder: SwiperPagination.dots,
                    alignment: Alignment.topCenter,
                  ),

                  // control: new SwiperControl(
                  //   iconNext: null,
                  //   iconPrevious: null,
                  // ),
                  physics: BouncingScrollPhysics(),
                  // layout: SwiperLayout.DEFAULT,
                  // viewportFraction: 0.8,
                  // scale: 0.9,
                  itemWidth: 300.0,
                  loop: false,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                child: ReadMoreText(
                  desc,
                  trimLines: 2,
                  colorClickableText: Colors.grey,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '  Show more',
                  trimExpandedText: '  Show less',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 85,
              child: Center(
                child: Row(
                  // TODO add faeture for ingredients servings division
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (timeExists)
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 5,
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.timer),
                            Text("Time"),
                            Text(time ?? ""),
                          ],
                        ),
                      ),
                    if (servingsExist)
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 5,
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.people_outline),
                            Text("Serves".toUpperCase()),
                            Text(servings ?? "--"),
                          ],
                        ),
                      ),
                    if (nutritionalFactsExits)
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 5,
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.restaurant_menu),
                            Text("Calories".toUpperCase()),
                            Text(
                              nutritionalFactsExits
                                  ? oldWebsite
                                      ? nutritionalFacts[0]
                                      : nutritionalFactsNew[0]
                                  : "--" ?? "--",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    if (yeildExists && oldWebsite == true)
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 5,
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.fastfood),
                            Text("YEILDS"),
                            Text(
                              yeildExists
                                  ? oldWebsite ? yeild ?? "--" : "--"
                                  : "--" ?? "--",
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
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                // vertical: 25,
              ),
              child: Text(
                'INGREDIENTS',
                style: Theme.of(context).textTheme.headline3.copyWith(),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    // vertical: 25,
                  ),
                  child: ListTile(
                    title: Text(ingredients[index]),
                  ),
                );
              },
              childCount:
                  oldWebsite ? ingredients.length : ingredients.length - 2,
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(),
          ),

          // TODO HANDLE HEADING IN SLIVER
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              child: Text(
                'DIRECTIONS',
                style: Theme.of(context).textTheme.headline3.copyWith(),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('# ${index + 1}'),
                    ),
                    title: Text(directions[index] ?? ""),
                  ),
                );
                // Text(directions[index]);
              },
              childCount: directions.length - 1,
            ),
          ),
          if (nutritionalFactsExits)
            SliverToBoxAdapter(
              child: Divider(),
            ),
          if (nutritionalFactsExits)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                ),
                child: Text(
                  'NUTRITIONAL FACTS',
                  style: Theme.of(context).textTheme.headline3.copyWith(),
                ),
              ),
            ),
          if (nutritionalFactsExits)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                oldWebsite
                    ? (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: ListTile(
                            title: Text(
                                nutritionalFacts[index].toString().trimRight()),
                          ),
                        );
                      }
                    : (BuildContext context, int index) {
                        return ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                                nutritionalFactsNew[index].toString().trim()),
                          ),
                        );
                      },
                childCount: oldWebsite
                    ? nutritionalFacts.length - 1
                    : nutritionalFactsNew.length,
              ),
            ),
          if ((oldWebsite && cooksNotesExits) || newWebsiteFooterNotesExist)
            SliverToBoxAdapter(
              child: Divider(),
            ),
          if ((oldWebsite && cooksNotesExits) || newWebsiteFooterNotesExist)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                ),
                child: Text(
                  "COOK'S NOTES",
                  style: Theme.of(context).textTheme.headline3.copyWith(),
                ),
              ),
            ),
          if ((oldWebsite && cooksNotesExits) || newWebsiteFooterNotesExist)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                oldWebsite
                    ? (BuildContext context, int index) {
                        // print(cooksNotes.length);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: ListTile(
                            title: Text(cooksNotes[index].toString()
                                // .substring(20)
                                // .trim()
                                ??
                                ""),
                          ),
                        );
                      }
                    : (BuildContext context, int index) {
                        // print(cooksNotes[0].length);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: ListTile(
                            title: Text(cooksNotes[0][index].trim()),
                          ),
                        );
                        // Text(cooksNotes[0][index].trim());
                      },
                childCount:
                    oldWebsite ? cooksNotes.length : cooksNotes[0].length,
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/recipeview.jpg',
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                      ),
                      child: Align(
                        child: Text(
                          'Bon Appetit!',
                          style: Theme.of(context).textTheme.headline3.copyWith(
                                fontSize: 25,
                              ),
                        ),
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: 60,
                    color: Color(0xfff4d6cd),
                    child: Center(
                      child: Text('Save The Recipe As PDF'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 70,
            ),
          ),
          // SliverFillRemaining(
          //   child: Column(
          //     children: <Widget>[
          //       // extra cooks notes
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

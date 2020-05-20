import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:readmore/readmore.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SliverFab(
        floatingWidget: CircleAvatar(
          child: IconButton(
            icon: Icon(
              Icons.favorite_border,
              // size: 50,
            ),
            onPressed: () {},
          ),
        ),

        // TODO Adjust max resolution for loading Images
        floatingPosition:
            FloatingPosition(left: MediaQuery.of(context).size.width * 0.7),
        expandedHeight: MediaQuery.of(context).size.height / 3,
        slivers: <Widget>[
          SliverAppBar(
            // title: Text(headline),
            // elevation: 0.1,
            expandedHeight: MediaQuery.of(context).size.height / 3,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black54,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 6,
                ),
                child: Text(
                  headline ?? "",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  // textAlign: TextAlign.right,
                ),
              ),
              background: Container(
                height: 200,
                child: Swiper(
                  itemHeight: 200,
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: new Image.network(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  pagination: new SwiperPagination(),
                  control: new SwiperControl(
                    iconNext: null,
                    iconPrevious: null,
                  ),
                  physics: BouncingScrollPhysics(),
                  // layout: SwiperLayout.TINDER,
                  viewportFraction: 0.8,
                  scale: 0.9,
                  itemWidth: 300.0,
                  loop: false,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ReadMoreText(
              desc,
              trimLines: 2,
              colorClickableText: Colors.grey,
              trimMode: TrimMode.Line,
              trimCollapsedText: '  Show more',
              trimExpandedText: '  Show less',
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (timeExists)
                    Container(
                      height: 70,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.timer),
                          Text(time ?? ""),
                        ],
                      ),
                    ),
                  if (servingsExist)
                    Container(
                      height: 70,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.people_outline),
                          Text(servings ?? "--"),
                        ],
                      ),
                    ),
                  if (nutritionalFactsExits)
                    Container(
                      height: 70,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.restaurant_menu),
                          Text(nutritionalFactsExits
                              ? oldWebsite
                                  ? nutritionalFacts[0]
                                  : nutritionalFactsNew[0]
                              : "--" ?? "--"),
                        ],
                      ),
                    ),
                  if (yeildExists && oldWebsite == true)
                    Container(
                      height: 70,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.fastfood),
                          Text(
                            yeildExists
                                ? oldWebsite ? yeild ?? "--" : "--"
                                : "--" ?? "--",
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Text('INGREDIENTS'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text(ingredients[index]),
                );
              },
              childCount:
                  oldWebsite ? ingredients.length : ingredients.length - 2,
            ),
          ),
          SliverToBoxAdapter(
            child: Text('DIRECTIONS'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('# ${index + 1}'),
                  ),
                  title: Text(directions[index] ?? ""),
                );
                // Text(directions[index]);
              },
              childCount: directions.length - 1,
            ),
          ),
          if (nutritionalFactsExits)
            SliverToBoxAdapter(
              child: Text('NUTRITIONAL FACTS'),
            ),
          if (nutritionalFactsExits)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                oldWebsite
                    ? (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                              nutritionalFacts[index].toString().trimRight()),
                        );
                      }
                    : (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                              nutritionalFactsNew[index].toString().trim()),
                        );
                      },
                childCount: oldWebsite
                    ? nutritionalFacts.length - 1
                    : nutritionalFactsNew.length,
              ),
            ),
          if ((oldWebsite && cooksNotesExits) || newWebsiteFooterNotesExist)
            SliverToBoxAdapter(
              child: Text('NUTRITIONAL FACTS'),
            ),
          if ((oldWebsite && cooksNotesExits) || newWebsiteFooterNotesExist)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                oldWebsite
                    ? (BuildContext context, int index) {
                        // print(cooksNotes.length);
                        return ListTile(
                          title: Text(cooksNotes[index]
                                  .toString()
                                  .substring(20)
                                  .trim() ??
                              ""),
                        );
                      }
                    : (BuildContext context, int index) {
                        // print(cooksNotes[0].length);
                        return ListTile(
                          title: Text(cooksNotes[0][index].trim()),
                        );
                        // Text(cooksNotes[0][index].trim());
                      },
                childCount:
                    oldWebsite ? cooksNotes.length : cooksNotes[0].length,
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

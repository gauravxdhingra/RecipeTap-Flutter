import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:readmore/readmore.dart';

class RecipeViewPage extends StatefulWidget {
  final String url;
  final String coverImageUrl;
  RecipeViewPage({Key key, this.url, this.coverImageUrl}) : super(key: key);
  static const routeName = 'recipe_view_page';
  @override
  _RecipeViewPageState createState() => _RecipeViewPageState();
}

class _RecipeViewPageState extends State<RecipeViewPage> {
  bool isLoading = true;

  // TODO handle empty image
  // TODO solve-if image rail is empty
  // TODO: Validate time and Servings mixing prevent
  // TODO: all getData functions in try and catch
  // TODO: Solve no image bug
  // https://images.media-allrecipes.com/images/82579.png

  // final String url =
  //     widget.url;
  // "https://www.allrecipes.com/recipe/262499/tandoori-paneer-tikka-masala/?internalSource=hub%20recipe&referringContentType=Search&clickId=cardslot%201";
  // "https://www.allrecipes.com/recipe/129000/caribbean-nachos/?internalSource=staff%20pick&referringId=1228&referringContentType=Recipe%20Hub&clickId=cardslot%201#nutrition";
  // "https://www.allrecipes.com/recipe/127491/easy-oreo-truffles/?internalSource=hub%20recipe&referringContentType=Search&clickId=cardslot%202";
  // "https://www.allrecipes.com/recipe/228899/palak-paneer/?internalSource=hub%20recipe&referringContentType=Search&clickId=cardslot%201";
  // "https://www.allrecipes.com/recipe/259199/grilled-tandoori-lamb/?internalSource=user%20pref&referringContentType=Homepage&clickId=cardslot%209";

  bool oldWebsite;

  String headline;
  String desc;
  String time;
  String servings;
  String yeild;
  List<String> images = [];
  List ingredients = [];
  List directions = [];
  List nutritionalFacts = [];
  List nutritionalFactsNew = [];
  List cooksNotes = [];

  bool nutritionalFactsExits = false;
  bool cooksNotesExits = false;
  bool yeildExists = false;
  bool timeExists = false;
  bool servingsExist = false;
  bool newWebsiteFooterNotesExist = false;

  getData() async {
    final String url = widget.url;
    final String coverImageUrl = widget.coverImageUrl;
    // images.add(coverImageUrl);
    // .replaceAll("/300x300", "");
    final response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    print(url);
    try {
      document.getElementsByClassName("magazine-bar__social")[0].text;
      oldWebsite = false;
      print('new website');
    } catch (e) {
      print('old website');
      oldWebsite = true;
    }

    if (oldWebsite) {
      headline =
          document.getElementsByClassName("headline heading-content")[3].text;
// margin-0-auto

      // var coverimg = document
      //     .getElementsByClassName(
      //         "icon icon-pinterest-circle-solid social-icon pinterest-transparent")[0]
      //     .querySelector("a")
      //     .attributes["href"]
      //     .toString()
      //     .split("%3Furl%3D")[1]
      //     .split("&descri")[0]
      //     .replaceAll("%253A", ":")
      //     .replaceAll("%252F", "/")
      //     .replaceAll("%3A", ":")
      //     .replaceAll("%2F", "/");

      // // .querySelector("img")
      // // .attributes["src"];
      // print(coverImageUrl);
      // images.add(coverimg);
      // images.add(coverImageUrl);

      final srcfirstSplit = coverImageUrl.split("photos/")[0];
      final srcsecondsplit = coverImageUrl.split("photos/")[1].split("/")[1];
      final srcc = srcfirstSplit + "photos/" + srcsecondsplit;
      print(srcc);
      images.add(srcc);

      var otherImagesRef = document.getElementsByClassName("ugc-photos-link");
      int count = 0;
      otherImagesRef.forEach((element) {
        count++;
        if (count > 2) {
          final newElement = element
              // .querySelector("a")
              // .querySelector("div")
              .attributes["data-cms-id"];
          if ("https://images.media-allrecipes.com/userphotos/" +
                  newElement +
                  ".jpg" !=
              coverImageUrl) {
            if (!images.contains(
                "https://images.media-allrecipes.com/userphotos/" +
                    newElement +
                    ".jpg")) {
              images.add(
                "https://images.media-allrecipes.com/userphotos/" +
                    newElement +
                    ".jpg",
              );
            }
          }
        }
      });
      print(images);
      // 0 prep
      // 1 cook
      // 2 total
      // 3 servings
      // 4. Servings

      final infoBoxes = document
          .getElementsByClassName(
              "recipe-meta-container two-subcol-content clearfix")[0]
          .getElementsByClassName("recipe-meta-item");

      try {
        int counttt = 0;
        infoBoxes.forEach((element) {
          counttt++;
          if (element
              .getElementsByClassName("recipe-meta-item-header")[counttt]
              .text
              .trim()
              .contains("total")) {
            time = element
                .getElementsByClassName("recipe-meta-item-body")[counttt]
                .text
                .trim();
            timeExists = true;
          }
        });
      } catch (e) {
        time = "--";
        timeExists = false;
      }

      try {
        int counttt = 0;
        infoBoxes.forEach((element) {
          if (element
              .getElementsByClassName("recipe-meta-item-header")[counttt]
              .text
              .trim()
              .contains("erving")) {
            servings = element
                .getElementsByClassName("recipe-meta-item-body")[counttt]
                .text
                .trim();
            servingsExist = true;
          }
        });
      } catch (e) {
        servings = "--";
        servingsExist = false;
      }

      try {
        infoBoxes.forEach((element) {
          int counttt = 0;
          if (element
              .getElementsByClassName("recipe-meta-item-header")[counttt]
              .text
              .trim()
              .contains("ield")) {
            yeild = element
                .getElementsByClassName("recipe-meta-item-body")[counttt]
                .text
                .trim();
            yeildExists = true;
          }
        });
      } catch (e) {
        yeild = "--";
        yeildExists = false;
      }

      // time = document
      //     .getElementsByClassName("recipe-meta-item-body")[2]
      //     .text
      //     .trim();
      // servings = document
      //     .getElementsByClassName("recipe-meta-item-body")[3]
      //     .text
      //     .trim();

      desc = document.getElementsByClassName("margin-0-auto")[0].text.trim();

      document
          .getElementsByClassName("ingredients-item-name")
          .forEach((element) {
        final iingred = element.text.trim();
        ingredients.add(iingred);
      });

      document.getElementsByClassName("section-body").forEach((element) {
        final istep = element.text.trim();
        directions.add(istep);
      });
      // section-body
      // subcontainer instructions-section-item

      nutritionalFactsExits = document
          .getElementsByClassName("partial recipe-nutrition-section")
          .isNotEmpty;

      if (nutritionalFactsExits) {
        String nutritionText = directions[directions.length - 1];
        List<String> roughNutri = nutritionText.split("  ");
        roughNutri.forEach((element) {
          if (element != '')
            nutritionalFacts.add(
              element.trim().replaceAll(";", "").replaceAll(".", ""),
            );
        });
      }

      // nutritionalFacts = roughNutri;
      final selector = document.getElementsByClassName("recipe-note container");
      cooksNotesExits = selector.isNotEmpty;
      if (selector.isNotEmpty)
        selector.forEach((element) {
          final inote = element.text.trim();
          if (inote != '' && inote != "Cook's Notes:") cooksNotes.add(inote);
        });

      cooksNotes.forEach((element) {
        if (element.toString().contains("Reynold")) {
          cooksNotesExits = false;
        }
        if (element.toString().contains("Partner")) {
          cooksNotesExits = false;
        }
      });
      //
      //
      //
      //
//
    } else {
      headline = document.getElementsByClassName("recipe-summary__h1")[0].text;
// margin-0-auto

      final imagerow = document
          .getElementsByClassName("photo-strip__items")[0]
          .querySelectorAll("li");
      // [0]
      // .querySelector("a")
      // .querySelector("img");

      final srcfirstSplit = coverImageUrl.split("photos/")[0];
      final srcsecondsplit = coverImageUrl.split("photos/")[1].split("/")[1];
      final srcc = srcfirstSplit + "photos/" + srcsecondsplit;
      // print(srcc);
      images.add(srcc);

      imagerow.forEach((element) {
        if (element.querySelector("a").attributes["href"] != "#" ||
            element.querySelector("a") == null) {
          final src =
              element.querySelector("a").querySelector("img").attributes["src"];
          final srcfirstSplit = src.split("photos/")[0];
          final srcsecondsplit = src.split("photos/")[1].split("/")[1];
          final srcc = srcfirstSplit + "photos/" + srcsecondsplit;
          print(srcc);
          if (!images.contains(srcc)) {
            images.add(srcc);
          }
          // images.add(srcc);
        }
      });

      // print(imagerow.attributes["src"]);
      try {
        time = document.getElementsByClassName("ready-in-time")[0].text.trim();
        timeExists = true;
      } catch (e) {
        timeExists = false;
      }
      // final servingss = document
      //     .getElementsByClassName("recipe-ingredients ng-scope");

      try {
        final servingss = document
            .querySelector('[ng-controller="ar_controllers_recipe_ingredient"]')
            .attributes["ng-init"]
            .split("(")[1]
            .split(",")[0];
        servings = servingss;
        servingsExist = true;
        print(servingss);
      } catch (e) {
        servingsExist = false;
      }

      desc = document
          .getElementsByClassName("submitter__description")[0]
          .text
          .trim();

      document
          .getElementsByClassName("recipe-ingred_txt added")
          .forEach((element) {
        final iingred = element.text.trim();
        ingredients.add(iingred);
      });

      int countt = 0;
      if (countt <
          document
                  .getElementsByClassName("recipe-directions__list--item")
                  .length -
              1) {
        countt++;
        document
            .getElementsByClassName("recipe-directions__list--item")
            .forEach((element) {
          final istep = element.text.trim().replaceAll("Watch Now", "");
          directions.add(istep);
          print(istep);
        });
      }
      // section-body
      // subcontainer instructions-section-item

      nutritionalFactsExits =
          document.getElementsByClassName("nutrition-summary-facts").isNotEmpty;

      if (nutritionalFactsExits) {
        document.getElementsByClassName("nutrition-summary-facts");
        // print(nutritionalFactsNew[0]);
        // 1. calories
        // 2. Fat
        // 3. Carbohydrates
        // 4. Protien
        // 5. Cholestrol
        // 6. Sodium

        nutritionalFactsNew.add(document
            .querySelector('[itemprop="calories"]')
            .text
            .replaceAll(";", ""));
        nutritionalFactsNew.add(
            document.querySelector('[itemprop="fatContent"]').text + "g fat");
        nutritionalFactsNew.add(
            document.querySelector('[itemprop="carbohydrateContent"]').text +
                "g carbohydrates");
        nutritionalFactsNew.add(
            document.querySelector('[itemprop="proteinContent"]').text +
                "g protein");
        nutritionalFactsNew.add(
            document.querySelector('[itemprop="cholesterolContent"]').text +
                "mg cholestrol");
        nutritionalFactsNew.add(
            document.querySelector('[itemprop="sodiumContent"]').text +
                "mg sodium");
      }

      // Footer notes
      try {
        final selector =
            document.getElementsByClassName("recipe-footnotes__h4");
        // recipe-footnotes__header

        if (selector[0].hasContent()) {
          cooksNotesExits = selector[0].text.trim() == "Footnotes";
          if (selector.isNotEmpty) {
            document
                .getElementsByClassName("recipe-footnotes")
                .forEach((element) {
              final inote = element.text.trim();
              if (inote != '' || inote != "Footnotes") {
                cooksNotes.add(inote.trim());
                // cooksNotes = cooksNotes[0].toString().split("  ");
              }
            });
            cooksNotes[0] = cooksNotes[0]
                .toString()
                .substring(10)
                .trim()
                .split("                ");
            print('ckn' + cooksNotes[0].length.toString());
            if (cooksNotes[0].toString().contains("Reynold")) {
              cooksNotesExits = false;
            }
            if (cooksNotes[0].toString().contains("Partner")) {
              cooksNotesExits = false;
            }
            if (cooksNotes[0].toString().contains("Facts")) {
              cooksNotesExits = false;
            }
          }
        }
        newWebsiteFooterNotesExist = true;
        if (cooksNotes[0].toString().contains("Facts")) {
          newWebsiteFooterNotesExist = false;
        }
        if (cooksNotes[0].toString().contains("Partner")) {
          newWebsiteFooterNotesExist = false;
        }
        if (cooksNotes[0].toString().contains("Facts")) {
          newWebsiteFooterNotesExist = false;
        }
      } catch (err) {
        newWebsiteFooterNotesExist = false;
      }
    }
    setState(() {
      print(headline);
      print(ingredients[0]);
      isLoading = false;
      if (time == null) timeExists = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(cooksNotes);
    // getData();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => getData(),
      ),
      // appBar: AppBar(
      //   title: isLoading ? Text('') : Text(headline),
      // ),
      body: isLoading
          ? CircularProgressIndicator()
          : SafeArea(
              child: CustomScrollView(slivers: <Widget>[
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
                SliverFillRemaining(
                  child: Column(
                    children: <Widget>[
                      ReadMoreText(
                        desc,
                        trimLines: 2,
                        colorClickableText: Colors.pink,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '  Show more...',
                        trimExpandedText: '  Show less',
                      ),

                      Divider(),

                      Container(
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

                      Divider(),

                      Text('INGREDIENTS'),

                      // Ingredients
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: oldWebsite
                              ? ingredients.length
                              : ingredients.length - 2,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(ingredients[index]),
                            );
                          },
                        ),
                      ),
                      // directons/steps

                      Text('DIRECTIONS'),

                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: directions.length - 1,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text('# ${index + 1}'),
                              ),
                              title: Text(directions[index] ?? ""),
                            );

                            // Text(directions[index]);
                          },
                        ),
                      ),

                      // nutritional facts
                      if (nutritionalFactsExits)
                        Text('NUTRITIONAL FACTS'),

                      if (nutritionalFactsExits)
                        Container(
                          height: 100,
                          // child: Text(directions[directions.length - 1]),
                          child: oldWebsite
                              ? ListView.builder(
                                  itemCount: nutritionalFacts.length - 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // print(nutritionalFacts[index]
                                    //     .toString()
                                    //     .trimRight());

                                    return ListTile(
                                      title: Text(nutritionalFacts[index]
                                          .toString()
                                          .trimRight()),
                                    );
                                    // return Text(nutritionalFacts[index]
                                    //     .toString()
                                    //     .trimRight());
                                  },
                                )
                              : ListView.builder(
                                  itemCount: nutritionalFactsNew.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // print(nutritionalFactsNew[index]
                                    //     .toString()
                                    //     .trim());
                                    return ListTile(
                                      title: Text(nutritionalFactsNew[index]
                                          .toString()
                                          .trim()),
                                    );
                                    // Text(nutritionalFactsNew[index]
                                    //     .toString()
                                    //     .trim());
                                  },
                                ),
                        ),

                      // extra cooks notes
                      if ((oldWebsite && cooksNotesExits) ||
                          newWebsiteFooterNotesExist)
                        Text("COOK'S NOTES"),

                      if ((oldWebsite && cooksNotesExits) ||
                          newWebsiteFooterNotesExist)
                        // Container(
                        //   child:
                        //       Text(cooksNotes[0].toString().substring(20).trim()),
                        // ),
                        Container(
                          height: 100,
                          child: oldWebsite
                              ? ListView.builder(
                                  itemCount: cooksNotes.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // print(cooksNotes.length);
                                    return ListTile(
                                      title: Text(cooksNotes[index]
                                              .toString()
                                              .substring(20)
                                              .trim() ??
                                          ""),
                                    );
                                    // return Text(cooksNotes[index]
                                    //     .toString()
                                    //     .substring(20)
                                    //     .trim());
                                  })
                              : ListView.builder(
                                  itemCount: cooksNotes[0].length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // print(cooksNotes[0].length);
                                    return ListTile(
                                      title: Text(cooksNotes[0][index].trim()),
                                    );
                                    // Text(cooksNotes[0][index].trim());
                                  }),
                        ),
                    ],
                  ),
                ),
              ]

//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
// // TODO: Carousel
//                     // if (images != null)
//                     // Image.network(images[0])
//                     // Container(
//                     //   height: 300,
//                     //   child: Swiper(
//                     //     itemCount: images.length,
//                     //     itemBuilder: (BuildContext context, int index) {
//                     //       return ClipRRect(
//                     //         borderRadius: BorderRadius.circular(15),
//                     //         child: new Image.network(
//                     //           images[index],
//                     //           fit: BoxFit.cover,
//                     //         ),
//                     //       );
//                     //     },
//                     //     pagination: new SwiperPagination(),
//                     //     control: new SwiperControl(
//                     //       iconNext: null,
//                     //       iconPrevious: null,
//                     //     ),
//                     //     physics: BouncingScrollPhysics(),
//                     //     // layout: SwiperLayout.TINDER,
//                     //     viewportFraction: 0.8,
//                     //     scale: 0.9,
//                     //     itemWidth: 300.0,
//                     //     loop: false,
//                     //   ),
//                     // ),
//                     // else
//                     //   Text("No Image"),

//                     // Text('ABOUT'),
//                     // Description
//                     // Text(desc),
//                     ReadMoreText(
//                       desc,
//                       trimLines: 2,
//                       colorClickableText: Colors.pink,
//                       trimMode: TrimMode.Line,
//                       trimCollapsedText: '  Show more...',
//                       trimExpandedText: '  Show less',
//                     ),

//                     Divider(),

//                     Container(
//                       height: 70,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           if (timeExists)
//                             Container(
//                               height: 70,
//                               child: Column(
//                                 children: <Widget>[
//                                   Icon(Icons.timer),
//                                   Text(time ?? ""),
//                                 ],
//                               ),
//                             ),
//                           if (servingsExist)
//                             Container(
//                               height: 70,
//                               child: Column(
//                                 children: <Widget>[
//                                   Icon(Icons.people_outline),
//                                   Text(servings ?? "--"),
//                                 ],
//                               ),
//                             ),
//                           if (nutritionalFactsExits)
//                             Container(
//                               height: 70,
//                               child: Column(
//                                 children: <Widget>[
//                                   Icon(Icons.restaurant_menu),
//                                   Text(nutritionalFactsExits
//                                       ? oldWebsite
//                                           ? nutritionalFacts[0]
//                                           : nutritionalFactsNew[0]
//                                       : "--" ?? "--"),
//                                 ],
//                               ),
//                             ),
//                           if (yeildExists && oldWebsite == true)
//                             Container(
//                               height: 70,
//                               child: Column(
//                                 children: <Widget>[
//                                   Icon(Icons.fastfood),
//                                   Text(
//                                     yeildExists
//                                         ? oldWebsite ? yeild ?? "--" : "--"
//                                         : "--" ?? "--",
//                                   ),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),

//                     Divider(),

//                     Text('INGREDIENTS'),

//                     // Ingredients
//                     Container(
//                       height: 200,
//                       child: ListView.builder(
//                         itemCount: oldWebsite
//                             ? ingredients.length
//                             : ingredients.length - 2,
//                         itemBuilder: (BuildContext context, int index) {
//                           return ListTile(
//                             title: Text(ingredients[index]),
//                           );
//                         },
//                       ),
//                     ),
//                     // directons/steps

//                     Text('DIRECTIONS'),

//                     Container(
//                       height: 200,
//                       child: ListView.builder(
//                         itemCount: directions.length - 1,
//                         itemBuilder: (BuildContext context, int index) {
//                           return ListTile(
//                             leading: CircleAvatar(
//                               child: Text('# ${index + 1}'),
//                             ),
//                             title: Text(directions[index] ?? ""),
//                           );

//                           // Text(directions[index]);
//                         },
//                       ),
//                     ),

//                     // nutritional facts
//                     if (nutritionalFactsExits)
//                       Text('NUTRITIONAL FACTS'),

//                     if (nutritionalFactsExits)
//                       Container(
//                         height: 100,
//                         // child: Text(directions[directions.length - 1]),
//                         child: oldWebsite
//                             ? ListView.builder(
//                                 itemCount: nutritionalFacts.length - 1,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   // print(nutritionalFacts[index]
//                                   //     .toString()
//                                   //     .trimRight());

//                                   return ListTile(
//                                     title: Text(nutritionalFacts[index]
//                                         .toString()
//                                         .trimRight()),
//                                   );
//                                   // return Text(nutritionalFacts[index]
//                                   //     .toString()
//                                   //     .trimRight());
//                                 },
//                               )
//                             : ListView.builder(
//                                 itemCount: nutritionalFactsNew.length,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   // print(nutritionalFactsNew[index]
//                                   //     .toString()
//                                   //     .trim());
//                                   return ListTile(
//                                     title: Text(nutritionalFactsNew[index]
//                                         .toString()
//                                         .trim()),
//                                   );
//                                   // Text(nutritionalFactsNew[index]
//                                   //     .toString()
//                                   //     .trim());
//                                 },
//                               ),
//                       ),

//                     // extra cooks notes
//                     if ((oldWebsite && cooksNotesExits) ||
//                         newWebsiteFooterNotesExist)
//                       Text("COOK'S NOTES"),

//                     if ((oldWebsite && cooksNotesExits) ||
//                         newWebsiteFooterNotesExist)
//                       // Container(
//                       //   child:
//                       //       Text(cooksNotes[0].toString().substring(20).trim()),
//                       // ),
//                       Container(
//                         height: 100,
//                         child: oldWebsite
//                             ? ListView.builder(
//                                 itemCount: cooksNotes.length,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   // print(cooksNotes.length);
//                                   return ListTile(
//                                     title: Text(cooksNotes[index]
//                                             .toString()
//                                             .substring(20)
//                                             .trim() ??
//                                         ""),
//                                   );
//                                   // return Text(cooksNotes[index]
//                                   //     .toString()
//                                   //     .substring(20)
//                                   //     .trim());
//                                 })
//                             : ListView.builder(
//                                 itemCount: cooksNotes[0].length,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   // print(cooksNotes[0].length);
//                                   return ListTile(
//                                     title: Text(cooksNotes[0][index].trim()),
//                                   );
//                                   // Text(cooksNotes[0][index].trim());
//                                 }),
//                       ),
//                   ],
//                 ),
                  ),
            ),
    );
  }
}

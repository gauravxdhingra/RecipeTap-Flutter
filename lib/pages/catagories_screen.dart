import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:recipetap/jump_screens/loading_categories_screen.dart';
import 'package:recipetap/jump_screens/retry_screen.dart';
import 'package:recipetap/provider/recently_viewed_provider.dart';
import 'package:recipetap/widgets/all_categories_scroll.dart';

// import 'categories_recipe_screen.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({Key key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
// with AutomaticKeepAliveClientMixin<CategoriesScreen>
{
  // bool isLoading = true;
  bool isLoading = false;

  List categories = [];
  bool showRetry = false;
  Map<String, Map<String, Map<String, String>>> categoriesMap = {};

  @override
  void initState() {
    // getData();s
    super.initState();
  }

  // getData() async {
  //   try {
  //     final String url = "https://www.allrecipes.com/recipes/";
  //     final response = await http.get(url);
  //     dom.Document document = parser.parse(response.body);

  //     document.getElementsByClassName("heading__h3").forEach((element) {
  //       categories.add(element.text);
  //       print(element.text);
  //     });
  //     int count = 0;
  //     document.querySelectorAll("section").forEach((element) {
  //       count++;
  //       if (count > 5 && count < 14) {
  //         final category = element.querySelector("h3");

  //         categoriesMap[category.text] = {};

  //         print(element.querySelector("div").attributes["style"]);
  //         int i = 1;
  //         final categoryImageUrl = element
  //             .querySelector("div")
  //             .attributes["style"]
  //             .split("(")[i]
  //             .split("\"")[0];

  //         categoriesMap[category.text]
  //             ["imageUrl"] = {"imageUrl": categoryImageUrl};
  //         categoriesMap[category.text]["categories"] = {};
  //         element.querySelector("ul").querySelectorAll("li").forEach((element) {
  //           final text = element.querySelector("a").text;
  //           final link = element.querySelector("a").attributes["href"];

  //           categoriesMap[category.text]["categories"]
  //               .putIfAbsent(text, () => link);
  //         });
  //       }
  //     });

  //     setState(() {
  //       isLoading = false;
  //     });

  //     print(categoriesMap);
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       showRetry = true;
  //     });
  //   }
  // }

  // bool get wantKeepAlive => true;

  // sendToFirebase() async {
  //   await recentsRef
  //       .document('map')
  //       .collection('recents')
  //       // .document(recipeId)
  //       .document('categorymap')
  //       .setData({
  //     "map": categoriesMap.toString(),
  //   });
  // }

  final categoriesMapLocal = {
    "Meal Type": {
      'imageUrl': {
        'imageUrl': 'https://images.media-allrecipes.com/images/77855.jpg'
      },
      'categories': {
        'Breakfast and Brunch':
            'https://www.allrecipes.com/recipes/78/breakfast-and-brunch/',
        'Desserts': 'https://www.allrecipes.com/recipes/79/desserts/',
        'Dinners': 'https://www.allrecipes.com/recipes/17562/dinner/',
        'Lunch': 'https://www.allrecipes.com/recipes/17561/lunch/'
      }
    },
    'Ingredient': {
      'imageUrl': {
        'imageUrl': 'https://images.media-allrecipes.com/images/77854.jpg'
      },
      'categories': {
        'Beef': 'https://www.allrecipes.com/recipes/200/meat-and-poultry/beef/',
        'Beans and Legumes':
            'https://www.allrecipes.com/recipes/16930/fruits-and-vegetables/beans-and-peas/',
        'Chicken Recipes':
            'https://www.allrecipes.com/recipes/201/meat-and-poultry/chicken/',
        'Chocolate':
            'https://www.allrecipes.com/recipes/17822/ingredients/chocolate/',
        'Fruit':
            'https://www.allrecipes.com/recipes/1058/fruits-and-vegetables/fruits/',
        'Game Meats':
            'https://www.allrecipes.com/recipes/202/meat-and-poultry/game-meats/',
        'Grains':
            'https://www.allrecipes.com/recipes/13329/ingredients/whole-grains/',
        'Mushrooms':
            'https://www.allrecipes.com/recipes/15172/fruits-and-vegetables/mushrooms/',
        'Pasta': 'https://www.allrecipes.com/recipes/95/pasta-and-noodles/',
        'Pork Recipes':
            'https://www.allrecipes.com/recipes/205/meat-and-poultry/pork/',
        'Potatoes':
            'https://www.allrecipes.com/recipes/1540/fruits-and-vegetables/vegetables/potatoes',
        'Poultry': 'https://www.allrecipes.com/recipes/92/meat-and-poultry/',
        'Rice': 'https://www.allrecipes.com/recipes/224/side-dish/rice/',
        'Salmon': 'https://www.allrecipes.com/recipes/416/seafood/fish/salmon/',
        'Seafood': 'https://www.allrecipes.com/recipes/93/seafood/',
        'Shrimp':
            'https://www.allrecipes.com/recipes/430/seafood/shellfish/shrimp/',
        'Tofu and Tempeh':
            'https://www.allrecipes.com/recipes/16778/everyday-cooking/vegetarian/protein/',
        'Turkey':
            'https://www.allrecipes.com/recipes/206/meat-and-poultry/turkey/',
        'Vegetable Recipes':
            'https://www.allrecipes.com/recipes/225/side-dish/vegetables/'
      }
    },
    ' Diet and Health': {
      'imageUrl': {
        'imageUrl': ' https://images.media-allrecipes.com/images/77852.jpg'
      },
      'categories': {
        'Diabetic':
            'https://www.allrecipes.com/recipes/739/healthy-recipes/diabetic/',
        'Low Carb Recipes':
            'https://www.allrecipes.com/recipes/742/healthy-recipes/low-carb/',
        'Dairy Free Recipes':
            'https://www.allrecipes.com/recipes/738/healthy-recipes/dairy-free/',
        'Gluten Free':
            'https://www.allrecipes.com/recipes/741/healthy-recipes/gluten-free/',
        "Healthy": 'https://www.allrecipes.com/recipes/84/healthy-recipes/',
        'Heart-Healthy Recipes':
            'https://www.allrecipes.com/recipes/22485/healthy-recipes/heart-healthy-recipes/',
        'High Fiber Recipes':
            'https://www.allrecipes.com/recipes/782/healthy-recipes/high-fiber/',
        'Low Calorie':
            'https://www.allrecipes.com/recipes/1232/healthy-recipes/low-calorie/',
        'Low Cholesterol Recipes':
            'https://www.allrecipes.com/recipes/737/healthy-recipes/low-cholesterol/',
        'Low Fat':
            'https://www.allrecipes.com/recipes/1231/healthy-recipes/low-fat/',
        'Weight-Loss Recipes':
            'https://www.allrecipes.com/recipes/22607/healthy-recipes/weight-loss/'
      }
    },
    'Seasonal': {
      'imageUrl': {
        'imageUrl': 'https://images.media-allrecipes.com/images/77856.jpg'
      },
      'categories': {
        '4th of July':
            'https://www.allrecipes.com/recipes/191/holidays-and-events/4th-of-july/',
        'Baby Shower':
            'https://www.allrecipes.com/recipes/1823/holidays-and-events/events-and-gatherings/showers/',
        'Birthday':
            'https://www.allrecipes.com/recipes/1523/holidays-and-events/events-and-gatherings/birthday-parties/',
        'Christmas':
            'https://www.allrecipes.com/recipes/187/holidays-and-events/christmas/',
        'Christmas Cookies':
            'https://www.allrecipes.com/recipes/841/holidays-and-events/christmas/desserts/christmas-cookies/',
        'Cinco de Mayo':
            'https://www.allrecipes.com/recipes/1509/holidays-and-events/cinco-de-mayo/',
        'Easter Recipes':
            'https://www.allrecipes.com/recipes/188/holidays-and-events/easter/',
        'Football':
            'https://www.allrecipes.com/recipes/1419/holidays-and-events/big-game/',
        'Halloween':
            'https://www.allrecipes.com/recipes/189/holidays-and-events/halloween/',
        'Hanukkah':
            'https://www.allrecipes.com/recipes/190/holidays-and-events/hanukkah/',
        "Mother's Day":
            'https://www.allrecipes.com/recipes/1445/holidays-and-events/mothers-day/',
        'New Year':
            'https://www.allrecipes.com/recipes/193/holidays-and-events/new-year/',
        'Passover':
            'https://www.allrecipes.com/recipes/194/holidays-and-events/passover/',
        'Ramadan':
            'https://www.allrecipes.com/recipes/195/holidays-and-events/ramadan/',
        "St. Patrick's Day":
            "https://www.allrecipes.com/recipes/197/holidays-and-events/st-patricks-day/",
        'Thanksgiving':
            'https://www.allrecipes.com/recipes/198/holidays-and-events/thanksgiving/',
        'Valentines Day':
            'https://www.allrecipes.com/recipes/199/holidays-and-events/valentines-day/',
        'More Holidays and Events':
            'https://www.allrecipes.com/recipes/85/holidays-and-events/'
      }
    },
    'Dish Type': {
      'imageUrl': {
        "imageUrl": 'https://images.media-allrecipes.com/images/77853.jpg'
      },
      'categories': {
        'Appetizers & Snacks':
            'https://www.allrecipes.com/recipes/76/appetizers-and-snacks/',
        'Bread Recipes': 'https://www.allrecipes.com/recipes/156/bread/',
        'Cake Recipes':
            'https://www.allrecipes.com/recipes/276/desserts/cakes/',
        'Candy and Fudge':
            'https://www.allrecipes.com/recipes/372/desserts/candy/',
        'Casserole Recipes':
            'https://www.allrecipes.com/recipes/249/main-dish/casseroles/',
        'Christmas Cookies':
            'https://www.allrecipes.com/recipes/841/holidays-and-events/christmas/desserts/christmas-cookies/',
        'Cocktail Recipes':
            'https://www.allrecipes.com/recipes/133/drinks/cocktails/',
        'Cookie Recipes':
            'https://www.allrecipes.com/recipes/362/desserts/cookies/',
        'Mac and Cheese Recipes':
            'https://www.allrecipes.com/recipes/509/main-dish/pasta/macaroni-and-cheese/',
        'Main Dishes': 'https://www.allrecipes.com/recipes/80/main-dish/',
        'Pasta Salad Recipes':
            'https://www.allrecipes.com/recipes/215/salad/pasta-salad/',
        "Pasta Recipes":
            'https://www.allrecipes.com/recipes/95/pasta-and-noodles/',
        'Pie Recipes': 'https://www.allrecipes.com/recipes/367/desserts/pies/',
        'Pizza': 'https://www.allrecipes.com/recipes/250/main-dish/pizza/',
        'Sandwiches':
            'https://www.allrecipes.com/recipes/251/main-dish/sandwiches/',
        'Sauces and Condiments':
            'https://www.allrecipes.com/recipes/17031/side-dish/sauces-and-condiments/',
        'Smoothie Recipes':
            'https://www.allrecipes.com/recipes/138/drinks/smoothies/',
        "Soups, Stew, and Chili Recipes":
            "https://www.allrecipes.com/recipes/94/soups-stews-and-chili/"
      }
    },
    'Cooking Style': {
      'imageUrl': {
        'imageUrl': 'https://images.media-allrecipes.com/images/77851.jpg'
      },
      'categories': {
        'BBQ & Grilling': 'https://www.allrecipes.com/recipes/88/bbq-grilling/',
        'Budget Cooking':
            'https://www.allrecipes.com/recipes/15522/everyday-cooking/budget-cooking/',
        'Clean-Eating':
            "https://www.allrecipes.com/recipes/17587/healthy-recipes/clean-eating/",
        'Cooking for Kids':
            'https://www.allrecipes.com/recipes/453/everyday-cooking/family-friendly/kid-friendly/',
        ' Cooking for Two':
            'https://www.allrecipes.com/recipes/476/everyday-cooking/cooking-for-two/',
        'Gourmet':
            'https://www.allrecipes.com/recipes/1592/everyday-cooking/gourmet/',
        'Paleo':
            'https://www.allrecipes.com/recipes/16705/healthy-recipes/paleo-diet/',
        'Pressure Cooker':
            'https://www.allrecipes.com/recipes/11978/everyday-cooking/cookware-and-equipment/pressure-cooker/',
        'Quick & Easy':
            'https://www.allrecipes.com/recipes/1947/everyday-cooking/quick-and-easy/',
        "Slow Cooker":
            'https://www.allrecipes.com/recipes/253/everyday-cooking/slow-cooker/',
        'Vegan':
            "https://www.allrecipes.com/recipes/1227/everyday-cooking/vegan/",
        'Vegetarian':
            'https://www.allrecipes.com/recipes/87/everyday-cooking/vegetarian/'
      }
    },
    'World Cuisine': {
      'imageUrl': {
        'imageUrl': "https://images.media-allrecipes.com/images/77859.jpg"
      },
      'categories': {
        'Chinese':
            'https://www.allrecipes.com/recipes/695/world-cuisine/asian/chinese/',
        'Indian':
            'https://www.allrecipes.com/recipes/233/world-cuisine/asian/indian/',
        'Italian':
            'https://www.allrecipes.com/recipes/723/world-cuisine/european/italian/',
        'Mexican':
            'https://www.allrecipes.com/recipes/728/world-cuisine/latin-american/mexican/',
        'Southern':
            'https://www.allrecipes.com/recipes/15876/us-recipes/southern/',
        'Thai':
            'https://www.allrecipes.com/recipes/702/world-cuisine/asian/thai/',
        'All World Cuisine':
            'https://www.allrecipes.com/recipes/86/world-cuisine/'
      }
    },
    ' Special Collections': {
      'imageUrl': {
        "imageUrl": "https://images.media-allrecipes.com/images/77857.jpg"
      },
      'categories': {
        "Allrecipes Magazine Recipes":
            "https://www.allrecipes.com/recipes/17235/everyday-cooking/allrecipes-magazine-recipes/",
        "Food Wishes with Chef John":
            "https://www.allrecipes.com/recipes/16791/everyday-cooking/special-collections/web-show-recipes/food-wishes/",
        " Entertaining and Dinner Parties":
            "https://www.allrecipes.com/recipes/17185/everyday-cooking/entertaining/"
      }
    }
  };

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    // sendToFirebase();
    return Scaffold(
      // appBar: AppBar(),
      body: isLoading
          ? showRetry ? RetryScreen() : LoadingCategoriesScreen()
          : Stack(
              children: [
                AllCategoriesScroll(
                  categoriesMap: categoriesMapLocal,
                ),
              ],
            ),
    );
  }
}

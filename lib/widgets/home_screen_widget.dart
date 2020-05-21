import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:recipetap/pages/catagories_screen.dart';
import 'package:recipetap/pages/favourites_screen.dart';
import 'package:recipetap/pages/search_screen.dart';
import 'package:recipetap/pages/settings_screen.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:slimy_card/slimy_card.dart';

class HomeScreenWidget extends StatelessWidget {
  final AppBarController appBarController = AppBarController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        primary: Theme.of(context).primaryColor,
        appBarController: appBarController,

        searchHint: "Search Recipes",
        mainTextColor: Colors.white,
        onChange: (String value) {
          //Your function to filter list. It should interact with
          //the Stream that generate the final list
        },
        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          title: Text("Welcome, User!"),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                child: Icon(
                  Icons.search,
                ),
                onTap: () {
                  //This is where You change to SEARCH MODE. To hide, just
                  //add FALSE as value on the stream
                  appBarController.stream.add(true);
                },
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            child: Image.asset(
                              'assets/images/fridge.jpg',
                              fit: BoxFit.cover,
                            ),

                            // child: BackdropFilter(
                            //   filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                            // ),
                            // child: Image.asset('assets/images/fridge.jpg'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Text(
                        'Find Recipes From The Items In Your Fridge'
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption.copyWith(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w200,
                              wordSpacing: 2,
                              letterSpacing: 1.2,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: SlimyCard(
              //     color: Colors.deepPurple,
              //     width: MediaQuery.of(context).size.width * 0.95,
              //     borderRadius: 25,
              //     topCardHeight: 275,
              //     // 235
              //     topCardWidget: Stack(
              //       children: [
              //         Column(
              //           children: <Widget>[
              //             ClipRRect(
              //               borderRadius: BorderRadius.circular(25),
              //               child: Container(
              //                 child: Image.asset(
              //                   'assets/images/fridge.jpg',
              //                   fit: BoxFit.cover,
              //                 ),

              //                 // child: BackdropFilter(
              //                 //   filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              //                 // ),
              //                 // child: Image.asset('assets/images/fridge.jpg'),
              //               ),
              //             ),
              //             SizedBox(
              //               height: 20,
              //             ),
              //           ],
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(17.0),
              //           child: Text(
              //             'Find Recipes From The Items In Your Fridge'
              //                 .toUpperCase(),
              //             textAlign: TextAlign.center,
              //             style: Theme.of(context).textTheme.caption.copyWith(
              //                   color: Colors.white,
              //                   fontSize: 30,
              //                   fontWeight: FontWeight.w200,
              //                   wordSpacing: 2,
              //                   letterSpacing: 1.2,
              //                 ),
              //           ),
              //         ),
              //       ],
              //     ),
              //     bottomCardHeight: 200,
              //     bottomCardWidget: Container(
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //     ),
              //   ),
              // ),
              Text("Recently Viewed"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlimyCard(
                  topCardHeight: 150,
                  bottomCardHeight: 250,
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  topCardWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.history),
                      Text('RECENTS'),
                    ],
                  ),
                ),
              ),
              // Text('Search'),
              // TextFormField(
              //   controller: normalSearchController,
              // ),
              // FlatButton(
              //   child: Text('Search Recipe by name'),
              //   onPressed: () => submitSearchNormal(
              //     "Showing Results For " + normalSearchController.text,
              //     normalSearchController.text
              //         .replaceAll(" ", "%20")
              //         .toLowerCase(),
              //   ),
              // ),
              // // TODO retry button for dns fail
              // Text('Favourites'),
              // Text('Browse By Category'),
              // Text('Search By Ingredients'),
              // SizedBox(
              //   height: 50,
              // ),
              // Text('Include'),
              // SimpleAutoCompleteTextField(
              //   key: key,
              //   suggestions: suggestions,
              //   // textChanged: (query) => suggestions.add(query),
              //   controller: inclController,
              // ),
              // SizedBox(
              //   height: 50,
              // ),
              // Text('Exclude'),
              // SimpleAutoCompleteTextField(
              //   key: keyy,
              //   suggestions: suggestions,
              //   controller: exclController,
              // ),
              // SizedBox(
              //   height: 50,
              // ),
              // FlatButton(
              //   child: Text('Search'),
              //   onPressed: () {
              //     submitSearch(
              //       inclController.text.toLowerCase().replaceAll(" ", "%20"),
              //       exclController.text.toLowerCase().replaceAll(" ", "%20"),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

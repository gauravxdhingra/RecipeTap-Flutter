// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class SearchHomeWidget extends StatelessWidget {
  const SearchHomeWidget({
    @required this.controller,
    // @required this.key,
    @required this.suggestions,
    @required this.inclController,
    // @required this.keyy,
    @required this.exclController,
    @required this.submitSearch,
  });

  final TextEditingController controller;
  // final GlobalKey<AutoCompleteTextFieldState<String>> key;
  final List<String> suggestions;
  final TextEditingController inclController;
  // final GlobalKey<AutoCompleteTextFieldState<String>> keyy;
  final TextEditingController exclController;
  final Function submitSearch;

  @override
  Widget build(BuildContext context) {
    // GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

    // GlobalKey<AutoCompleteTextFieldState<String>> keyy = GlobalKey();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: <Widget>[
          //       Text('Search For: '),
          //       Container(
          //         width: MediaQuery.of(context).size.width * 2 / 3,
          //         child: TextField(
          //           controller: controller,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  child: Container(
                    child: Text(
                      'Include',
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    child: Text(
                      'Exclude',
                    ),
                  ),
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width * 2 / 3,
                //   child:
                //       // ChipsInput(
                //       //   chipBuilder: null,
                //       //   suggestionBuilder: null,
                //       //   findSuggestions: null,
                //       //   onChanged: null,
                //       // )
                //       SimpleAutoCompleteTextField(
                //     key: key,
                //     suggestions: suggestions,
                //     // textChanged: (query) => suggestions.add(query),

                //     controller: inclController,
                //   ),
                // ),
              ],
            ),
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: <Widget>[
          //       Text('Exclude'),
          //       Container(
          //         width: MediaQuery.of(context).size.width * 2 / 3,
          //         child: SimpleAutoCompleteTextField(
          //           key: keyy,
          //           suggestions: suggestions,
          //           controller: exclController,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          FlatButton(
            child: Text('Search'),
            onPressed: () {
              submitSearch(
                controller.text.trim().isNotEmpty
                    ? "Showing Results For " + controller.text
                    : "Showing Recipes From Ingredients",
                controller.text.replaceAll(" ", "%20").toLowerCase(),
                inclController.text
                    .toLowerCase()
                    .replaceAll(", ", ",")
                    .replaceAll(" ", "%20"),
                exclController.text
                    .toLowerCase()
                    .replaceAll(", ", ",")
                    .replaceAll(" ", "%20"),
              );
            },
          ),
        ],
      ),
    );
  }
}

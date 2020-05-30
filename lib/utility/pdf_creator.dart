// import 'package:flutter_example/pdf.dart';
import 'dart:io';

import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:recipetap/models/recipe_model.dart';
import 'package:share_extend/share_extend.dart';

import './pdf_viewer_page.dart';

reportView(context, RecipeModel recipe, String photoUrl) async {
  try {
    final Document pdf = Document();
    String filePath;

    final font = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final ttf = Font.ttf(font);
    final fontBold = await rootBundle.load("assets/fonts/OpenSans-Bold.ttf");
    final ttfBold = Font.ttf(fontBold);
    final fontItalic =
        await rootBundle.load("assets/fonts/OpenSans-Italic.ttf");
    final ttfItalic = Font.ttf(fontItalic);
    // final fontBoldItalic =
    //     await rootBundle.load("assets/fonts/OpenSans-BoldItalic.ttf");
    // final ttfBoldItalic = Font.ttf(fontBoldItalic);
    final theme = Theme.withFont(
      base: ttf,
      bold: ttfBold,
      italic: ttfItalic,
      // boldItalic: ttfBoldItalic,
    );

    // recipe.ingredients.forEach((element) {
    //   ingredients = ingredients + element.toString() + "\n";
    // });
    String ingredients = "";
    List ingredientss = [];
    if (recipe.oldWebsite)
      for (int x = 0; x < recipe.ingredients.length; x++) {
        // ingredients = ingredients + recipe.ingredients[x].toString() + "\n\n";
        // ingredientss.add(recipe.ingredients[x].toString() + "\n");
        ingredientss.add(recipe.ingredients[x].toString());
        //  + "\n");
        // ingredientss.add("\n");
      }

    if (!recipe.oldWebsite)
      for (int x = 0; x < recipe.ingredients.length - 2; x++) {
        // ingredients = ingredients + recipe.ingredients[x].toString() + "\n\n";
        // ingredientss.add(recipe.ingredients[x].toString() + "\n");
        // ingredientss.add(recipe.ingredients[x].toString() + "\n");
        ingredientss.add(recipe.ingredients[x].toString());
        // ingredientss.add("\n");
      }

    // for (int i = 0; i < ingredients.split("\n\n").length; i++) {
    //   ingredientss.add(ingredients.split("\n\n")[i].toString() + "\n\n77");
    // }
    // print(ingredientss);

    String directions = "";
    // int i = 0;
    // recipe.steps.forEach((element) {
    //   i++;
    //   // if (recipe.steps[i - 1].toString().trim() != "" &&
    //   //     !recipe.steps[i - 1].toString().trim().contains("Cook's"))
    //     directions = directions +
    //         "#" +
    //         i.toString() +
    //         "\n" +
    //         element.toString() +
    //         "\n\n";
    // });

    // if (recipe.oldWebsite)

    // print(recipe.steps);
    for (int x = 0; x < recipe.steps.length - 1; x++) {
      // x++;
      // if (recipe.steps[x - 2].toString().trim() != "" &&
      //     !recipe.steps[x - 2].toString().trim().contains("Cook's"))
      directions = directions +
          "#" +
          (x + 1).toString() +
          "\n" +
          recipe.steps[x].toString() +
          "\n\n";
    }
    List directionss = [];

    for (int i = 0; i < directions.split("\n\n").length; i++) {
      directionss.add(directions.split("\n\n")[i]);
    }

    // if (!recipe.oldWebsite)
    //   for (int x = 0; x < recipe.steps.length-1; x++) {
    //     x++;
    //     // if (recipe.steps[x - 1].toString().trim() != "" &&
    //     //     !recipe.steps[x - 1].toString().trim().contains("Cook's"))
    //     directions = directions +
    //         "#" +
    //         x.toString() +
    //         "\n" +
    //         recipe.steps[x - 1].toString() +
    //         "\n\n";
    //     print(recipe.steps[x - 1]);
    //   }

    String cooksNotes = "";
    int j = 0;
    if (recipe.oldWebsite)
      recipe.cooksNotes.forEach((element) {
        j++;
        if (recipe.steps[j - 1].toString().trim() != "" &&
            !recipe.steps[j - 1].toString().trim().contains("Cook's") &&
            !recipe.steps[j - 1].toString().trim().contains("calories"))
          cooksNotes = cooksNotes + element.toString() + "\n";
      });

    String yeild;
    if (recipe.yeild == null) {
      yeild = "--";
    } else {
      yeild = recipe.yeild.toString();
    }

    String nutritionalFacts = "";
    // int k = 0;
    // print(recipe.nutritionalFacts);

    if (recipe.nutritionalFacts != null &&
        recipe.nutritionalFacts != []) if (recipe.oldWebsite)
      for (int x = 0; x < recipe.nutritionalFacts.length - 1; x++) {
        nutritionalFacts =
            nutritionalFacts + recipe.nutritionalFacts[x].toString() + "\n";
      }

    if (recipe.nutritionalFacts != null &&
        recipe.nutritionalFacts != []) if (!recipe.oldWebsite)
      for (int x = 0; x < recipe.nutritionalFacts.length; x++) {
        nutritionalFacts =
            nutritionalFacts + recipe.nutritionalFacts[x].toString() + "\n";
      }

    // print(nutritionalFacts);

    // final String imgdir = (await getApplicationDocumentsDirectory()).path;
    // String pathh = '$imgdir/pdfcover.jpg';
    // File filee = File(pathh);
    // print(photoUrl);
    // material.Image(
    //     image: NetworkToFileImage(url: photoUrl, file: filee, debug: true));

    // final image = PdfImage.file(
    //   pdf.document,
    //   bytes: filee.readAsBytesSync(),
    // );

    var url = recipe.coverPhotoUrl[0] ??
        "https://cdn.dribbble.com/users/844846/screenshots/2855815/no_image_to_show_.jpg"; // <-- 1
    var response = await get(url); // <--2
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/pic.jpg';
    //comment out the next three lines to prevent the image from being saved
    //to the device to show that it's coming from the internet
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = new File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes);

    final image = PdfImage.file(
      pdf.document,
      bytes: file2.readAsBytesSync(),
    );

    pdf.addPage(MultiPage(
        theme: theme,
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                    BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RecipeTap',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey),
                ),
                Text(
                  'Available on Google Play',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey),
                ),
              ],
            ),
          );
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Page ${context.pageNumber} of ${context.pagesCount}',
                        style: Theme.of(context)
                            .defaultTextStyle
                            .copyWith(color: PdfColors.grey)),
                    Text('RecipeTap',
                        style: Theme.of(context)
                            .defaultTextStyle
                            .copyWith(color: PdfColors.grey)),
                  ]));
        },
        build: (Context context) => <Widget>[
              Wrap(children: [
                Header(
                    level: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('RecipeTap', textScaleFactor: 2),
                          Text('Available on Google Play', textScaleFactor: 1)
                          // LOGO
                          // Play Store Url
                        ])),
                Header(level: 1, text: recipe.title),
                if (photoUrl != null &&
                    photoUrl !=
                        "https://www.allrecipes.com/img/icons/generic-recipe.svg" &&
                    photoUrl !=
                        "https://images.media-allrecipes.com/images/82579.png" &&
                    photoUrl !=
                        "https://images.media-allrecipes.com/images/79591.png")
                  Padding(padding: const EdgeInsets.all(10)),

                if (photoUrl != null &&
                    photoUrl !=
                        "https://www.allrecipes.com/img/icons/generic-recipe.svg" &&
                    photoUrl !=
                        "https://images.media-allrecipes.com/images/82579.png" &&
                    photoUrl !=
                        "https://images.media-allrecipes.com/images/79591.png")
                  Image(
                    image,
                    fit: BoxFit.cover,
                    height: 220,
                    width: 220,
                    alignment: Alignment.center,
                  ),
                if (photoUrl != null &&
                    photoUrl !=
                        "https://www.allrecipes.com/img/icons/generic-recipe.svg" &&
                    photoUrl !=
                        "https://images.media-allrecipes.com/images/82579.png" &&
                    photoUrl !=
                        "https://images.media-allrecipes.com/images/79591.png")
                  Padding(padding: const EdgeInsets.all(10)),
                // Recipe Cover Image Here
                Paragraph(
                  text: recipe.desc,
                  textAlign: TextAlign.center,
                ),

                // Paragraph(
                //     text:
                //        ),
                Padding(padding: const EdgeInsets.all(10)),
                Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>['Time', 'Servings', 'Yeild'],
                    <String>[recipe.time, recipe.servings, yeild],
                  ],
                  cellAlignment: Alignment.center,
                ),
                Padding(padding: const EdgeInsets.all(10)),
                SizedBox(height: 20),
                Header(level: 2, text: 'Ingredients'),
                // Paragraph(text: ingredients),
                for (var i in ingredientss)
                  Paragraph(
                      text: i.toString(), padding: EdgeInsets.only(right: 200)),

                Padding(padding: const EdgeInsets.all(10)),

                Header(level: 2, text: 'Directions'),

                for (var i in directionss)
                  Paragraph(
                    text: i.toString(),
                  ),

                // Paragraph(text: directions),

                Padding(padding: const EdgeInsets.all(10)),

                if (cooksNotes.trim() != "")
                  Header(level: 2, text: "Cook's Notes"),
                if (cooksNotes.trim() != "")
                  Paragraph(text: cooksNotes),

                if (nutritionalFacts.trim() != "")
                  Header(level: 2, text: "Nutritional Facts"),
                if (nutritionalFacts.trim() != "")
                  Paragraph(text: nutritionalFacts),

                //   if (cooksNotes.trim() != "")
                // Paragraph(text: nutritionalFacts),
              ])
            ]));
    //save PDF
    final String dir = (await getApplicationDocumentsDirectory()).path;
    String path;
    if (recipe.title.length > 25) {
      path = '$dir/${recipe.title.substring(0, 25)}.pdf';
      filePath = path;
    } else {
      path = '$dir/${recipe.title}.pdf';
      filePath = path;
    }
    File file = File(path);
    await file.writeAsBytes(pdf.save());

    // Ext
    try {
      String dirext = (await getExternalStorageDirectory()).path;
      dirext = dirext.split("/Android")[0] + "/RecipeTap";
      print(dirext);

      String pathext;
      if (recipe.title.length > 25) {
        pathext = '$dirext/${recipe.title.substring(0, 25)}.pdf';
        // filePath = pathext;
      } else {
        pathext = '$dirext/${recipe.title}.pdf';
        // filePath = pathext;
      }
      // final String pathext = ;
      final File fileext = File(pathext);
      await fileext.writeAsBytes(pdf.save());
    } catch (e) {
      String dirext = (await getExternalStorageDirectory()).path;
      // dirext = dirext.split("/Android")[0] + "/RecipeTap";
      print(dirext);

      String pathext;
      if (recipe.title.length > 25) {
        pathext = '$dirext/${recipe.title.substring(0, 25)}.pdf';
        // filePath = pathext;
      } else {
        pathext = '$dirext/${recipe.title}.pdf';
        // filePath = pathext;
      }
      // final String pathext = ;
      final File fileext = File(pathext);
      await fileext.writeAsBytes(pdf.save());
    }
    // Nav
    material.Navigator.pop(context);
    material.showDialog(
        context: context,
        builder: (context) {
          // material.Navigator.pop(context);
          return material.AlertDialog(
            title: material.Text('File Saved To Internal Storage'),
            content: material.Text(
              'File Stored to "Storage/RecipeTap/${recipe.title}.pdf"',
            ),
            shape: material.RoundedRectangleBorder(
                borderRadius: material.BorderRadius.circular(25)),
            actions: <material.Widget>[
              material.FlatButton(
                child: material.Text('View'),
                onPressed: () {
                  material.Navigator.of(context).push(
                    material.MaterialPageRoute(
                      builder: (_) => PdfViewerPage(path: path),
                    ),
                  );
                },
              ),
              material.FlatButton(
                child: material.Text('Share'),
                onPressed: () async {
                  ShareExtend.share(
                      filePath, "RecipeTap-Available on Google Play");
                },
              ),
            ],
          );
        });
  } catch (e) {
    print(e);
    material.Navigator.pop(context);
    material.showDialog(
      context: context,
      builder: (context) {
        return material.AlertDialog(
          title:
              material.Text("Failed To Generate PDF.\nWe are looking into it"),
          actions: <material.Widget>[
            material.FlatButton(
              child: material.Text("OK"),
              onPressed: () {
                material.Navigator.pop(context);
                // material.Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
  // material.Navigator.pop(context);
}

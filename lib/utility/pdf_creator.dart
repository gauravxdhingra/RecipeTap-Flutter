// import 'package:flutter_example/pdf.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipetap/models/recipe_model.dart';
import 'package:share_extend/share_extend.dart';
import './pdf_viewer_page.dart';
// import 'package:esys_flutter_share/esys_flutter_share.dart';

import 'package:flutter/material.dart' as material;

reportView(context, RecipeModel recipe) async {
  try {
    final Document pdf = Document();
    String filePath;
    String ingredients = "";

    recipe.ingredients.forEach((element) {
      ingredients = ingredients + element.toString() + "\n";
    });

    String directions = "";
    int i = 0;
    recipe.steps.forEach((element) {
      i++;
      if (recipe.steps[i - 1].toString().trim() != "" &&
          !recipe.steps[i - 1].toString().trim().contains("Cook's"))
        directions = directions +
            "#" +
            i.toString() +
            "\n" +
            element.toString() +
            "\n\n";
    });

    String cooksNotes = "";
    int j = 0;
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

    if (recipe.nutritionalFacts != null && recipe.nutritionalFacts != [])
      recipe.nutritionalFacts.forEach((element) {
        // k++;
        nutritionalFacts = nutritionalFacts + element.toString() + "\n";
      });

    pdf.addPage(MultiPage(
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
              // Recipe Cover Image Here
              Paragraph(
                text: recipe.desc,
              ),

              // Paragraph(
              //     text:
              //        ),
              Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Time', 'Servings', 'Yeild'],
                <String>[recipe.time, recipe.servings, yeild],
              ]),
              Padding(padding: const EdgeInsets.all(10)),
              Header(level: 2, text: 'Ingredients'),
              Paragraph(text: ingredients),
              Padding(padding: const EdgeInsets.all(10)),
              Header(level: 2, text: 'Directions'),
              Paragraph(text: directions),
              Padding(padding: const EdgeInsets.all(10)),
              if (cooksNotes.trim() != "")
                Header(level: 2, text: "Cook's Notes"),
              if (cooksNotes.trim() != "")
                Paragraph(text: cooksNotes),
              if (nutritionalFacts.trim() != "")
                Header(level: 2, text: "Nutritional Facts"),
              if (cooksNotes.trim() != "")
                Paragraph(text: nutritionalFacts),
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
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
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

    material.showDialog(
        context: context,
        builder: (context) {
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
    material.showDialog(
      context: context,
      builder: (context) {
        return material.AlertDialog(
          title:
              material.Text("Failed To Generate PDF.\nWe are looking into it"),
          actions: <material.Widget>[
            material.InkWell(
              child: material.Text('OK'),
              onTap: () {
                material.Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

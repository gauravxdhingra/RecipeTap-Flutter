// import 'package:flutter_example/pdf.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipetap/models/recipe_model.dart';
import './pdf_viewer_page.dart';

import 'package:flutter/material.dart' as material;

reportView(context, RecipeModel recipe) async {
  final Document pdf = Document();

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
      directions =
          directions + "#" + i.toString() + "\n" + element.toString() + "\n\n";
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
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
            Header(
                level: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('RecipeTap', textScaleFactor: 2),
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
              <String>[recipe.time, recipe.servings, recipe.yeild],
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
          ]));
  //save PDF
  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/report.pdf';
  final File file = File(path);
  await file.writeAsBytes(pdf.save());
  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => PdfViewerPage(path: path),
    ),
  );
}

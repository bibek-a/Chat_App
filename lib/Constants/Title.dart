import 'package:chating_app/Providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Book_Title {
  static getTitle(index, BuildContext context) {
    String title;
    int value = index + 1;
    switch (value) {
      case 0:
        title = "";
        break;
      case 1:
        title = "Of STUDIES";
        break;
      case 2:
        title = "HOW MUCH LAND DOES A MAN NEED";
        break;
      case 3:
        title = "THE LADY WITH THE PET DOG";
        break;
      case 4:
        title = "FREEDOM";
        break;
      case 5:
        title = "CIVIL PEACE";
        break;
      case 6:
        title = "The mother of a traitor";
        break;
      case 7:
        title = "KNOWLEDGE AND WISDOM";
        break;
      case 8:
        title = "THE SCIENTIFIC ATTITUDE";
        break;
      case 9:
        title = "STRAIGHT AND CROOKED THINKING";
        break;
      case 10:
        title = "WATER SUPPLIES-A GROWING PROBLEM";
        break;
      case 11:
        title = "WHAT EINSTEIN DID";
        break;
      default:
        title = "MIRACLES OF THE GRASS";
    }
    return Text(
      title.toString().toUpperCase(),
      textAlign: TextAlign.center,
      style: GoogleFonts.josefinSans(
        textStyle: TextStyle(
            fontSize: 19,
            wordSpacing: 3,
            fontWeight: FontWeight.w500,
            color:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.light
                    ? Colors.black
                    : Color.fromARGB(255, 164, 161, 161),
            letterSpacing: .4),
      ),
    );
  }

//
//
  static getAuthor(index, BuildContext context) {
    String author;
    int value = index + 1;
    switch (value) {
      case 0:
        author = "";
        break;
      case 1:
        author = "FRANCIS BACON";
        break;
      case 2:
        author = "LEO TOLSTOY";
        break;
      case 3:
        author = "ANTON CHEKHOV";
        break;
      case 4:
        author = "GEORGE BERNAD SHAW";
        break;
      case 5:
        author = "CHINUA ACHEBE";
        break;
      case 6:
        author = "MAXIM GORKY";
        break;
      case 7:
        author = "BERTRAND RUSSELL";
        break;
      case 8:
        author = "";
        break;
      case 9:
        author = "R.H AND C.R THULLS";
        break;
      case 11:
        author = "";
        break;
      default:
        author = "jOSEPH WOOD KRUTCH";
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        author.toString().toUpperCase(),
        textAlign: TextAlign.center,
        style: GoogleFonts.josefinSans(
          textStyle: TextStyle(
              fontSize: 19,
              wordSpacing: 3,
              fontWeight: FontWeight.w500,
              color: Provider.of<themeProvider>(context, listen: false)
                          .themeMode ==
                      ThemeMode.light
                  ? Colors.black
                  : Color.fromARGB(255, 163, 161, 161),
              letterSpacing: .4),
        ),
      ),
    );
  }
}

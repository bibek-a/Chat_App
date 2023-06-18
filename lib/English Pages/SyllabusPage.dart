// import 'package:chating_app/NewPage.dart';
import 'dart:developer';

import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/English%20Pages/ContentPage.dart';
import 'package:chating_app/English%20Pages/FormalWritingPage.dart';
import 'package:chating_app/English%20Pages/InformalWriting.dart';
import 'package:chating_app/English%20Pages/MLAAPAFormatPage.dart';
import 'package:chating_app/English%20Pages/NoteMaking.dart';
import 'package:chating_app/English%20Pages/ReadPDFPage.dart';
// import 'package:chating_app/English%20Pages/SummaryContentPage.dart';
import 'package:chating_app/English%20Pages/SummarySyllabus.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

// import 'FormalWriting.dart';

class SyllabusPage extends StatefulWidget {
  const SyllabusPage({Key? key}) : super(key: key);

  @override
  State<SyllabusPage> createState() => _SyllabusPageState();
}

class _SyllabusPageState extends State<SyllabusPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    log("height: " + height.toString());
    log("width: " + width.toString());
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.light
              ? Brightness.dark
              : Brightness.light,
      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 0, 0, 0)
              : Colors.blue[200],
      // statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.light
              ? Colors.blue[200]
              : Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                          alignment: Alignment.center,
                          height: width / 7.1544,
                          width: width / 7.8544,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Provider.of<themeProvider>(context,
                                            listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? Color.fromARGB(255, 139, 197, 244)
                                : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.7),
                                spreadRadius: -7,
                                offset: Offset(5, 5),
                                blurRadius: 20,
                              )
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          child: IconButton(
                            onPressed: () {
                              Provider.of<themeProvider>(context, listen: false)
                                  .toggleTheme();
                            },
                            icon: Provider.of<themeProvider>(context,
                                            listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? Icon(Icons.dark_mode)
                                : Icon(Icons.light_mode),
                            padding: EdgeInsets.all(0),
                            iconSize: 30,
                            color: Colors.black,
                          ),
                          decoration: BoxDecoration(
                            color: Provider.of<themeProvider>(context,
                                            listen: false)
                                        .themeMode ==
                                    ThemeMode.dark
                                ? Color.fromARGB(255, 255, 255, 255)
                                : Color.fromARGB(255, 129, 186, 232),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Provider.of<themeProvider>(context,
                                                listen: false)
                                            .themeMode ==
                                        ThemeMode.dark
                                    ? Color.fromARGB(255, 155, 184, 111)
                                    : Colors.black,
                                spreadRadius: -7,
                                offset: Offset(-5, 5),
                                blurRadius: 30,
                              )
                            ],
                          )),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 20.0),
                  child: Row(
                    children: [
                      Icon(Icons.content_paste_rounded),
                      SizedBox(width: 10),
                      Text("Table Of Contents",
                          style:
                              Provider.of<themeProvider>(context, listen: false)
                                          .themeMode ==
                                      ThemeMode.light
                                  ? MeroStyle.getStyle(width / 14)
                                  : MeroStyle.getStyle2(width / 14)),
                    ],
                  ),
                ),
                //
                SizedBox(height: 20),
                //
                Container(
                  width: width / 1.57,
                  decoration: BoxDecoration(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 139, 197, 244)
                        : Color.fromARGB(255, 50, 49, 49),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: -6,
                        offset: Offset(6, 5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Summary();
                      }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "1.",
                          style:
                              Provider.of<themeProvider>(context, listen: false)
                                          .themeMode ==
                                      ThemeMode.light
                                  ? MeroStyle.getStyle(width / 17)
                                  : MeroStyle.getStyle2(width / 17),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Summary Story",
                          style:
                              Provider.of<themeProvider>(context, listen: false)
                                          .themeMode ==
                                      ThemeMode.light
                                  ? MeroStyle.getStyle(width / 16)
                                  : MeroStyle.getStyle2(width / 16),
                        )
                      ],
                    ),
                  ),
                ),
                //
                SizedBox(height: 20),
                //
                Container(
                  width: width / 2.2,
                  decoration: BoxDecoration(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 139, 197, 244)
                        : Color.fromARGB(255, 50, 49, 49),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: -4,
                        offset: Offset(6, 5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {},
                    child: Row(children: [
                      Text(
                        "2.",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Grammer",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      )
                    ]),
                  ),
                ),

                //
                //
                SizedBox(height: 20),
                //
                Container(
                  width: width / 1.28,
                  decoration: BoxDecoration(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 139, 197, 244)
                        : Color.fromARGB(255, 50, 49, 49),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: -4,
                        offset: Offset(6, 5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MLAAPAFormatPage();
                      }));
                    },
                    child: Row(children: [
                      Text(
                        "3.",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "MLA and APA Format",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      )
                    ]),
                  ),
                ),
                //
                SizedBox(height: 20),
                //
                Container(
                  width: width / 1.06,
                  decoration: BoxDecoration(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 139, 197, 244)
                        : Color.fromARGB(255, 50, 49, 49),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: -4,
                        offset: Offset(6, 5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return InformalWritingPage(
                            // index: 5,
                            );
                      }));
                    },
                    child: Row(children: [
                      Text(
                        "4.",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Notice, Agenda and Minute",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      )
                    ]),
                  ),
                ),
                //
                SizedBox(height: 20),
                //
                Container(
                  width: width / 1.57,
                  decoration: BoxDecoration(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 139, 197, 244)
                        : Color.fromARGB(255, 50, 49, 49),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: -4,
                        offset: Offset(6, 5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FormalWritingPage(
                            // index: 5,
                            );
                      }));
                    },
                    child: Row(children: [
                      Text(
                        "5.",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Formal Writing",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      )
                    ]),
                  ),
                ),
                SizedBox(height: 20),
                //
                Container(
                  width: width / 2.4,
                  decoration: BoxDecoration(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 139, 197, 244)
                        : Color.fromARGB(255, 50, 49, 49),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: -4,
                        offset: Offset(6, 5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ContentPage(
                          index: 4,
                        );
                      }));
                    },
                    child: Row(children: [
                      Text(
                        "6.",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Editing",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      )
                    ]),
                  ),
                ),
                //
                SizedBox(height: 20),
                //
                Container(
                  width: width / 1.8,
                  decoration: BoxDecoration(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 139, 197, 244)
                        : Color.fromARGB(255, 50, 49, 49),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: -4,
                        offset: Offset(6, 5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ContentPage(
                          index: 3,
                        );
                      }));
                    },
                    child: Row(children: [
                      Text(
                        "7.",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Interpretation",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      )
                    ]),
                  ),
                ),
                //
                SizedBox(height: 20),
                //
                Container(
                  width: width / 1.08,
                  decoration: BoxDecoration(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 139, 197, 244)
                        : Color.fromARGB(255, 50, 49, 49),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: -4,
                        offset: Offset(6, 5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return NoteMaking(
                            // index: 2,
                            );
                      }));
                    },
                    child: Row(children: [
                      Text(
                        "8.",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Summary and Note Making",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      )
                    ]),
                  ),
                ),
                //
                SizedBox(height: 20),
                //
                Container(
                  width: width / 1.6,
                  decoration: BoxDecoration(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 139, 197, 244)
                        : Color.fromARGB(255, 50, 49, 49),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: -4,
                        offset: Offset(6, 5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ContentPage(
                          index: 1,
                        );
                      }));
                    },
                    child: Row(children: [
                      Text(
                        "9.",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Question Sets",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      )
                    ]),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: width / 1.50,
                  decoration: BoxDecoration(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 139, 197, 244)
                        : Color.fromARGB(255, 50, 49, 49),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: -4,
                        offset: Offset(6, 5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ReadPDFPage(
                          index: 1,
                        );
                      }));
                    },
                    child: Row(children: [
                      Text(
                        "10.",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Writing Propsal",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      )
                    ]),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: width / 1.50,
                  decoration: BoxDecoration(
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 139, 197, 244)
                        : Color.fromARGB(255, 50, 49, 49),
                    borderRadius: BorderRadius.circular(30),
                    // shape: BoxShape.circle,uju8ju8m bh hn
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: -4,
                        offset: Offset(6, 5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ReadPDFPage(
                          index: 2,
                        );
                      }));
                    },
                    child: Row(children: [
                      Text(
                        "11.",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Report Writing",
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? MeroStyle.getStyle(width / 17)
                                : MeroStyle.getStyle2(width / 17),
                      )
                    ]),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

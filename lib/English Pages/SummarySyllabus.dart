// import 'dart:ui/painting.dart';

import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Constants/Title.dart';
import 'package:chating_app/English%20Pages/SummaryContentPage.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Summary extends StatefulWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  var currentIndex = -1;
  var BookList = [
    "Chapter 1",
    "Chapter 2",
    "Chapter 3",
    "Chapter 4",
    "Chapter 5",
    "Chapter 6",
    "Chapter 7",
    "Chapter 8",
    "Chapter 9",
    "Chapter 10",
    "Chapter 11",
    "Chapter 12",
  ];
  @override
  Widget build(BuildContext context) {
    var heihgt = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.light
              ? Colors.blue[200]
              : Colors.black,
      appBar: AppBar(
        backgroundColor:
            Provider.of<themeProvider>(context, listen: false).themeMode ==
                    ThemeMode.light
                ? Colors.blue[200]
                : Color.fromARGB(255, 21, 21, 21),
        elevation: 10,
        // shadowColor: Color.fromARGB(255, 91, 35, 15),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black, size: 33),
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
              alignment: Alignment.center,
              height: heihgt / 7.85,
              width: width / 7.85,
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
                color: Provider.of<themeProvider>(context, listen: false)
                            .themeMode ==
                        ThemeMode.light
                    ? Color.fromARGB(255, 139, 197, 244)
                    : Color.fromARGB(255, 167, 165, 165),
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
        actions: [
          IconButton(
            tooltip: "last open",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SummaryContentPage(index: currentIndex);
              }));
            },
            icon: Icon(
              Icons.restore_outlined,
              color: Provider.of<themeProvider>(context, listen: false)
                          .themeMode ==
                      ThemeMode.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ],
        title: Text(
          "Summary Writing",
          style: Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.light
              ? MeroStyle.getStyle(width / 17)
              : MeroStyle.getStyle2(width / 17),
        ),
        centerTitle: true,
        // backgroundColor: Colors.blue[200],
      ),
      body: Center(
        child: Container(
          color: Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.light
              ? Color.fromARGB(255, 139, 197, 244)
              : Color.fromARGB(255, 50, 49, 49),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GridView.builder(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.only(bottom: 12),
                itemCount: BookList.length,
                gridDelegate: (SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 3,
                )),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      currentIndex = index;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SummaryContentPage(
                          index: currentIndex,
                        );
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Provider.of<themeProvider>(context, listen: false)
                                          .themeMode ==
                                      ThemeMode.light
                                  ? Color.fromARGB(255, 132, 186, 230)
                                  : Color.fromARGB(255, 39, 38, 38),
                              // Color.fromARGB(255, 144, 202, 249),
                              Provider.of<themeProvider>(context, listen: false)
                                          .themeMode ==
                                      ThemeMode.light
                                  ? Color.fromARGB(255, 132, 186, 230)
                                  : Color.fromARGB(255, 39, 38, 38),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(7, 8),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                BookList[index],
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: width / 20,
                                      color: Provider.of<themeProvider>(context,
                                                      listen: false)
                                                  .themeMode ==
                                              ThemeMode.light
                                          ? Colors.black
                                          : Color.fromARGB(255, 193, 189, 189),
                                      letterSpacing: .5),
                                ),
                              ),
                              Book_Title.getTitle(index, context),
                              Icon(
                                Icons.note_add_sharp,
                                size: 40,
                                color: Provider.of<themeProvider>(context,
                                                listen: false)
                                            .themeMode ==
                                        ThemeMode.light
                                    ? Color.fromARGB(255, 50, 49, 49)
                                    : Color.fromARGB(255, 133, 128, 128),
                              ),
                            ]),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}

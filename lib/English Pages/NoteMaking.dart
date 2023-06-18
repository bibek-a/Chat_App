// import 'dart:developer';
import 'package:chating_app/Constants/values.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:provider/provider.dart';

class NoteMaking extends StatefulWidget {
  // final index;
  const NoteMaking({Key? key}) : super(key: key);

  @override
  State<NoteMaking> createState() => _NoteMakingState();
}

class _NoteMakingState extends State<NoteMaking> {
  // bool __nightMode = false;
  // int __lastPage = 2;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Provider.of<themeProvider>(context, listen: false).themeMode ==
                    ThemeMode.light
                ? Colors.blue[200]
                : Colors.black,
        appBar: AppBar(
          // backgroundColor: Colors.blue[200],
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
                alignment: Alignment.center,
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
                      ? Colors.white
                      : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      spreadRadius: -7,
                      offset: Offset(5, 5),
                      blurRadius: 20,
                    )
                  ],
                )),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  //
                },
                child: Icon(
                  Icons.download,
                  color: Provider.of<themeProvider>(context, listen: false)
                              .themeMode ==
                          ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                ))
          ],
        ),
        body: Container(
          // color: Colors.red,
          child: PDF(
            nightMode:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.dark
                    ? true
                    : false,
            enableSwipe: true,
            pageSnap: true,
            fitPolicy: FitPolicy.BOTH,
            // defaultPage: Values.getValue(),
            // swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
            onPageChanged: (var page, var total) {
              Values.setValue(page!);
              print('page change: $page/$total');
            },
          ).fromAsset('assests/NoteMaking.pdf'),
        ),
      ),
    );
  }
}

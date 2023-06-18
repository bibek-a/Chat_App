// import 'dart:developer';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:provider/provider.dart';

class ReadPDFPage extends StatefulWidget {
  final index;
  const ReadPDFPage({Key? key, required this.index}) : super(key: key);

  @override
  State<ReadPDFPage> createState() => _ReadPDFPageState();
}

class _ReadPDFPageState extends State<ReadPDFPage> {
  // bool __nightMode = false;
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
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 2, 2, 2)
                        : Color.fromARGB(255, 188, 182, 182),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Provider.of<themeProvider>(context, listen: false)
                              .themeMode ==
                          ThemeMode.light
                      ? Color.fromARGB(255, 132, 186, 230)
                      : Color.fromARGB(255, 0, 0, 0),
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
                  // // __nightMode = false;
                  // log(__nightMode.toString());
                  // setState(() {
                  //   __nightMode = __nightMode == true ? false : true;
                  // });
                },
                child: Icon(
                  Icons.download,
                  color: Colors.black,
                ))
          ],
        ),
        body: Container(
          child: PDF(
            // nightMode: true,
            // fitPolicy: FitPolicy.HEIGHT,
            enableSwipe: true,
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
              print('page change: $page/$total');
            },
          ).fromAsset('assests/proposal.pdf'),
        ),
      ),
    );
  }
}

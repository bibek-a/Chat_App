import 'dart:convert';

import 'package:chating_app/Providers/theme_provider.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FormalContentPage extends StatefulWidget {
  final int index;
  const FormalContentPage({Key? key, required this.index}) : super(key: key);

  @override
  State<FormalContentPage> createState() => _FormalContentPageState();
}

late WebViewController __controller;

class _FormalContentPageState extends State<FormalContentPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 104, 103, 103)
              : Color.fromARGB(255, 144, 202, 249),
      // statusBarBrightness: Brightness.dark,
    ));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 164, 214, 255),
        appBar: AppBar(
          elevation: 20,
          backgroundColor: Color.fromARGB(255, 144, 202, 249),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.black,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 139, 197, 244),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.9),
                        spreadRadius: -7,
                        offset: Offset(8, 5),
                        blurRadius: 20,
                      )
                    ],
                  )),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(3.0),
          child: WebView(
            // backgroundColor: Colors.blue[200],
            initialUrl: "about:blank",
            onWebViewCreated: (controller) async {
              __controller = controller;
              await _loadHTML();
            },
          ),
        ),
      ),
    );
  }

  _loadHTML() async {
    String fileText = await rootBundle
        .loadString("assests/formalwebtext${widget.index}.html");
    __controller.loadUrl(
      Uri.dataFromString(fileText,
              mimeType: "text/html", encoding: Encoding.getByName("utf-8"))
          .toString(),
    );
  }
}

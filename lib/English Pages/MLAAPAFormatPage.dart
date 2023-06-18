import 'dart:convert';

import 'package:chating_app/Providers/theme_provider.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MLAAPAFormatPage extends StatefulWidget {
  // final int index;
  const MLAAPAFormatPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MLAAPAFormatPage> createState() => _MLAAPAFormatPageState();
}

late WebViewController __controller;

class _MLAAPAFormatPageState extends State<MLAAPAFormatPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 0, 0, 0)
              : Color.fromARGB(255, 144, 202, 249),
      // statusBarBrightness: Brightness.dark,
    ));
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Provider.of<themeProvider>(context, listen: false).themeMode ==
                    ThemeMode.light
                ? Colors.blue[200]
                : Colors.black,
        appBar: AppBar(
          elevation: 10,
          backgroundColor:
              Provider.of<themeProvider>(context, listen: false).themeMode ==
                      ThemeMode.light
                  ? Colors.blue[200]
                  : Colors.black,
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
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.light
                        ? Color.fromARGB(255, 132, 186, 230)
                        : Color.fromARGB(255, 182, 181, 181),
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
            backgroundColor:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.light
                    ? Colors.blue[200]
                    : Color.fromARGB(255, 182, 181, 181),
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
    String fileText =
        await rootBundle.loadString("assests/MLAandAPAwebtext.html");
    __controller.loadUrl(
      Uri.dataFromString(fileText,
              mimeType: "text/html", encoding: Encoding.getByName("utf-8"))
          .toString(),
    );
  }
}

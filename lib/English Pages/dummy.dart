import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebText extends StatefulWidget {
  const WebText({Key? key}) : super(key: key);

  @override
  State<WebText> createState() => _WebTextState();
}

late WebViewController __controller;

class _WebTextState extends State<WebText> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[200],
        // appBar: AppBar(
        // leading: Padding(
        //   padding: const EdgeInsets.all(6.0),
        //   child: Container(
        //       alignment: Alignment.center,
        //       height: 50,
        //       width: 50,
        //       child: GestureDetector(
        //         onTap: () {
        //           Navigator.pop(context);
        //         },
        //         child: Icon(
        //           Icons.arrow_back_ios,
        //           size: 25,
        //           color: Colors.black,
        //         ),
        //       ),
        //       decoration: BoxDecoration(
        //         color: Color.fromARGB(255, 139, 197, 244),
        //         shape: BoxShape.circle,
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.black.withOpacity(0.7),
        //             spreadRadius: -7,
        //             offset: Offset(5, 5),
        //             blurRadius: 20,
        //           )
        //         ],
        //       )),
        // ),
        // ),
        body: WebView(
          initialUrl: "about:blank",
          onWebViewCreated: (controller) async {
            __controller = controller;
            await _loadHTML();
          },
        ),
      ),
    );
  }

  _loadHTML() async {
    String fileText = await rootBundle.loadString("assests/webtext.html");
    __controller.loadUrl(
      Uri.dataFromString(fileText,
              mimeType: "text/html", encoding: Encoding.getByName("utf-8"))
          .toString(),
    );
  }
}

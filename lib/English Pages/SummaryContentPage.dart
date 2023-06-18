import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Constants/Title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import '../Providers/theme_provider.dart';

class SummaryContentPage extends StatefulWidget {
  final index;
  const SummaryContentPage({Key? key, required this.index}) : super(key: key);

  @override
  State<SummaryContentPage> createState() => _SummaryContentPageState();
}

class _SummaryContentPageState extends State<SummaryContentPage> {
  String __textFromFile = "You havenot opened any story yet";
  getStory(index) async {
    var value = index + 1;
    var response;
    response = await rootBundle.loadString("assests/$value.txt");
    setState(() {
      __textFromFile = response;
    });
  }

  // String __contentText = "Content is here";
  // getContent(index) async {
  //   var value = index + 1;
  //   var response = await rootBundle.loadString("assests/English/$value.pdf");
  //   setState(() {
  //     textFromFile = response;
  //   });
  // }

  @override
  void initState() {
    widget.index != -1 ? getStory(widget.index) : null;
    // getContent(widget.index);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // brightness: Brightness.dark,
      ),
      home: Scaffold(
        backgroundColor:
            Provider.of<themeProvider>(context, listen: false).themeMode ==
                    ThemeMode.light
                ? Colors.blue[200]
                : Colors.black,
        appBar: AppBar(
          elevation: 10,
          shadowColor: Color.fromARGB(255, 144, 40, 2),
          title: Book_Title.getTitle(widget.index, context),
          centerTitle: true,
          backgroundColor:
              Provider.of<themeProvider>(context, listen: false).themeMode ==
                      ThemeMode.light
                  ? Colors.blue[200]
                  : Colors.black,
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
                      ? Color.fromARGB(255, 132, 186, 230)
                      : Color.fromARGB(255, 161, 158, 158),
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
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                Book_Title.getAuthor(widget.index, context),
                Container(
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: Colors.yellow,
                      selectionColor: Colors.green,
                    ),
                    child: SelectableText(
                      __textFromFile,

                      toolbarOptions: ToolbarOptions(
                        copy: true,
                        selectAll: true,
                      ),
                      showCursor: true,
                      cursorWidth: 1.3,
                      cursorHeight: 8,

                      // maxLines: 1,
                      style: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.light
                          ? MeroStyle.getStyle(width / 20)
                          : TextStyle(
                              color: Color.fromARGB(255, 175, 174, 174),
                              fontSize: width / 20),
                      textAlign: TextAlign.justify,
                      // softWrap: false,
                      // textScaleFactor: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


  // routes: {
  //       "/": (_) => new WebviewScaffold(
  //             url:
  //                 "https://www.thefreshreads.com/the-mother-of-a-traitor-ContentPage/",
  //             appBar: new AppBar(
  //               backgroundColor: Colors.black,
  //               leading: IconButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 icon: Icon(Icons.arrow_back),
  //                 color: Colors.white,
  //               ),
  //               title: new Text("Mother of Traitor"),
  //               centerTitle: true,
  //             ),
  //           ),
  //     },
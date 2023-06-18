import 'package:chating_app/Constants/Style.dart';
// import 'package:chating_app/Constants/Title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ContentPage extends StatefulWidget {
  final index;
  const ContentPage({Key? key, required this.index}) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  //
  String __textFromFile = "You havenot opened any Page yet";
  //
  String _title = "";
  //
  getStory(index) async {
    var value = index;
    var response;
    response = await rootBundle.loadString("assests/english/$value.txt");
    setState(() {
      __textFromFile = response;
    });

    switch (index - 1) {
      case 0:
        _title = "Question Sets";
        break;
      case 1:
        _title = "Note Making";
        break;
      case 2:
        _title = "Interpretion";
        break;
      case 3:
        _title = "Editing";
        break;
      default:
        _title = "Formal Writing";
    }
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
    getStory(widget.index);
    // getContent(widget.index);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // brightness: Brightness.dark,
      ),
      home: Scaffold(
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
          elevation: 10,
          shadowColor: Color.fromARGB(255, 144, 40, 2),
          title: Text(
            _title,
            style: MeroStyle.getStyle(24),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[200],
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
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
                  color: Color.fromARGB(255, 139, 197, 244),
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
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              // alignment: Alignment.center,
              child: TextSelectionTheme(
                data: TextSelectionThemeData(
                  cursorColor: Color.fromARGB(255, 200, 182, 14),
                  selectionColor: Colors.green,
                  // selectionHandleColor: Colors.yellow,
                ),
                child: SelectableText(
                  __textFromFile,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    selectAll: true,
                    paste: true,
                    cut: true,
                  ),
                  showCursor: true,
                  cursorWidth: 1.2,
                  cursorHeight: 8,

                  // maxLines: 1,
                  style: MeroStyle.getStyle(20),
                  textAlign: TextAlign.justify,
                  // softWrap: false,
                  // textScaleFactor: 1,
                  textDirection: TextDirection.ltr,
                ),
              ),
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
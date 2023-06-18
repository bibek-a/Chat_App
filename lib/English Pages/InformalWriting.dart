import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/English%20Pages/InformalContentPage.dart';
// import 'package:chating_app/English%20Pages/dummy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'FormalWritingPage.dart';
// import 'NoticeWritingPage.dart';

class InformalWritingPage extends StatefulWidget {
  const InformalWritingPage({Key? key}) : super(key: key);

  @override
  State<InformalWritingPage> createState() => _InformalWritingPageState();
}

class _InformalWritingPageState extends State<InformalWritingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                      color: Colors.blue[200],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.9),
                          spreadRadius: -5,
                          offset: Offset(5, 5),
                          blurRadius: 20,
                        )
                      ],
                    )),
              ),
              SizedBox(height: 50),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 139, 197, 244),
                  borderRadius: BorderRadius.circular(30),
                  // shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.9),
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
                      return InformalContentPage(
                        index: 1,
                      );
                    }));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("1.", style: MeroStyle.getStyle(24)),
                      SizedBox(width: 10),
                      Text("Notice Writing", style: MeroStyle.getStyle(24))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 139, 197, 244),
                  borderRadius: BorderRadius.circular(30),
                  // shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.9),
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
                      return InformalContentPage(
                        index: 2,
                      );
                    }));
                  },
                  child: Row(children: [
                    Text("2.", style: MeroStyle.getStyle(24)),
                    SizedBox(width: 10),
                    Text("Minute Writing", style: MeroStyle.getStyle(24))
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

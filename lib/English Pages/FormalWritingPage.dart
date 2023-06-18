import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/English%20Pages/FormalContentPage.dart';
// import 'package:chating_app/English%20Pages/InformalContentPage.dart';
// import 'package:chating_app/English%20Pages/dummy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'FormalWritingPage.dart';
// import 'NoticeWritingPage.dart';

class FormalWritingPage extends StatefulWidget {
  const FormalWritingPage({Key? key}) : super(key: key);

  @override
  State<FormalWritingPage> createState() => _FormalWritingPageState();
}

class _FormalWritingPageState extends State<FormalWritingPage> {
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
              GestureDetector(
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
                        color: Colors.blue[200],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.9),
                            spreadRadius: -5,
                            offset: Offset(5, 5),
                            blurRadius: 15,
                          )
                        ],
                      )),
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
                      return FormalContentPage(
                        index: 1,
                      );
                    }));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("1.", style: MeroStyle.getStyle(24)),
                      SizedBox(width: 10),
                      Text("Cover Page", style: MeroStyle.getStyle(24))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                      return FormalContentPage(
                        index: 2,
                      );
                    }));
                  },
                  child: Row(children: [
                    Text("2.", style: MeroStyle.getStyle(24)),
                    SizedBox(width: 10),
                    Text("Title Page", style: MeroStyle.getStyle(24))
                  ]),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 139, 197, 244),
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
                      return FormalContentPage(
                        index: 3,
                      );
                    }));
                  },
                  child: Row(children: [
                    Text("3.", style: MeroStyle.getStyle(24)),
                    SizedBox(width: 10),
                    Text("Letter of Transmittal", style: MeroStyle.getStyle(24))
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

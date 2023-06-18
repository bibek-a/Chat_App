import "package:flutter/material.dart";

import 'Constants/Style.dart';

class AboutUs extends StatefulWidget {
  // const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black, size: 33),
        backgroundColor: Colors.blue[200],
        leading: Padding(
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
                shape: BoxShape.circle,
                color: Colors.blue[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    spreadRadius: -5,
                    offset: Offset(-5, -5),
                    blurRadius: 30,
                  )
                ],
              )),
        ),
        title: Text("AboutUs", style: MeroStyle.getStyle(26)),
        centerTitle: true,
      ),
    );
  }
}

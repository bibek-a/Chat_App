import 'package:chating_app/Constants/Style.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  // const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black, size: 33),
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
                color: Colors.blue[200],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: -5,
                    offset: Offset(-5, -5),
                    blurRadius: 30,
                  )
                ],
              )),
        ),
        backgroundColor: Colors.blue[200],
        title: Text("Settings", style: MeroStyle.getStyle(26)),
        centerTitle: true,
      ),
    );
  }
}

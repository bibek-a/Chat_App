import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Game%20Pages/GamePage.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({Key? key}) : super(key: key);

  @override
  _GaState createState() => _GaState();
}

class _GaState extends State<OptionPage> {
  var username1;
  var username2;
  var notice = "";
  var about = "";
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 26, 26, 26)
              : Colors.blue[200],
      // statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
        backgroundColor:
            Provider.of<themeProvider>(context, listen: false).themeMode ==
                    ThemeMode.light
                ? Colors.blue[200]
                : Color.fromARGB(255, 20, 19, 19),
        appBar: AppBar(
          elevation: 10,
          shadowColor: Color.fromARGB(255, 91, 35, 15),
          backgroundColor:
              Provider.of<themeProvider>(context, listen: false).themeMode ==
                      ThemeMode.light
                  ? Colors.blue[200]
                  : Color.fromARGB(255, 20, 19, 19),
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
                  color: Colors.blue[200],
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
          iconTheme: IconThemeData(color: Colors.black, size: 22),
          title: Text(
            "Tic Tac Toe",
            style:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.light
                    ? MeroStyle.getStyle(25)
                    : MeroStyle.getStyle2(25),
          ),
          centerTitle: true,
        ),
        body: Align(
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  Text(notice,
                      style: TextStyle(fontSize: 20, color: Colors.red)),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          username1 = val;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "First Player",
                          hintText: "Enter the first Player name",
                          labelStyle:
                              Provider.of<themeProvider>(context, listen: false)
                                          .themeMode ==
                                      ThemeMode.dark
                                  ? MeroStyle.getStyle2(20)
                                  : MeroStyle.getStyle(20),
                          fillColor:
                              Provider.of<themeProvider>(context, listen: false)
                                          .themeMode ==
                                      ThemeMode.light
                                  ? Colors.blue[200]
                                  : Colors.black,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Provider.of<themeProvider>(context,
                                            listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                          ),
                          filled: true),
                      keyboardType: TextInputType.name,
                      obscureText: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      onChanged: (val) {
                        username2 = val;
                      },
                      decoration: InputDecoration(
                          labelText: "Second Player",
                          hintText: "Enter the Second Player name",
                          labelStyle:
                              Provider.of<themeProvider>(context, listen: false)
                                          .themeMode ==
                                      ThemeMode.dark
                                  ? MeroStyle.getStyle2(20)
                                  : MeroStyle.getStyle(20),
                          fillColor:
                              Provider.of<themeProvider>(context, listen: false)
                                          .themeMode ==
                                      ThemeMode.light
                                  ? Colors.blue[200]
                                  : Colors.black,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Provider.of<themeProvider>(context,
                                            listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                          ),
                          filled: true),
                      keyboardType: TextInputType.name,
                      obscureText: false,
                    ),
                  ),
                  SizedBox(height: 50),
                  CupertinoButton(
                    borderRadius: BorderRadius.circular(20),
                    color: Provider.of<themeProvider>(context, listen: false)
                                .themeMode ==
                            ThemeMode.dark
                        ? Colors.black
                        : Color.fromARGB(255, 58, 119, 169),
                    onPressed: () {
                      setState(() {
                        if (username1 == null || username2 == null) {
                          notice = "Please fill your name first";
                        } else {
                          about =
                              "$username1 will play as Cross and $username2 will play as Circle";
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GamePage(
                                      username1: username1,
                                      username2: username2)));
                        }
                      });
                    },
                    child: Text(
                      "Start Game",
                      style: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? MeroStyle.getStyle2(20)
                          : MeroStyle.getStyle(20),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

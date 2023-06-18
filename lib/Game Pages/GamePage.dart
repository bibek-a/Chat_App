import 'dart:developer';
import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Models/UIHelper.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class GamePage extends StatefulWidget {
  var username1;
  var username2;
  GamePage({this.username1, this.username2});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> gameState = [
    "Empty",
    "Empty",
    "Empty",
    "Empty",
    "Empty",
    "Empty",
    "Empty",
    "Empty",
    "Empty"
  ];

  var Cancel =
      Center(child: Icon(Icons.cancel, size: 110, color: Colors.black));
  var Circle =
      Center(child: Icon(Icons.circle, size: 110, color: Colors.white));
  var ButtonNAME = "Reset Game";
  bool isCross = true;
  var message = "Lets Play";
  var count = 0;
  var isPressed = 0;

  // AssetsAudioPlayer player = AssetsAudioPlayer();

  playGame(int index) {
    isPressed = 100;
    if (ButtonNAME == "Next Game") {
      ButtonNAME == "Reset Game";
    } else {
      message = "Turn for ${widget.username1}";
      if (gameState[index] == "Empty") {
        // player.open(Audio("music/audio2.wav"));

        if (isCross) {
          gameState[index] = "Cancel";
          count++;
          count != 9 ? message = "Turn for ${widget.username2}" : message = "";
        } else {
          gameState[index] = "Circle";
          count++;
          count != 9 ? message = "Turn for ${widget.username1}" : message = "";
        }
        checkForWin();
        isCross = !isCross;
      }
      setState(() {});
    }
  }

  void checkForWin() {
    // setState(() {});
    if (gameState[0] != "Empty" &&
        gameState[0] == gameState[1] &&
        gameState[1] == gameState[2]) {
      gameState[1] == "Cancel"
          ? message = "Congratulation ${widget.username1} won the game"
          : message = "Congratulation ${widget.username2} won the game";
      UIHelper.showAlertDialog(context, "🎂💐🌸🌷🍺🍺", message.toString());
      // player.open(Audio("music/audio.wav"));
      ButtonNAME = "Next Game";
    } else if (gameState[3] != "Empty" &&
        gameState[3] == gameState[4] &&
        gameState[4] == gameState[5]) {
      gameState[4] == "Cancel"
          ? message = "Congratulation ${widget.username1} won the game"
          : message = "Congratulation ${widget.username2} won the game";
      UIHelper.showAlertDialog(context, "🎂🍺💐🌸🎂🌷🍺", message.toString());
      ButtonNAME = "Next Game";
      // player.open(Audio("music/audio.wav"));
    } else if (gameState[6] != "Empty" &&
        gameState[6] == gameState[7] &&
        gameState[7] == gameState[8]) {
      gameState[7] == "Cancel"
          ? message = "Congratulation ${widget.username1} won the game"
          : message = "Congratulation ${widget.username2} won the game";
      ButtonNAME = "Next Game";
      UIHelper.showAlertDialog(context, "🎂🍺💐🌸🎂🌷🍺", message.toString());
      // player.open(Audio("music/audio.wav"));
    } else if (gameState[0] != "Empty" &&
        gameState[0] == gameState[3] &&
        gameState[3] == gameState[6]) {
      gameState[3] == "Cancel"
          ? message = "Congratulation ${widget.username1} won the game"
          : message = "Congratulation ${widget.username2} won the game";
      ButtonNAME = "Next Game";
      UIHelper.showAlertDialog(context, "🎂🍺💐🌸🎂🌷🍺", message.toString());
      // player.open(Audio("music/audio.wav"));
    } else if (gameState[1] != "Empty" &&
        gameState[1] == gameState[4] &&
        gameState[4] == gameState[7]) {
      gameState[4] == "Cancel"
          ? message = "Congratulation ${widget.username1} won the game"
          : message = "Congratulation ${widget.username2} won the game";
      ButtonNAME = "Next Game";
      UIHelper.showAlertDialog(context, "🎂🍺💐🌸🎂🌷🍺", message.toString());
      // player.open(Audio("music/audio.wav"));
    } else if (gameState[2] != "Empty" &&
        gameState[2] == gameState[5] &&
        gameState[5] == gameState[8]) {
      gameState[2] == "Cancel"
          ? message = "Congratulation ${widget.username1} won the game"
          : message = "Congratulation ${widget.username2} won the game";
      ButtonNAME = "Next Game";
      UIHelper.showAlertDialog(context, "🎂🍺💐🌸🎂🌷🍺", message.toString());
      // player.open(Audio("music/audio.wav"));
    } else if (gameState[0] != "Empty" &&
        gameState[0] == gameState[4] &&
        gameState[4] == gameState[8]) {
      gameState[4] == "Cancel"
          ? message = "Congratulation ${widget.username1} won the game"
          : message = "Congratulation ${widget.username2} won the game";
      ButtonNAME = "Next Game";
      UIHelper.showAlertDialog(context, "🎂🍺💐🌸🎂🌷🍺", message.toString());
      // player.open(Audio("music/audio.wav"));
    } else if (gameState[2] != "Empty" &&
        gameState[2] == gameState[4] &&
        gameState[4] == gameState[6]) {
      gameState[4] == "Cancel"
          ? message = "Congratulation ${widget.username1} won the game"
          : message = "Congratulation ${widget.username2} won the game";
      ButtonNAME = "Next Game";
      UIHelper.showAlertDialog(context, "🎂🍺💐🌸🎂🌷🍺", message.toString());
      // player.open(Audio("music/audio.wav"));
    } else if (!gameState.contains("Empty")) {
      message = "Noone won the game";
      ButtonNAME = "Next Game";
      UIHelper.showAlertDialog(context, "Oops !", message.toString());
    }
  }

  getIcon(int index) {
    switch (gameState[index]) {
      case ("Cancel"):
        return Cancel;

      case ("Circle"):
        return Circle;

      case ("Empty"):
        return null;
    }
  }

  void resetGame() {
    setState(() {
      // player.open(Audio("music/audio.wav"));
      gameState = List.filled(9, "Empty");
      isCross = true;
      if (this.ButtonNAME == "Next Game") {
        this.ButtonNAME = "Reset Game";
      }
      count = 0;
      isPressed = 0;
      message = "Turn for ${widget.username1}";
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    log("$height");
    return Scaffold(
      backgroundColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.light
              ? Colors.blue[200]
              : Color.fromARGB(255, 0, 0, 0),
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
        iconTheme: IconThemeData(color: Colors.black, size: 28),
        title: Text(
          message,
          style: Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.light
              ? MeroStyle.getStyle(25)
              : MeroStyle.getStyle2(25),
        ),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: height / 150, vertical: height / 30),
              //640
              child: Container(
                alignment: Alignment.center,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    // SizedBox(height: 10),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        // mainAxisSpacing: 0.1,
                        childAspectRatio: 0.9,
                        // crossAxisSpacing: 0
                      ),
                      itemCount: 9,
                      shrinkWrap: true,
                      itemBuilder: (contect, index) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: GestureDetector(
                          onTap: () {
                            playGame(index);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Provider.of<themeProvider>(context,
                                                listen: false)
                                            .themeMode ==
                                        ThemeMode.dark
                                    ? Color.fromARGB(255, 36, 35, 35)
                                    : Color.fromARGB(255, 59, 100, 133),
                                borderRadius: BorderRadius.circular(20)),
                            child: getIcon(index),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height / 20),
                    CupertinoButton(
                      borderRadius: BorderRadius.circular(15),
                      onPressed: resetGame,
                      child: Text(
                        ButtonNAME,
                        style:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.dark
                                ? MeroStyle.getStyle2(20)
                                : MeroStyle.getStyle(20),
                      ),
                      color: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? Color.fromARGB(255, 31, 30, 30)
                          : Color.fromARGB(255, 71, 133, 184),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                "You cannot play this game in Landscape mode, Please turn it to Portrait",
                style: MeroStyle.getStyle(28),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}

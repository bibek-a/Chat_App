import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UIHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    //
    AlertDialog loadingDialog = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
              // backgroundColor:
              //     Provider.of<themeProvider>(context, listen: false).themeMode ==
              //             ThemeMode.dark
              //         ? Colors.black
              //         : Colors.blue[200],
              ),
          SizedBox(height: 30),
          Text(title),
        ],
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        // barrierColor: Colors.blue[200],
        builder: (context) {
          return loadingDialog;
        });
  }

  static void showAlertDialog(
      BuildContext context, String title, String content) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Colors.black
              : Colors.blue[200],
      title: Text(title,
          style: Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? MeroStyle.getStyle2(24)
              : MeroStyle.getStyle(24)),
      content: Text(content,
          style: Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? MeroStyle.getStyle2(20)
              : MeroStyle.getStyle(20)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK",
              style: Provider.of<themeProvider>(context, listen: false)
                          .themeMode ==
                      ThemeMode.dark
                  ? MeroStyle.getStyle2(20)
                  : MeroStyle.getStyle(20)),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  static showAlertDialog1(BuildContext context, String title, String content) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Colors.black
              : Colors.blue[200],
      title: Text(title,
          style: Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? MeroStyle.getStyle2(20)
              : MeroStyle.getStyle(24)),
      content: Text(content,
          style: Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? MeroStyle.getStyle2(20)
              : MeroStyle.getStyle(18)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // final result = true;
          },
          child: Text("Yes",
              style: Provider.of<themeProvider>(context, listen: false)
                          .themeMode ==
                      ThemeMode.dark
                  ? MeroStyle.getStyle2(20)
                  : MeroStyle.getStyle(20)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            // final result = false;
          },
          child: Text("No",
              style: Provider.of<themeProvider>(context, listen: false)
                          .themeMode ==
                      ThemeMode.dark
                  ? MeroStyle.getStyle2(20)
                  : MeroStyle.getStyle(20)),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }
}

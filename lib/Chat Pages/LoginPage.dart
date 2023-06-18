import 'dart:developer';
import 'package:chating_app/Chat%20Pages/ForgetPassword.dart';
import 'package:chating_app/Chat%20Pages/SignUpPage.dart';
import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/FirstPage.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:chating_app/models/UIHelper.dart';
import 'package:chating_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
//
  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    //
    if (email == "" || password == "") {
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else {
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    //
    UserCredential? credential;
    UIHelper.showLoadingDialog(context, "Logging In....");
    //
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      UIHelper.showAlertDialog(
          context, "An error Ocurred", error.message.toString());
    }
    //
    if (credential != null) {
      String uid = credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);
      print("Log In Successfullly");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return FirstPage(
          userModel: userModel,
          firebaseUser: credential!.user!,
        );
      }));
    }
  }

  __forgetPressed() {
    log("hello world");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,

      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 0, 0, 0)
              : Colors.blue[200],
      // statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[200],
        title: Text(
          "Communication English",
          style: GoogleFonts.josefinSans(
            textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 29,
                letterSpacing: -0.9),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome",
                    style: GoogleFonts.pacifico(
                      textStyle: TextStyle(
                          color: Colors.blue[200],
                          fontWeight: FontWeight.w100,
                          fontSize: 30,
                          wordSpacing: 1,
                          letterSpacing: 0.4),
                    ),
                  ),
                  SizedBox(height: 50),
                  //
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: "Email Address",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1,
                        )),
                  ),
                  //
                  SizedBox(height: 10),
                  //
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle:
                            TextStyle(color: Colors.black, letterSpacing: 1)),
                  ),
                  //
                  SizedBox(height: 20),
                  //
                  CupertinoButton(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue[400],
                      child: Text(
                        "Login",
                        style: MeroStyle.getStyle(20),
                      ),
                      onPressed: () {
                        checkValues();
                      }),
                  //
                  SizedBox(height: 20),
                  //
                  CupertinoButton(
                    borderRadius: BorderRadius.circular(17),
                    color: Colors.blue[400],
                    onPressed: () {
                      // __forgetPressed();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ForgetPassword();
                      }));
                    },
                    child: Text(
                      "Forget Password ?",
                      style: MeroStyle.getStyle(19),
                    ),
                  )
                  //
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account?"),
            CupertinoButton(
              child: Text(
                "Sign Up",
                style: MeroStyle.getStyle(18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SignUpPage();
                  }),
                );
              },
            ),
            //
          ],
        ),
      ),
    );
  }
}


//
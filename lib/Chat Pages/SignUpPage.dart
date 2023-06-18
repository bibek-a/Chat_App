import 'dart:developer';
import 'package:chating_app/Chat%20Pages/CompleteProfile.dart';
import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Constants/map.dart';
// import 'package:chating_app/Constants/map.dart';
import 'package:chating_app/models/UIHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/UserModel.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  //
  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();
    //
    if (email == "" || password == "" || cPassword == "") {
      print("Please Fill the fields!");
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else if (password != cPassword) {
      print("Password donot match");
      UIHelper.showAlertDialog(context, "Password Missmatch",
          "The password you entered donot match");
    } else {
      signUp(email, password);
    }
  }

  //
  void signUp(String email, String password) async {
    UserCredential? credential;
    UIHelper.showLoadingDialog(context, "Creating new Account");
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      UIHelper.showAlertDialog(
          context, "An error Occured", error.message.toString());
      log(error.code.toString()); ///////printing error
    }
    //
    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: "",
        status: "online",
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap());
      //
      MyLocation.storeCurrentPosition(newUser.uid!);
      //
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompleteProfile(
            userModel: newUser,
            firebaseUser: credential!.user!,
          ),
        ),
      );
    }
  } //

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // _storeCurrentPosition();
  // }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text(
          "Communication English",
          style: MeroStyle.getStyle(25),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Center(
            child: SingleChildScrollView(
                child: Column(
              children: [
                //
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                  ),
                ),

                //
                SizedBox(height: 20),
                //
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                ),
                //
                SizedBox(height: 20),
                //
                TextField(
                  controller: cPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                  ),
                ),
                //
                SizedBox(height: 30),
                //
                CupertinoButton(
                    color: Colors.blue[300],
                    child: Text(
                      "Sign Up",
                      style: MeroStyle.getStyle(20),
                    ),
                    onPressed: () {
                      checkValues();
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return CompleteProfile();
                      // }));
                    }),
                //
              ],
            )),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Already have an account?"),
            CupertinoButton(
              child: Text(
                "Login",
                style: MeroStyle.getStyle(20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            //
          ],
        ),
      ),
    );
  }
}

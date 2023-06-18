// import 'dart:developer';
import 'package:chating_app/main.dart';
import 'package:chating_app/models/UIHelper.dart';
import 'package:chating_app/models/feedbackModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emoji_feedback/emoji_feedback.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'models/UserModel.dart';

class FeedbackSection extends StatefulWidget {
  final UserModel userModel;

  const FeedbackSection({Key? key, required this.userModel}) : super(key: key);

  @override
  State<FeedbackSection> createState() => _FeedbackSectionState();
}

class _FeedbackSectionState extends State<FeedbackSection> {
  String? feedback;
  String? emoji = "OK";
  String issue = "";
  List<bool> isChecked = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> issues = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 143, 202, 250),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_new),
                      iconSize: 30,
                    ),
                  ],
                ),
                Text(
                  "Feedback Section",
                  style: TextStyle(
                    color: Color.fromARGB(255, 6, 102, 181),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Calibri",
                    fontSize: 30,
                  ),
                  // SizedBox(height: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      8,
                      (index) => Row(
                        children: [
                          Checkbox(
                              value: isChecked[index],
                              onChanged: (val) {
                                print(index);
                                isChecked[index] =
                                    isChecked[index] == true ? false : true;

                                setState(() {});
                              }),
                          Builder(builder: (context) {
                            // String issues = "";
                            switch (index) {
                              case 0:
                                issue = "Login issue";
                                break;
                              case 1:
                                issue = "SignUp issue";
                                break;
                              case 2:
                                issue = "Chatroom issue";
                                break;
                              case 3:
                                issue = "Groupchat issue";
                                break;
                              case 4:
                                issue = "Chatroom issue";
                                break;
                              case 5:
                                issue = "Crypto issue";
                                break;
                              case 6:
                                issue = "Game issue";
                                break;
                              default:
                                issue = "Other issue";
                                break;
                            }
                            return Text(
                              issue,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 4, 65, 114),
                              ),
                            );
                          })
                        ],
                      ),
                    )),
                // SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    onChanged: (val) async {
                      feedback = val;
                      setState(() {});
                    },
                    // maxLength: ,
                    maxLines: 10,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: "So what you think about this app",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 113, 112, 112),
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 104, 171, 225),
                          )),
                    ),
                  ),
                ),
                // SizedBox(height: 10),
                Text(
                  "How was your experience with us?",
                  style: TextStyle(
                    color: Color.fromARGB(255, 4, 65, 114),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // EmojiFeedback(
                //   onChange: (index) {
                //     print("You have changed the emoji style");
                //     emoji = index.toString();
                //     setState(() {});
                //   },
                // ),
                SizedBox(height: 30),
                CupertinoButton(
                  child: Text(
                    "Send Feedback",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  color: Color.fromARGB(255, 13, 84, 143),
                  onPressed: () async {
                    FeedBack newFeedback = FeedBack(
                      message: feedback,
                      emoji: emoji,
                    );

                    if (feedback != null) {
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.userModel.uid)
                          .collection("feedbacks")
                          .doc(uuid.v1())
                          .set(newFeedback.toMap())
                          .then((value) =>
                              print("Successfully saved the feedback"));
                      UIHelper.showAlertDialog(context, "Success",
                          "Thank you for your valuable feedback");
                    } else {
                      UIHelper.showAlertDialog(context, "Error",
                          "Please write your feedback inside box");
                    }
                  },
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

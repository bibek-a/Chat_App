import 'dart:developer';
// import 'package:chating_app/Constants/Style.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  //
  TextEditingController __emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[200],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "Forget ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "calibri",
                  fontSize: 028,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "Password ? ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "calibri",
                  fontSize: 028,
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  CupertinoTextField(
                    controller: __emailController,
                    placeholder: "abc@gmail.com",
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CupertinoButton(
                  borderRadius: BorderRadius.circular(17),
                  color: Color.fromARGB(255, 37, 139, 221),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mail,
                        size: 30,
                        color: Color.fromARGB(255, 224, 96, 87),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Sent Mail",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    final Email send_email = Email(
                      body: 'body of email',
                      subject: 'subject of email',
                      recipients: ['example1@ex.com'],
                      cc: ['example_cc@ex.com'],
                      bcc: ['example_bcc@ex.com'],
                      attachmentPaths: ['/path/to/email_attachment.zip'],
                      isHTML: false,
                    );
                    await FlutterEmailSender.send(send_email);
                    log("email sent");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

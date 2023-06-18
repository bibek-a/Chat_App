import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Constants/map.dart';
import 'package:chating_app/English%20Pages/SyllabusPage.dart';
import 'package:chating_app/Game%20Pages/OptionPage.dart';
import 'package:chating_app/Group%20Chat/HomePage.dart';
import 'package:chating_app/Providers/chatRoom_provider.dart';
import 'package:chating_app/Providers/theme_provider.dart';
// import 'package:chating_app/Settings.dart';
// import 'package:chating_app/ShowImage.dart';
import 'package:chating_app/feedback.dart';
import 'package:chating_app/models/UIHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'AboutUs.dart';
import 'Chat Pages/HomePage.dart';
import 'Chat Pages/LoginPage.dart';
import 'Chat Pages/PhotoViewPage.dart';
import 'Crypto Pages/CryptoPage.dart';
import 'models/UserModel.dart';

class FirstPage extends StatefulWidget with WidgetsBindingObserver {
  final UserModel userModel;
  final User firebaseUser;
  const FirstPage({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    //
    log("Inside First Page");
    MyLocation.storeCurrentPosition(widget.userModel.uid!);
    //
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    Provider.of<ChatRoomProvider>(context, listen: false).checkInternet();
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  //
  //
  File? imageFile;
  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = (await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 10,
    ));
    //
//
    //
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
        checkValues();
      });
    } else {
      //
    }
  }

  void checkValues() {
    if (imageFile == null) {
      UIHelper.showAlertDialog(context, "Incomplete Data",
          "Please fill all the fields and upload a profile picture");
    } else {
      log("Uploading data..");
      uploadData();
    }
  }

  void uploadData() async {
    UIHelper.showLoadingDialog(context, "Uploading image..");

    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String? imageUrl = await snapshot.ref.getDownloadURL();

    widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log("Data uploaded!");
      Navigator.pop(context);
    });
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.light
                    ? Colors.blue[200]
                    : Color.fromARGB(255, 27, 24, 27),
            title: Text("Change Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a photo"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PhotoView(
                          userModel: widget.userModel,
                        );
                      },
                    ));
                  },
                  leading: Icon(Icons.image),
                  title: Text("View a profile picture"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ChatRoomProvider myProvider =
        Provider.of<ChatRoomProvider>(context, listen: false);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.light
              ? Brightness.dark
              : Brightness.light,
      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 0, 0, 0)
              : Color.fromARGB(255, 144, 202, 249),
      // statusBarBrightness: Brightness.dark,
    ));
    return SafeArea(
      child: Scaffold(
        // backgroundColor:
        //     Provider.of<themeProvider>(context, listen: false).themeMode ==
        //             ThemeMode.light
        //         ? Colors.blue[200]
        //         : Color.fromARGB(255, 12, 12, 12),
        body: WillPopScope(
          onWillPop: () async {
            var result = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // backgroundColor: Colors.blue[200],
                    title: Text("Confirm"),
                    content: Text(
                      "Do you want to close it?",
                      style: MeroStyle.getStyle(width / 18),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Yes",
                          style: MeroStyle.getStyle(width / 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          "No",
                          style: MeroStyle.getStyle(width / 18),
                        ),
                      )
                    ],
                  );
                });
            return Future.value(result); // it will not go back further
          },
          child: Container(
            decoration:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.light
                    ? BoxDecoration(
                        gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 115, 151, 188),
                          Color.fromARGB(255, 113, 167, 211),
                          Color.fromARGB(255, 139, 181, 223),
                          Color.fromARGB(255, 144, 202, 249)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                        // stops: [0, 1],
                      ))
                    : BoxDecoration(
                        color: Color.fromARGB(255, 12, 12, 12),
                      ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        return Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 50,
                            child: GestureDetector(
                              onTap: () {
                                Scaffold.of(context).openDrawer();
                              },
                              child: Icon(
                                Icons.menu,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Provider.of<themeProvider>(context,
                                              listen: false)
                                          .themeMode ==
                                      ThemeMode.dark
                                  ? Color.fromARGB(255, 158, 153, 153)
                                  : Color.fromARGB(255, 129, 186, 232),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Provider.of<themeProvider>(context,
                                                  listen: false)
                                              .themeMode ==
                                          ThemeMode.dark
                                      ? Color.fromARGB(255, 137, 166, 93)
                                      : Colors.black,
                                  spreadRadius: -7,
                                  offset: Offset(5, 5),
                                  blurRadius: 17,
                                )
                              ],
                            ));
                      }),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 50,
                            child: IconButton(
                              onPressed: () {
                                Provider.of<themeProvider>(context,
                                        listen: false)
                                    .toggleTheme();
                              },
                              icon: Provider.of<themeProvider>(context,
                                              listen: false)
                                          .themeMode ==
                                      ThemeMode.light
                                  ? Icon(Icons.dark_mode)
                                  : Icon(Icons.light_mode),
                              padding: EdgeInsets.all(0),
                              iconSize: 30,
                              color: Colors.black,
                            ),
                            decoration: BoxDecoration(
                              color: Provider.of<themeProvider>(context,
                                              listen: false)
                                          .themeMode ==
                                      ThemeMode.dark
                                  ? Color.fromARGB(255, 153, 149, 149)
                                  : Color.fromARGB(255, 129, 186, 232),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Provider.of<themeProvider>(context,
                                                  listen: false)
                                              .themeMode ==
                                          ThemeMode.dark
                                      ? Color.fromARGB(255, 155, 184, 111)
                                      : Colors.black,
                                  spreadRadius: -7,
                                  offset: Offset(-5, 5),
                                  blurRadius: 30,
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),

                        // gradient: LinearGradient(
                        //   colors:
                        //       Provider.of<themeProvider>(context, listen: false)
                        //                   .themeMode ==
                        //               ThemeMode.light
                        //           ? [
                        //               Color.fromARGB(255, 116, 176, 225),
                        //               Color.fromARGB(255, 112, 168, 225),
                        //               Color.fromARGB(255, 119, 174, 219),
                        //             ]
                        //           : [Color.fromARGB(255, 76, 74, 74)],

                        //   // stops: [0, 1],
                        // ),
                        color:
                            Provider.of<themeProvider>(context, listen: false)
                                        .themeMode ==
                                    ThemeMode.dark
                                ? Color.fromARGB(255, 160, 159, 159)
                                : Color.fromARGB(255, 127, 182, 228),

                        boxShadow: [
                          BoxShadow(
                            color: Provider.of<themeProvider>(context,
                                            listen: false)
                                        .themeMode ==
                                    ThemeMode.light
                                ? Colors.black.withOpacity(0.6)
                                : Color.fromARGB(255, 75, 58, 52),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              'Hello, ' +
                                  widget.userModel.fullname!.split(" ")[0] +
                                  " !!",
                              textStyle: Provider.of<themeProvider>(context,
                                              listen: false)
                                          .themeMode ==
                                      ThemeMode.dark
                                  ? MeroStyle.getStyle(width / 12.22)
                                  : MeroStyle.getStyle1(width / 12.22),
                              textAlign: TextAlign.center,
                              speed: const Duration(milliseconds: 30),
                            ),
                          ],
                          totalRepeatCount: 1000,
                          // pause: const Duration(milliseconds: 1000),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          // backgroundColor:
          //     Provider.of<themeProvider>(context, listen: false).themeMode ==
          //             ThemeMode.dark
          //         ? Colors.black
          //         : Colors.blue[200],
          child: Container(
            decoration:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.light
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        gradient: LinearGradient(
                          colors: [
                            // Color.fromARGB(255, 116, 176, 225),
                            // Color.fromARGB(255, 116, 176, 225),
                            Color.fromARGB(255, 126, 193, 249),
                            Color.fromARGB(255, 134, 192, 239),
                            Color.fromARGB(255, 138, 190, 243),
                            Color.fromARGB(255, 131, 179, 219)
                            // Color.fromARGB(255, 112, 168, 225),
                          ],
                          // begin: Alignment.bottomLeft,
                          // end: Alignment.topRight,

                          // stops: [0, 1],
                        ),
                      )
                    : BoxDecoration(
                        color: Colors.black,
                      ),
            child: ListView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(widget.userModel.fullname!,
                      style: MeroStyle.getStyle(width / 21.8)),
                  accountEmail: Text(widget.userModel.email!,
                      style: MeroStyle.getStyle(width / 26.18)),
                  currentAccountPicture: GestureDetector(
                    onTap: () {
                      myProvider.checkInternet();
                      log("${myProvider.hasInternet}");
                      if (myProvider.hasInternet) {
                        showPhotoOptions();
                      } else {
                        UIHelper.showAlertDialog(context, "An error Occured",
                            "Please Check Your Internet Connection");
                      }
                    },
                    child: CircleAvatar(
                      // radius: 20,
                      backgroundImage:
                          NetworkImage(widget.userModel.profilepic!),
                      backgroundColor:
                          Provider.of<themeProvider>(context, listen: false)
                                      .themeMode ==
                                  ThemeMode.dark
                              ? Colors.white70
                              : Colors.blue[200],
                    ),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assests/bgimage.jpg"),
                      opacity: 0.5,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  hoverColor: Colors.red,
                  title: Text("Syllabus",
                      style: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? MeroStyle.getStyle2(width / 19.6)
                          : MeroStyle.getStyle(width / 19.6)),
                  leading: Icon(Icons.library_books_outlined,
                      color: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      size: 28),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SyllabusPage();
                    }));
                  },
                ),
                ListTile(
                  title: Text("Chat",
                      style: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? MeroStyle.getStyle2(width / 19.6)
                          : MeroStyle.getStyle(width / 19.6)),
                  leading: Icon(CupertinoIcons.chat_bubble_fill,
                      color: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      size: 28),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return HomePage(
                        userModel: widget.userModel,
                        firebaseUser: widget.firebaseUser,
                      );
                    }));
                  },
                ),
                ListTile(
                  title: Text("Group Chat",
                      style: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? MeroStyle.getStyle2(width / 19.6)
                          : MeroStyle.getStyle(width / 19.6)),
                  leading: Icon(Icons.group,
                      color: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      size: 28),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return GroupChatHomeScreen(
                        userModel: widget.userModel,
                      );
                    }));
                  },
                ),
                ListTile(
                  title: Text("Game",
                      style: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? MeroStyle.getStyle2(width / 19.6)
                          : MeroStyle.getStyle(width / 19.6)),
                  leading: Icon(Icons.videogame_asset,
                      color: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      size: 28),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return OptionPage();
                    }));
                  },
                ),
                ListTile(
                  title: Text("Crypto Nepal",
                      style: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? MeroStyle.getStyle2(width / 19.6)
                          : MeroStyle.getStyle(width / 19.6)),
                  leading: Icon(Icons.monetization_on,
                      color: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      size: 28),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CryptoPage();
                    }));
                  },
                ),
                ListTile(
                  title: Text("Feedback",
                      style: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? MeroStyle.getStyle2(width / 19.6)
                          : MeroStyle.getStyle(width / 19.6)),
                  leading: Icon(Icons.feedback,
                      color: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      size: 28),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FeedbackSection(
                        userModel: widget.userModel,
                      );
                    }));
                  },
                ),
                ListTile(
                  title: Text("About Us",
                      style: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? MeroStyle.getStyle2(width / 19.6)
                          : MeroStyle.getStyle(width / 19.6)),
                  leading: Icon(Icons.info,
                      color: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      size: 28),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AboutUs();
                    }));
                  },
                ),
                ListTile(
                  title: Text("Sign Out",
                      style: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? MeroStyle.getStyle2(width / 19.6)
                          : MeroStyle.getStyle(width / 19.6)),
                  leading: Icon(Icons.logout,
                      color: Provider.of<themeProvider>(context, listen: false)
                                  .themeMode ==
                              ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      size: 28),
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Confirm",
                              style: MeroStyle.getStyle(width / 18),
                            ),
                            content: Text(
                              "Do you really want to sign out ?",
                              style: MeroStyle.getStyle(width / 19.6),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return LoginPage();
                                  }));
                                },
                                child: Text(
                                  "Yes",
                                  style: MeroStyle.getStyle(width / 18),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No",
                                    style: MeroStyle.getStyle(width / 18)),
                              )
                            ],
                          );
                        });
                  },
                ),
                new Divider(
                  thickness: 1,
                  color: Provider.of<themeProvider>(context, listen: false)
                              .themeMode ==
                          ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                  indent: 10,
                  endIndent: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

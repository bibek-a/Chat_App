import 'dart:developer';
// import 'dart:html';
import 'dart:io';
import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Constants/map.dart';
import 'package:chating_app/Models/UIHelper.dart';
import 'package:chating_app/Providers/chatRoom_provider.dart';
import 'package:chating_app/Providers/theme_provider.dart';
// import 'package:chating_app/ShowImage.dart';
// import 'package:chating_app/models/ChatRoomModel.dart';
// import 'package:chating_app/models/FirebaseHelper.dart';
import 'package:chating_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'PhotoViewPage.dart';

class MyProfilePage extends StatefulWidget {
  final UserModel userModel;
  final User FirebaseUser;
  const MyProfilePage({
    Key? key,
    required this.userModel,
    required this.FirebaseUser,
  }) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  //
  File? imageFile;
  // final lat = 0;
  // final long = 0;
  //
  _findFriends() {
    for (var index = 0; index < FriendsList.length; index++) {
      // UserModel? targetUser = FriendsList.elementAt(index);
      // String fullname = (targetUser.fullname!);
      // String email = (targetUser.fullname!);
    }
  }

  @override
  void initState() {
    super.initState();
    _findFriends();
  }

  // List<UserModel>? FriendsList = [];

  //
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
    UploadTask? uploadTask;
    UIHelper.showLoadingDialog(context, "Uploading image..");
    try {
      uploadTask = FirebaseStorage.instance
          .ref("profilepictures")
          .child(widget.userModel.uid.toString())
          .putFile(imageFile!);
    } on FirebaseException catch (error) {
      Navigator.pop(context);
      UIHelper.showAlertDialog(
          context, "An error Ocurred", error.message.toString());
    }
    if (uploadTask != null) {
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
    } else {}
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.dark
                    ? Colors.black
                    : Colors.blue[200],
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
                  title: Text("View profile picture"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    ChatRoomProvider myProvider =
        Provider.of<ChatRoomProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
          elevation: 10,
          shadowColor: Color.fromARGB(255, 91, 35, 15),
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
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.blue[200],
          title: Text(
            "My Profile",
            style: MeroStyle.getStyle(26),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 0005),
              CupertinoButton(
                onPressed: () {
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
                  radius: width / 5,
                  backgroundImage: NetworkImage(widget.userModel.profilepic!),
                ),
              ),
              SizedBox(height: 00005),
              Text(widget.userModel.fullname!,
                  style: MeroStyle.getStyle(width / 17)),
              SizedBox(height: 0005),
              Text(widget.userModel.email!,
                  style: MeroStyle.getStyle(width / 20)),
              SizedBox(height: 10),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 20),
                child: Row(
                  children: [
                    Text(
                      "Friends :",
                      style: MeroStyle.getStyle(width / 13),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      shrinkWrap: true,
                      itemCount: FriendsList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            radius: width / 17,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                                FriendsList.elementAt(index).profilepic!),
                          ),
                          title: Text(
                            FriendsList.elementAt(index).fullname.toString(),
                            style: MeroStyle.getStyle(width / 18),
                          ),
                          subtitle: Text(
                            FriendsList.elementAt(index).email.toString(),
                            style: MeroStyle.getStyle(width / 20),
                          ),
                          trailing: Text(
                            FriendsList.elementAt(index).status!,
                            style:
                                FriendsList.elementAt(index).status == "Offline"
                                    ? MeroStyle.getStyle(width / 30)
                                    : TextStyle(
                                        color: Color.fromARGB(255, 3, 95, 6)),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

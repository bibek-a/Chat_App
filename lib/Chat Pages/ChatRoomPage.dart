// import 'dart:async';
import 'dart:async';
import 'dart:developer';
// import 'dart:html';
import 'dart:io';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:chating_app/Constants/Date.dart';
import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Providers/chatRoom_provider.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:chating_app/ShowImage.dart';
import 'package:chating_app/main.dart';
import 'package:chating_app/models/ChatRoomModel.dart';
import 'package:chating_app/models/MessageModel.dart';
import 'package:chating_app/models/UIHelper.dart';
import 'package:chating_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import "package:intl/intl.dart";

class ChatRoomPage extends StatefulWidget {
  //
  final UserModel targetUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User? firebaseUser;
  //
  const ChatRoomPage({
    Key? key,
    required this.targetUser,
    required this.chatRoom,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  bool isAnimated = false;
  double __opacityValue = 1.0;
  Future<void> __handleRefresh() async {
    // setState(() {});
    return await Future.delayed(
      Duration(milliseconds: 700),
    );
  }

  //
  TextEditingController messageController = TextEditingController();
  //
  // bool isSeenerAppeared = false;

  // DateTime? previousMsgDate;
  // String? haha;

  void sendMessage() async {
    //
    String msg = messageController.text.trim();
    messageController.clear();

    //
    String messageid = uuid.v1();
    //
    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageid: messageid,
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
        msgType: "txt",
        ImageFile: "",
      );
      //

      // widget.chatRoom.lastMessageId = messageid;
      // widget.chatRoom.lastCreation = DateTime.now();
      widget.chatRoom.createdon = DateTime.now();
      widget.chatRoom.messageids!.add(messageid);
      widget.chatRoom.lastSender = widget.userModel.uid;
      widget.chatRoom.isLastMsgSeen = false;
      widget.chatRoom.lastMessage = msg;
      widget.chatRoom.lastSenderFullname = widget.userModel.fullname!;
//
      log("messege ids are " + widget.chatRoom.messageids.toString());

      //
      //
      try {
        log("it is trying");
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoom.chatroomid)
            .collection("messages")
            .doc(newMessage.messageid)
            .set(newMessage.toMap());
      } catch (error) {
        log(error.toString());
      }
      //

      // widget.chatRoom.messageids?.clear();
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomid)
          .set(widget.chatRoom.toMap());

      log("Message Sent");
      // previousMsgDate = DateTime.now();
    }
  }

  File? imageFile;

  showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 160, 186, 209),
            title: Text("Upload Picture"),
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
              ],
            ),
          );
        });
  }

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
      imageFile = File(croppedImage.path);
      checkValues();
    } else {
      //
    }
    log("image is cropped");
  }

  void checkValues() {
    if (imageFile == null) {
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please select an image");
    } else {
      log("Uploading data..");
      UploadImage(imageFile!);
    }
  }

  UploadImage(File image) async {
    UIHelper.showLoadingDialog(context, "Uploading image..");
    UploadTask? uploadTask;

    try {
      log("it is trying to upload the image file");
      uploadTask = FirebaseStorage.instance
          .ref("ChatImages")
          .child(widget.chatRoom.chatroomid!)
          .child(uuid.v1())
          .putFile(image);
    } catch (error) {
      log("error is caught during uploading og image in chat room");
      Navigator.pop(context);
      UIHelper.showAlertDialog(context, "An Error Ocuured", error.toString());
    }

    //

    String messageid = uuid.v1();
    //
    widget.chatRoom.lastMessage = "Sent a photo";
    widget.chatRoom.lastSender = widget.userModel.uid;
    widget.chatRoom.lastSenderFullname = widget.userModel.fullname!;
    widget.chatRoom.isLastMsgSeen = false;
    // widget.chatRoom.lastMessageId = messageid;
    widget.chatRoom.messageids!.add(messageid);
    widget.chatRoom.createdon = DateTime.now();
    //
    if (uploadTask != null) {
      TaskSnapshot snapshot = await uploadTask;

      String? imageUrl = await snapshot.ref.getDownloadURL();
      //
      log("image selected");
      //

      MessageModel newMessage = MessageModel(
        messageid: messageid,
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        seen: false,
        msgType: "image",
        ImageFile: imageUrl,
      );

      //

      //
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomid)
          .set(widget.chatRoom.toMap());
      log("ChatRoom UPdated");

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());
      log("Message Model Updated");

      Navigator.pop(context);
      log("image is uploaded");
    }
  }

  updateSeen() async {
    log("update seen is calling");
    if (FirebaseAuth.instance.currentUser!.uid == widget.chatRoom.lastSender) {
      log("Sent by this user");
      //
    } else {
      log("Sent by another user");

      var AllMessageIds = widget.chatRoom.messageids;
      log(AllMessageIds.toString());
      //
      //
      for (var eachmessageid in AllMessageIds!) {
        //
        if (eachmessageid != "") {
          FirebaseFirestore.instance
              .collection("chatrooms")
              .doc(widget.chatRoom.chatroomid)
              .collection("messages")
              .doc(eachmessageid)
              .update({"seen": true});
        }

        log("Seen Updated");
        widget.chatRoom.isLastMsgSeen = true;
        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoom.chatroomid)
            .set(widget.chatRoom.toMap());
      }

      widget.chatRoom.messageids!.clear();
      //
      // print(widget.chatRoom.chatroomid);
//

      //
    }
    // Timer(Duration(seconds: 1), () {
    //   updateSeen();
    // });
  }

  @override
  initState() {
    super.initState();
    updateSeen();

    // log("init function is called");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 104, 103, 103)
              : Colors.blue[200],
      // statusBarBrightness: Brightness.dark,
    ));
    ChatRoomProvider myProvider =
        Provider.of<ChatRoomProvider>(context, listen: false);
    return Consumer<themeProvider>(
      builder: (context, provider, child) => Scaffold(
          backgroundColor: provider.themeMode == ThemeMode.light
              ? Color.fromARGB(255, 151, 193, 226)
              : Color.fromARGB(255, 27, 26, 26),
          appBar: AppBar(
            elevation: 10,
            shadowColor: Color.fromARGB(255, 91, 35, 15),
            backgroundColor: provider.themeMode == ThemeMode.dark
                ? Color.fromARGB(255, 123, 117, 117)
                : Colors.blue[200],
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 6, top: 2),
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
                    color: provider.themeMode == ThemeMode.dark
                        ? Color.fromARGB(255, 139, 137, 137)
                        : Colors.blue[200],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        spreadRadius: -4,
                        offset: Offset(8, 8),
                        blurRadius: 20,
                      )
                    ],
                  )),
            ),
            title: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.targetUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data != null) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                  widget.targetUser.profilepic.toString()),
                            ),
                          ),

                          SizedBox(width: 01),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.targetUser.fullname.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: MeroStyle.getStyle(20)),
                                Text(
                                  snapshot.data!["status"],
                                  style: TextStyle(
                                    color: Colors.green[900],
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(width: 10),

                          // SizedBox(width: 10),
                          // Expanded(
                          //   // flex: 1,
                          //   child: Container(
                          //     // color: Colors.green,
                          //     child: IconButton(
                          //         onPressed: () {
                          //           // if (!isAnimated) {
                          //           //   __opacityValue = 0;
                          //           // } else {
                          //           //   __opacityValue = 1;
                          //           // }
                          //           // isAnimated = isAnimated == false ? true : false;

                          //           // if (isAnimated) {
                          //           setState(() {
                          //             __opacityValue =
                          //                 __opacityValue == 0 ? 1 : 0;
                          //           });

                          //           // }
                          //         },
                          //         icon: Icon(Icons.animation_rounded)),
                          //   ),
                          // ),
                        ],
                      );
                    } else {
                      return Container(
                          // color: Colors.red,
                          );
                    }
                  } else {
                    return Container();
                  }
                }),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              color: Colors.black,
              backgroundColor: Colors.blue[200],
              onRefresh: __handleRefresh,
              child: Column(
                children: [
                  //this is where the chat will go
                  Expanded(
                    child: Container(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("chatrooms")
                              .doc(widget.chatRoom.chatroomid)
                              .collection("messages")
                              .orderBy("createdon", descending: true)
                              .snapshots(),
                          builder: (context, snapshots) {
                            if (snapshots.connectionState ==
                                ConnectionState.active) {
                              if (snapshots.hasData) {
                                QuerySnapshot dataSnapshot =
                                    snapshots.data as QuerySnapshot;
                                return ListView.builder(
                                    padding: EdgeInsets.only(bottom: 0006),
                                    reverse: true,
                                    itemCount: dataSnapshot.docs.length,
                                    itemBuilder: (context, index) {
                                      MessageModel currentMessage =
                                          MessageModel.toObject(
                                              dataSnapshot.docs[index].data()
                                                  as Map<String, dynamic>);
                                      MessageModel previousMessage;
                                      if (index ==
                                          dataSnapshot.docs.length - 1) {
                                        previousMessage = MessageModel.toObject(
                                            dataSnapshot.docs[index].data()
                                                as Map<String, dynamic>);
                                      } else {
                                        previousMessage = MessageModel.toObject(
                                            dataSnapshot.docs[index + 1].data()
                                                as Map<String, dynamic>);
                                      }
                                      // log("difference is : " +

                                      if ((currentMessage.msgType == "txt")) {
                                        return Column(
                                          children: [
                                            currentMessage.createdon!
                                                        .difference(
                                                            previousMessage
                                                                .createdon!)
                                                        .inMinutes >
                                                    6
                                                ? SizedBox(height: 20)
                                                : SizedBox(),
                                            index ==
                                                    dataSnapshot.docs.length - 1
                                                ? SizedBox(
                                                    height: 10,
                                                  )
                                                : SizedBox(),
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                index !=
                                                        dataSnapshot.docs.length -
                                                            1
                                                    ? currentMessage.createdon!
                                                                .difference(previousMessage
                                                                    .createdon!)
                                                                .inMinutes >
                                                            6
                                                        ? DateFormat("yyyy-MM-dd").format(currentMessage.createdon!) ==
                                                                DateFormat("yyyy-MM-dd")
                                                                    .format(DateTime
                                                                        .now())
                                                            ? "Today " +
                                                                DateFormat("kk:mm a").format(
                                                                    currentMessage
                                                                        .createdon!)
                                                            : getWeek(currentMessage.createdon!.weekday) +
                                                                DateFormat(" KK:mm a").format(
                                                                    currentMessage
                                                                        .createdon!)
                                                        : ""
                                                    : DateFormat("yyyy-MM-dd").format(currentMessage.createdon!) ==
                                                            DateFormat("yyyy-MM-dd")
                                                                .format(DateTime.now())
                                                        ? "Today " + DateFormat("kk:mm a").format(currentMessage.createdon!)
                                                        : currentMessage.createdon!.difference(DateTime.now()).inDays > 7
                                                            ? DateFormat("yyyy-MM-dd").format(currentMessage.createdon!) + getWeek(currentMessage.createdon!.weekday)
                                                            : getWeek(currentMessage.createdon!.weekday) + " " + DateFormat("kk:mm a").format(currentMessage.createdon!),
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            index ==
                                                    dataSnapshot.docs.length - 1
                                                ? SizedBox(
                                                    height: 10,
                                                  )
                                                : SizedBox(),
                                            currentMessage.createdon!
                                                        .difference(
                                                            previousMessage
                                                                .createdon!)
                                                        .inMinutes >
                                                    6
                                                ? SizedBox(height: 15)
                                                : SizedBox(),
                                            Row(
                                                mainAxisAlignment:
                                                    (currentMessage.sender ==
                                                            widget.userModel.uid
                                                        ? MainAxisAlignment.end
                                                        : MainAxisAlignment
                                                            .start),
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  1.5),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 08,
                                                                  horizontal:
                                                                      20),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      002),
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              index != 0
                                                                  ? currentMessage
                                                                              .sender !=
                                                                          widget
                                                                              .userModel
                                                                              .uid
                                                                      ? BoxShadow(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(1),
                                                                          spreadRadius:
                                                                              -4,
                                                                          offset: Offset(
                                                                              0,
                                                                              5),
                                                                          blurRadius:
                                                                              10,
                                                                        )
                                                                      : BoxShadow(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(1),
                                                                          spreadRadius:
                                                                              -4,
                                                                          offset: Offset(
                                                                              0,
                                                                              5),
                                                                          blurRadius:
                                                                              10,
                                                                        )
                                                                  : BoxShadow()
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                            color: (currentMessage
                                                                        .sender ==
                                                                    widget
                                                                        .userModel
                                                                        .uid)
                                                                ? provider.themeMode ==
                                                                        ThemeMode
                                                                            .dark
                                                                    ? Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0)
                                                                    : Color
                                                                        .fromARGB(
                                                                            255,
                                                                            2,
                                                                            86,
                                                                            155)
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        162,
                                                                        160,
                                                                        160),
                                                          ),
                                                          child: InkWell(
                                                            onLongPress:
                                                                () async {
                                                              if (currentMessage
                                                                      .sender ==
                                                                  widget
                                                                      .userModel
                                                                      .uid) {
                                                                myProvider
                                                                    .checkInternet();
                                                                log("internet:  ${myProvider.hasInternet}");
                                                                if (myProvider
                                                                    .hasInternet) {
                                                                  log("Adaptive Sheet is shown");

                                                                  myProvider
                                                                          .copyText =
                                                                      currentMessage
                                                                          .text!;

                                                                  await showAdaptiveActionSheet(
                                                                    // isDismissible:
                                                                    //     true,
                                                                    bottomSheetColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            145,
                                                                            194,
                                                                            235),
                                                                    context:
                                                                        context,
                                                                    androidBorderRadius:
                                                                        50,
                                                                    actions: <
                                                                        BottomSheetAction>[
                                                                      BottomSheetAction(
                                                                          title:
                                                                              const Text(
                                                                            'Copy',
                                                                            style:
                                                                                TextStyle(color: Color.fromARGB(255, 5, 90, 160)),
                                                                          ),
                                                                          onPressed:
                                                                              (context) async {
                                                                            myProvider.CopyText();

                                                                            Navigator.pop(context);
                                                                          }),
                                                                      BottomSheetAction(
                                                                          title:
                                                                              const Text(
                                                                            "Delete",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color.fromARGB(255, 248, 125, 116),
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              (context) async {
                                                                            Navigator.pop(context);
                                                                            await FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatRoom.chatroomid).collection("messages").doc(dataSnapshot.docs[index].id).delete();
                                                                            FirebaseFirestore.instance.collection('chatrooms').doc(widget.chatRoom.chatroomid).update({
                                                                              "messageids": FieldValue.arrayRemove([
                                                                                dataSnapshot.docs[index].id
                                                                              ]),
                                                                            });
                                                                            widget.chatRoom.lastMessage =
                                                                                "Message Deleted";
                                                                            log(widget.chatRoom.messageids.toString());
                                                                            widget.chatRoom.messageids!.remove(dataSnapshot.docs[index].id);
                                                                            FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatRoom.chatroomid).set(widget.chatRoom.toMap());

                                                                            // Navigator.pop(context);
                                                                            log("Message Deleted");
                                                                          }),
                                                                    ],
                                                                    cancelAction:
                                                                        CancelAction(
                                                                            title:
                                                                                const Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    )), // onPressed parameter is optional by default will dismiss the ActionSheet
                                                                  );
                                                                } else {
                                                                  UIHelper.showAlertDialog(
                                                                      context,
                                                                      "An error Occured",
                                                                      "Check your Internet Connection");
                                                                }
                                                              } else {
                                                                myProvider
                                                                    .checkInternet();
                                                                log("internet:  ${myProvider.hasInternet}");
                                                                if (myProvider
                                                                    .hasInternet) {
                                                                  log("Adaptive Sheet is shown");

                                                                  myProvider
                                                                          .copyText =
                                                                      currentMessage
                                                                          .text!;

                                                                  await showAdaptiveActionSheet(
                                                                    isDismissible:
                                                                        true,
                                                                    bottomSheetColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            145,
                                                                            194,
                                                                            235),
                                                                    context:
                                                                        context,
                                                                    androidBorderRadius:
                                                                        50,
                                                                    actions: <
                                                                        BottomSheetAction>[
                                                                      BottomSheetAction(
                                                                          title:
                                                                              const Text(
                                                                            'Copy',
                                                                            style:
                                                                                TextStyle(color: Colors.blue),
                                                                          ),
                                                                          onPressed:
                                                                              (context) async {
                                                                            myProvider.CopyText();

                                                                            Navigator.pop(context);
                                                                          }),
                                                                    ],
                                                                    cancelAction:
                                                                        CancelAction(
                                                                            title:
                                                                                const Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    )), // onPressed parameter is optional by default will dismiss the ActionSheet
                                                                  );
                                                                } else {
                                                                  UIHelper
                                                                      .showAlertDialog(
                                                                    context,
                                                                    "An error Occured",
                                                                    "Check your Internet Connection",
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            child:
                                                                AnimatedOpacity(
                                                              opacity:
                                                                  __opacityValue,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                              child: Text(
                                                                currentMessage
                                                                    .text
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: (currentMessage.sender ==
                                                                            widget
                                                                                .userModel.uid)
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black87),
                                                              ),
                                                            ),
                                                          )),
                                                      index == 0
                                                          ? currentMessage.seen ==
                                                                      true &&
                                                                  FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid ==
                                                                      currentMessage
                                                                          .sender
                                                              ? Consumer<
                                                                      ChatRoomProvider>(
                                                                  builder: (context,
                                                                          provider,
                                                                          child) =>
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            right:
                                                                                4,
                                                                            top:
                                                                                4.0),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            provider.seenerAppearance();
                                                                          },
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              CircleAvatar(
                                                                                radius: 000009,
                                                                                backgroundImage: NetworkImage(widget.targetUser.profilepic!),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 002,
                                                                              ),
                                                                              (provider.isSeenerAppeared == true)
                                                                                  ? Text(
                                                                                      "Seen by " + widget.targetUser.fullname!,
                                                                                      style: MeroStyle.getStyle(10),
                                                                                    )
                                                                                  : Center()
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                              : Container()
                                                          : Container(),
                                                      // SizedBox(
                                                      //   height: 3,
                                                      // ),
                                                    ],
                                                  ),
                                                ]),
                                            // SizedBox(height: 2),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            currentMessage.createdon!
                                                        .difference(
                                                            previousMessage
                                                                .createdon!)
                                                        .inMinutes >
                                                    6
                                                ? SizedBox(height: 20)
                                                : SizedBox(),
                                            index ==
                                                    dataSnapshot.docs.length - 1
                                                ? SizedBox(
                                                    height: 10,
                                                  )
                                                : SizedBox(),
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                index !=
                                                        dataSnapshot.docs.length -
                                                            1
                                                    ? currentMessage.createdon!
                                                                .difference(previousMessage
                                                                    .createdon!)
                                                                .inMinutes >
                                                            6
                                                        ? DateFormat("yyyy-MM-dd").format(currentMessage.createdon!) ==
                                                                DateFormat("yyyy-MM-dd")
                                                                    .format(DateTime
                                                                        .now())
                                                            ? "Today " +
                                                                DateFormat("kk:mm a").format(
                                                                    currentMessage
                                                                        .createdon!)
                                                            : getWeek(currentMessage.createdon!.weekday) +
                                                                DateFormat(" KK:mm a").format(
                                                                    currentMessage
                                                                        .createdon!)
                                                        : ""
                                                    : DateFormat("yyyy-MM-dd").format(currentMessage.createdon!) ==
                                                            DateFormat("yyyy-MM-dd")
                                                                .format(DateTime.now())
                                                        ? "Today " + DateFormat("kk:mm a").format(currentMessage.createdon!)
                                                        : currentMessage.createdon!.difference(DateTime.now()).inDays > 7
                                                            ? DateFormat("yyyy-MM-dd").format(currentMessage.createdon!) + getWeek(currentMessage.createdon!.weekday)
                                                            : getWeek(currentMessage.createdon!.weekday) + " " + DateFormat("kk:mm a").format(currentMessage.createdon!),
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            index ==
                                                    dataSnapshot.docs.length - 1
                                                ? SizedBox(
                                                    height: 10,
                                                  )
                                                : SizedBox(),
                                            currentMessage.createdon!
                                                        .difference(
                                                            previousMessage
                                                                .createdon!)
                                                        .inMinutes >
                                                    6
                                                ? SizedBox(height: 15)
                                                : SizedBox(),
                                            // SizedBox(height: 2),
                                            Row(
                                              mainAxisAlignment: (currentMessage
                                                          .sender ==
                                                      widget.userModel.uid
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start),
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                        onLongPress: () {
                                                          if (currentMessage
                                                                  .sender ==
                                                              widget.userModel
                                                                  .uid) {
                                                            myProvider
                                                                .checkInternet();
                                                            if (myProvider
                                                                .hasInternet) {
                                                              log("Adaptive Sheet is shown");
                                                              showAdaptiveActionSheet(
                                                                isDismissible:
                                                                    true,
                                                                bottomSheetColor:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        145,
                                                                        194,
                                                                        235),
                                                                context:
                                                                    context,
                                                                androidBorderRadius:
                                                                    50,
                                                                actions: <
                                                                    BottomSheetAction>[
                                                                  BottomSheetAction(
                                                                      title:
                                                                          const Text(
                                                                        "Delete",
                                                                        style:
                                                                            TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              227,
                                                                              87,
                                                                              77),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          (context) async {
                                                                        Navigator.pop(
                                                                            context);
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection("chatrooms")
                                                                            .doc(widget.chatRoom.chatroomid)
                                                                            .collection("messages")
                                                                            .doc(dataSnapshot.docs[index].id)
                                                                            .delete();

                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('chatrooms')
                                                                            .doc(widget.chatRoom.chatroomid)
                                                                            .update({
                                                                          "messageids":
                                                                              FieldValue.arrayRemove([
                                                                            dataSnapshot.docs[index].id
                                                                          ]),
                                                                        });
                                                                        // Navigator.s
                                                                        widget
                                                                            .chatRoom
                                                                            .lastMessage = "Image Deleted";
                                                                        widget
                                                                            .chatRoom
                                                                            .messageids!
                                                                            .remove(dataSnapshot.docs[index].id);
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection("chatrooms")
                                                                            .doc(widget.chatRoom.chatroomid)
                                                                            .set(widget.chatRoom.toMap());

                                                                        log("Message Deleted");
                                                                      }),
                                                                ],
                                                                cancelAction:
                                                                    CancelAction(
                                                                        title:
                                                                            const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                )), // onPressed parameter is optional by default will dismiss the ActionSheet
                                                              );
                                                            } else {
                                                              UIHelper.showAlertDialog(
                                                                  context,
                                                                  "An error occured",
                                                                  "Please check your internet connection");
                                                            }
                                                          } else {
                                                            myProvider
                                                                .checkInternet();
                                                            if (myProvider
                                                                .hasInternet) {
                                                              showAdaptiveActionSheet(
                                                                isDismissible:
                                                                    true,
                                                                bottomSheetColor:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        145,
                                                                        194,
                                                                        235),
                                                                context:
                                                                    context,
                                                                androidBorderRadius:
                                                                    50,
                                                                actions: <
                                                                    BottomSheetAction>[
                                                                  //You cannot delete the image sent by the target user
                                                                  //and this is the image, so none can copy that
                                                                  //you can add save button
                                                                ],
                                                                cancelAction:
                                                                    CancelAction(
                                                                        title:
                                                                            const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                )), // onPressed parameter is optional by default will dismiss the ActionSheet
                                                              );
                                                            } else {
                                                              UIHelper.showAlertDialog(
                                                                  context,
                                                                  "An error occured",
                                                                  "Please check your internet connection");
                                                            }
                                                          }
                                                        },
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return ShowImage(
                                                                Imageurl:
                                                                    currentMessage
                                                                        .ImageFile!);
                                                          }));
                                                        },
                                                        child: currentMessage
                                                                    .ImageFile !=
                                                                null
                                                            ? Container(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        1.5),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    2.50,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            00),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black12)),
                                                                child: currentMessage
                                                                            .ImageFile !=
                                                                        null
                                                                    ? ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        child: Image
                                                                            .network(
                                                                          currentMessage.ImageFile
                                                                              .toString(),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      )
                                                                    : CircularProgressIndicator(),
                                                              )
                                                            : Container()),
                                                    index == 0
                                                        ? currentMessage.seen ==
                                                                    true &&
                                                                FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid ==
                                                                    currentMessage
                                                                        .sender
                                                            ? Consumer<
                                                                    ChatRoomProvider>(
                                                                builder: (context,
                                                                        provider,
                                                                        child) =>
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              4,
                                                                          top:
                                                                              4.0),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          provider
                                                                              .seenerAppearance();
                                                                        },
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            CircleAvatar(
                                                                              radius: 000009,
                                                                              backgroundImage: NetworkImage(widget.targetUser.profilepic!),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 002,
                                                                            ),
                                                                            (provider.isSeenerAppeared == true)
                                                                                ? Text(
                                                                                    "Seen by " + widget.targetUser.fullname!,
                                                                                    style: MeroStyle.getStyle(10),
                                                                                  )
                                                                                : Center()
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ))
                                                            : Container()
                                                        : Container(),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            // SizedBox(height: 2),
                                          ],
                                        );
                                      }
                                    });
                              } else if (snapshots.hasError) {
                                return Center(
                                  child: Text(
                                      "An error ocurred! please check the internet conection"),
                                );
                              } else {
                                return Center(
                                  child: Text("Say Hi to your new Friend"),
                                );
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    ),
                  ),
                  // SizedBox(height: 10),
                  Container(
                    // margin: EdgeInsets.only(top: 100),
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 05),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextField(
                            maxLines: null,
                            controller: messageController,
                            cursorColor: Colors.black,
                            // cursorHeight: 20,
                            // cursorWidth: 1,

                            // cursorRadius: Radius.circular(40),
                            decoration: InputDecoration(
                              fillColor: Colors.green,
                              // suffixIconColor: Colors.red,
                              hoverColor: Colors.red,
                              // focusColor: Colors.red,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 0),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  myProvider.checkInternet();
                                  log("${myProvider.hasInternet}");
                                  if (myProvider.hasInternet) {
                                    showPhotoOptions();
                                  } else {
                                    UIHelper.showAlertDialog(
                                        context,
                                        "An error Occured",
                                        "Please Check Your Internet Connection");
                                  }
                                },
                                icon: Icon(Icons.image,
                                    size: 30,
                                    color: Color.fromARGB(255, 2, 66, 118)),
                              ),
                              // border: InputBorder.none,
                              hintText: "Enter Message...",
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 9, 1, 0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            myProvider.checkInternet();
                            log("${myProvider.hasInternet}");
                            if (myProvider.hasInternet) {
                              sendMessage();
                            } else {
                              UIHelper.showAlertDialog(
                                  context,
                                  "An error Occured",
                                  "Please Check Your Internet Connection");
                            }
                          },
                          icon: Icon(
                            Icons.send,
                            color: Color.fromARGB(255, 1, 63, 113),
                            size: 35,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

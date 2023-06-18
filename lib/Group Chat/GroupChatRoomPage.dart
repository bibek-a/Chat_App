import 'dart:developer';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:chating_app/Constants/Date.dart';
import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Group%20Chat/GroupInfoPage.dart';
import 'package:chating_app/Group%20Chat/GroupMessageModel.dart';
import 'package:chating_app/Group%20Chat/GroupModel.dart';
// import 'package:chating_app/Providers/GroupChatProvider.dart';
import 'package:chating_app/Providers/chatRoom_provider.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:chating_app/ShowImage.dart';
import 'package:chating_app/main.dart';
// import 'package:chating_app/models/ChatRoomModel.dart';
import 'package:chating_app/models/FirebaseHelper.dart';
import 'package:chating_app/models/MessageModel.dart';
import 'package:chating_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Models/UIHelper.dart';

class GroupChatRoomPage extends StatefulWidget {
  //
  final GroupModel currentGroup;
  final UserModel userModel;
  // final User? firebaseUser;

  const GroupChatRoomPage(
      {Key? key,
      required this.userModel,
      // this.firebaseUser,
      required this.currentGroup})
      : super(key: key);
  // const GroupChatRoomPage({super.key});
  @override
  State<GroupChatRoomPage> createState() => _GroupChatRoomPageState();
}

class _GroupChatRoomPageState extends State<GroupChatRoomPage> {
  Future<void> __handleRefresh() async {
    setState(() {});
    return await Future.delayed(
      Duration(milliseconds: 700),
    );
  }

  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    // log("internet:  $hasInternet");

    String msg = messageController.text.trim();
    messageController.clear();
    //
    String messageid = uuid.v1();
    //
    if (msg != "") {
      //send message
      GroupMessageModel newMessage = GroupMessageModel(
        messageid: messageid,
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        seener: [],
        msgType: "txt",
        ImageFile: "",
        senderDP: widget.userModel.profilepic,
      );
      //

      widget.currentGroup.createdon = DateTime.now();
      widget.currentGroup.messageid = messageid;
      widget.currentGroup.lastSender = widget.userModel.uid;
      // widget.currentGroup.isLastMsgSeen = false;
      widget.currentGroup.lastMessage = msg;
      widget.currentGroup.lastSenderFullname = widget.userModel.fullname!;
      log(" messege id is: " + widget.currentGroup.messageid.toString());
      //
      try {
        log("it is trying");
        await FirebaseFirestore.instance
            .collection("groupchatroom")
            .doc(widget.currentGroup.groupchatroomid)
            .collection("messages")
            .doc(newMessage.messageid)
            .set(newMessage.toMap());
      } catch (error) {
        log(error.toString());
      }
      //

      //
      FirebaseFirestore.instance
          .collection("groupchatroom")
          .doc(widget.currentGroup.groupchatroomid)
          .set(widget.currentGroup.toMap(), SetOptions(merge: true));

      log("Message Sent");
      FirebaseFirestore.instance
          .collection("groupchatroom")
          .doc(widget.currentGroup.groupchatroomid)
          .collection("messages")
          .doc(messageid)
          .update({
        "seener": FieldValue.arrayUnion([widget.userModel.uid]),
      });
      widget.currentGroup.messageid = "";
    }
  }

  DateTime? previousTime;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 0, 0, 0)
              : Colors.blue[200],
    ));
    ChatRoomProvider myProvider =
        Provider.of<ChatRoomProvider>(context, listen: false);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 104, 103, 103)
              : Colors.blue[200],
      // statusBarBrightness: Brightness.dark,
    ));
    return Consumer<themeProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: provider.themeMode == ThemeMode.light
                  ? Color.fromARGB(255, 151, 193, 226)
                  : Color.fromARGB(255, 27, 26, 26),
              appBar: AppBar(
                // automaticallyImplyLeading: true,
                elevation: 10,
                shadowColor: Color.fromARGB(255, 51, 19, 7),
                backgroundColor: provider.themeMode == ThemeMode.dark
                    ? Color.fromARGB(255, 123, 117, 117)
                    : Colors.blue[200],
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
                        color: provider.themeMode == ThemeMode.dark
                            ? Color.fromARGB(255, 139, 137, 137)
                            : Colors.blue[200],
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
                title: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            widget.currentGroup.displaypicture.toString()),
                      ),
                    ),
                    //
                    SizedBox(width: 3),

                    Expanded(
                      flex: 6,
                      child: Text(widget.currentGroup.groupname.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: MeroStyle.getStyle(width / 20)),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          padding: EdgeInsets.only(right: 0),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return GroupInfoPage(
                                currentGroup: widget.currentGroup,
                                userModel: widget.userModel,
                              );
                            }));
                          },
                          icon: Icon(CupertinoIcons.info_circle_fill)),
                    ),
                    // SizedBox(width: 20)
                  ],
                ),
              ),
              body: SafeArea(
                child: RefreshIndicator(
                  color: Colors.black,
                  backgroundColor: Color.fromARGB(255, 147, 191, 225),
                  onRefresh: __handleRefresh,
                  child: Container(
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 01,
                          ),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("groupchatroom")
                                  .doc(widget.currentGroup.groupchatroomid)
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
                                        reverse: true,
                                        itemCount: dataSnapshot.docs.length,
                                        itemBuilder: (context, index) {
                                          GroupMessageModel currentMessage =
                                              GroupMessageModel.toObject(
                                                  dataSnapshot.docs[index]
                                                          .data()
                                                      as Map<String, dynamic>);

                                          ///
                                          MessageModel previousMessage;
                                          if (index ==
                                              dataSnapshot.docs.length - 1) {
                                            previousMessage = MessageModel
                                                .toObject(dataSnapshot
                                                        .docs[index]
                                                        .data()
                                                    as Map<String, dynamic>);
                                          } else {
                                            previousMessage = MessageModel
                                                .toObject(dataSnapshot
                                                        .docs[index + 1]
                                                        .data()
                                                    as Map<String, dynamic>);
                                          }
                                          //
                                          if ((currentMessage.msgType ==
                                              "txt")) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
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
                                                        dataSnapshot
                                                                .docs.length -
                                                            1
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
                                                        ? currentMessage
                                                                    .createdon!
                                                                    .difference(
                                                                        previousMessage
                                                                            .createdon!)
                                                                    .inMinutes >
                                                                6
                                                            ? DateFormat("yyyy-MM-dd").format(currentMessage.createdon!) ==
                                                                    DateFormat("yyyy-MM-dd")
                                                                        .format(DateTime
                                                                            .now())
                                                                ? "Today " +
                                                                    DateFormat("kk:mm a")
                                                                        .format(currentMessage
                                                                            .createdon!)
                                                                : getWeek(currentMessage.createdon!.weekday) +
                                                                    DateFormat(" KK:mm a")
                                                                        .format(currentMessage
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
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                index ==
                                                        dataSnapshot
                                                                .docs.length -
                                                            1
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
                                                                widget.userModel
                                                                    .uid
                                                            ? MainAxisAlignment
                                                                .end
                                                            : MainAxisAlignment
                                                                .start),
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          // currentMessage.sender==widget.userModel.uid  ?
                                                          ContainerWidget(
                                                              currentMessage,
                                                              provider,
                                                              myProvider,
                                                              dataSnapshot,
                                                              index),
                                                        ],
                                                      ),
                                                    ]),
                                                // SizedBox(height: 1),s
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: seenImage(
                                                      currentMessage,
                                                      provider,
                                                      myProvider,
                                                      dataSnapshot,
                                                      index),
                                                ),
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
                                                        dataSnapshot
                                                                .docs.length -
                                                            1
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
                                                        ? currentMessage
                                                                    .createdon!
                                                                    .difference(
                                                                        previousMessage
                                                                            .createdon!)
                                                                    .inMinutes >
                                                                6
                                                            ? DateFormat("yyyy-MM-dd").format(currentMessage.createdon!) ==
                                                                    DateFormat("yyyy-MM-dd")
                                                                        .format(DateTime
                                                                            .now())
                                                                ? "Today " +
                                                                    DateFormat("kk:mm a")
                                                                        .format(currentMessage
                                                                            .createdon!)
                                                                : getWeek(currentMessage.createdon!.weekday) +
                                                                    DateFormat(" KK:mm a")
                                                                        .format(currentMessage
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
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                index ==
                                                        dataSnapshot
                                                                .docs.length -
                                                            1
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
                                                              widget
                                                                  .userModel.uid
                                                          ? MainAxisAlignment
                                                              .end
                                                          : MainAxisAlignment
                                                              .start),
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        GestureDetector(
                                                            onLongPress: () {
                                                              if (currentMessage
                                                                      .sender ==
                                                                  widget
                                                                      .userModel
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
                                                                              color: Color.fromARGB(255, 227, 87, 77),
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              (context) async {
                                                                            Navigator.pop(context);
                                                                            await FirebaseFirestore.instance.collection("groupchatroom").doc(widget.currentGroup.groupchatroomid).collection("messages").doc(dataSnapshot.docs[index].id).delete();

                                                                            await FirebaseFirestore.instance.collection('groupchatroom').doc(widget.currentGroup.groupchatroomid).update({
                                                                              "messageids": FieldValue.arrayRemove([
                                                                                dataSnapshot.docs[index].id
                                                                              ]),
                                                                            });
                                                                            // Navigator.s
                                                                            widget.currentGroup.lastMessage =
                                                                                "Image Deleted";
                                                                            // widget.currentGroup.messageids!.remove(dataSnapshot.docs[index].id);
                                                                            await FirebaseFirestore.instance.collection("groupchatroom").doc(widget.currentGroup.groupchatroomid).set(widget.currentGroup.toMap());

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
                                                                          color:
                                                                              Colors.black),
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
                                                                    constraints:
                                                                        BoxConstraints(
                                                                            maxWidth:
                                                                                MediaQuery.of(context).size.width / 1.5),
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        2.5,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2,
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                                    margin: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            03),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                25),
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.black12)),
                                                                    child: currentMessage.ImageFile !=
                                                                            null
                                                                        ? ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            child:
                                                                                Image.network(
                                                                              currentMessage.ImageFile.toString(),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          )
                                                                        : CircularProgressIndicator(),
                                                                  )
                                                                : Container()),
                                                        index == 0
                                                            ?
                                                            // ? currentMessage.seen ==
                                                            //             true &&
                                                            FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid ==
                                                                    currentMessage
                                                                        .sender
                                                                ? CircleAvatar(
                                                                    radius: 8,
                                                                    backgroundImage:
                                                                        NetworkImage(widget
                                                                            .userModel
                                                                            .profilepic!),
                                                                  )
                                                                : Container()
                                                            : Container(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 2),
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
                                    child: Container(
                                        // strokeWidth: 3.5,
                                        // color: Color.fromARGB(255, 1, 2, 18),
                                        ),
                                  );
                                }
                              }),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 05),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextField(
                                controller: messageController,
                                maxLines: null,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  fillColor: Colors.green,
                                  hoverColor: Colors.red,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      myProvider.checkInternet();
                                      log("${myProvider.hasInternet}");
                                      if (myProvider.hasInternet) {
                                        // showPhotoOptions();
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
                    ]),
                  ),
                ),
              )),
        );
      },
    );
  }

  updateSeen() async {
    log("update seen is calling");
    if (FirebaseAuth.instance.currentUser!.uid ==
        widget.currentGroup.lastSender) {
      log("Sent by this user");
      //
    } else {
      log("Sent by an another user");
      var UniqueMsgId = widget.currentGroup.messageid;
      log(UniqueMsgId!);
      if (UniqueMsgId != "") {
        FirebaseFirestore.instance
            .collection("groupchatroom")
            .doc(widget.currentGroup.groupchatroomid)
            .collection("messages")
            .doc(UniqueMsgId)
            .update({
          "seener": FieldValue.arrayUnion([widget.userModel.uid]),
        });
      }
      log("Message seen by ${widget.userModel.fullname}");
    }
  }

  @override
  void initState() {
    super.initState();
    // widget.currentGroup.messageids?.clear();
    Provider.of<ChatRoomProvider>(context, listen: false).checkInternet();
    updateSeen();
  }

  Widget ContainerWidget(
          GroupMessageModel currentMessage,
          themeProvider provider,
          ChatRoomProvider myProvider,
          QuerySnapshot dataSnapshot,
          int index) =>
      currentMessage.sender != widget.userModel.uid
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatarImage(
                    currentMessage, provider, myProvider, dataSnapshot, index),
                SizedBox(width: 6),
                MyContainer(
                    currentMessage, provider, myProvider, dataSnapshot, index),
              ],
            )
          : MyContainer(
              currentMessage, provider, myProvider, dataSnapshot, index);

  Widget MyContainer(GroupMessageModel currentMessage, themeProvider provider,
          ChatRoomProvider myProvider, QuerySnapshot dataSnapshot, int index) =>
      Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.3),
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
          decoration: BoxDecoration(
            boxShadow: [
              currentMessage.sender != widget.userModel.uid
                  ? BoxShadow(
                      color: Colors.black.withOpacity(1),
                      spreadRadius: -4,
                      offset: Offset(0, 5),
                      blurRadius: 10,
                    )
                  : BoxShadow(
                      color: Colors.black.withOpacity(1),
                      spreadRadius: -4,
                      offset: Offset(0, 5),
                      blurRadius: 10,
                    )
            ],
            borderRadius: BorderRadius.circular(7),
            color: (currentMessage.sender == widget.userModel.uid)
                ? provider.themeMode == ThemeMode.dark
                    ? Color.fromARGB(255, 0, 0, 0)
                    : Color.fromARGB(255, 2, 86, 155)
                : Color.fromARGB(255, 162, 160, 160),
          ),
          child: InkWell(
            onLongPress: () async {
              if (currentMessage.sender == widget.userModel.uid) {
                myProvider.checkInternet();
                log("internet:  ${myProvider.hasInternet}");
                if (myProvider.hasInternet) {
                  log("Adaptive Sheet is shown");

                  myProvider.copyText = currentMessage.text!;

                  await showAdaptiveActionSheet(
                    // isDismissible:
                    //     true,
                    bottomSheetColor: Color.fromARGB(255, 145, 194, 235),
                    context: context,
                    androidBorderRadius: 50,
                    actions: <BottomSheetAction>[
                      BottomSheetAction(
                          title: const Text(
                            'Copy',
                            style: TextStyle(
                                color: Color.fromARGB(255, 5, 90, 160)),
                          ),
                          onPressed: (context) async {
                            myProvider.CopyText();

                            Navigator.pop(context);
                          }),
                      BottomSheetAction(
                          title: const Text(
                            "Delete",
                            style: TextStyle(
                              color: Color.fromARGB(255, 248, 125, 116),
                            ),
                          ),
                          onPressed: (context) async {
                            Navigator.pop(context);
                            await FirebaseFirestore.instance
                                .collection("groupchatroom")
                                .doc(widget.currentGroup.groupchatroomid)
                                .collection("messages")
                                .doc(dataSnapshot.docs[index].id)
                                .delete();
                            //
                            FirebaseFirestore.instance
                                .collection('groupchatroom')
                                .doc(widget.currentGroup.groupchatroomid)
                                .update({"messageid": FieldValue.delete()});

                            //
                            widget.currentGroup.messageid = "";

                            widget.currentGroup.lastMessage = "Message Deleted";
                            widget.currentGroup.lastSender = "";
                            widget.currentGroup.lastSenderFullname = "";
                            // log(widget.currentGroup.messageid.toString());
                            // widget.currentGroup.messageids!
                            //     .remove(dataSnapshot.docs[index].id);
                            FirebaseFirestore.instance
                                .collection("groupchatroom")
                                .doc(widget.currentGroup.groupchatroomid)
                                .set(widget.currentGroup.toMap(),
                                    SetOptions(merge: true));

                            // Navigator.pop(context);
                            log("Message Deleted");
                          }),
                    ],
                    cancelAction: CancelAction(
                        title: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    )), // onPressed parameter is optional by default will dismiss the ActionSheet
                  );
                } else {
                  UIHelper.showAlertDialog(context, "An error Occured",
                      "Check your Internet Connection");
                }
              } else {
                myProvider.checkInternet();
                log("internet:  ${myProvider.hasInternet}");
                if (myProvider.hasInternet) {
                  log("Adaptive Sheet is shown");

                  myProvider.copyText = currentMessage.text!;

                  await showAdaptiveActionSheet(
                    isDismissible: true,
                    bottomSheetColor: Color.fromARGB(255, 145, 194, 235),
                    context: context,
                    androidBorderRadius: 50,
                    actions: <BottomSheetAction>[
                      BottomSheetAction(
                          title: const Text(
                            'Copy',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: (context) async {
                            myProvider.CopyText();

                            Navigator.pop(context);
                          }),
                    ],
                    cancelAction: CancelAction(
                        title: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    )), // onPressed parameter is optional by default will dismiss the ActionSheet
                  );
                } else {
                  UIHelper.showAlertDialog(
                    context,
                    "An error Occured",
                    "Check your Internet Connection",
                  );
                }
              }
            },
            child: AnimatedOpacity(
              opacity: 1,
              // __opacityValue,
              duration: const Duration(seconds: 2),
              child: Text(
                currentMessage.text.toString(),
                style: TextStyle(
                    fontSize: 18,
                    color: (currentMessage.sender == widget.userModel.uid)
                        ? Colors.white
                        : Colors.black87),
              ),
            ),
          ));

  CircleAvatarImage(GroupMessageModel currentMessage, themeProvider provider,
          ChatRoomProvider myProvider, QuerySnapshot dataSnapshot, int index) =>
      CircleAvatar(
        radius: 16,
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(currentMessage.senderDP!),
      );
//
  List<Widget> widgets = [];
  //
  Widget seenImage(GroupMessageModel currentMessage, themeProvider provider,
          ChatRoomProvider myProvider, QuerySnapshot dataSnapshot, int index) =>
      index == 0
          ? Column(
              children: [
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(
                    currentMessage.seener!.length,
                    (index) => FutureBuilder(
                      future: FirebaseHelper.getUserModelById(
                          currentMessage.seener!.elementAt(index)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            UserModel targetUser = snapshot.data as UserModel;
                            return targetUser.uid != widget.userModel.uid
                                ? Consumer<ChatRoomProvider>(
                                    builder: (context, provider, child) =>
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 000.5),
                                          child: GestureDetector(
                                            onTap: () {
                                              provider.seenerAppearance();
                                            },
                                            child: CircleAvatar(
                                              radius: 009,
                                              backgroundImage: NetworkImage(
                                                  targetUser.profilepic!),
                                              backgroundColor: Colors.black,
                                            ),
                                          ),
                                        ))
                                : Container();
                          } else {
                            return Center();
                          }
                        } else {
                          return Center(
                            child: Container(),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(
                    currentMessage.seener!.length,
                    (index) => FutureBuilder(
                      future: FirebaseHelper.getUserModelById(
                          currentMessage.seener!.elementAt(index)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            UserModel targetUser = snapshot.data as UserModel;
                            return targetUser.uid != widget.userModel.uid
                                ? Consumer<ChatRoomProvider>(
                                    builder: (context, provider, child) =>
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0001),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 002,
                                              ),
                                              (provider.isSeenerAppeared ==
                                                      true)
                                                  ? Text(
                                                      targetUser.fullname!
                                                          .split(" ")[0],
                                                      style: MeroStyle.getStyle(
                                                          10),
                                                    )
                                                  : Center()
                                            ],
                                          ),
                                        ))
                                : Container();
                          } else {
                            return Center();
                          }
                        } else {
                          return Center(
                            child: Container(),
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            )
          : Container();
}

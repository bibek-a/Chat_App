// import 'dart:developer';
import 'package:chating_app/Chat%20Pages/ChatRoomPage.dart';
import 'package:chating_app/Chat%20Pages/MyLocationPage.dart';
import 'package:chating_app/Chat%20Pages/MyProfilePage.dart';
import 'package:chating_app/Chat%20Pages/SearchPage.dart';
import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Constants/map.dart';
import 'package:chating_app/Providers/chatRoom_provider.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:chating_app/models/ChatRoomModel.dart';
import 'package:chating_app/models/FirebaseHelper.dart';
// import 'package:chating_app/models/UIHelper.dart';
import 'package:chating_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import "dart:convert";

import 'package:provider/provider.dart';

// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget with WidgetsBindingObserver {
  final UserModel userModel;
  final User firebaseUser;
  //
  const HomePage({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Future<void> __handleRefresh() async {
    setState(() {});
    return await Future.delayed(
      Duration(milliseconds: 700),
    );
  }

  // //
  @override
  void initState() {
    super.initState();

    // ChatRoomProvider myProvider =
    Provider.of<ChatRoomProvider>(context, listen: false).checkInternet();
    // myProvider.checkInternet();
    // log("${Provider.of<ChatRoomProvider>(context, listen: false).hasInternet}");
    // if (Provider.of<ChatRoomProvider>(context, listen: false).hasInternet) {
    //   // showPhotoOptions();
    // } else {
    //   UIHelper.showAlertDialog(
    //       context, "An error Occured", "Please Check Your Internet Connection");
    // }
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
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

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // ChatRoomProvider myProvider =
    //     Provider.of<ChatRoomProvider>(context, listen: false);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 0, 0, 0)
              : Colors.blue[200],
    ));
    return Scaffold(
      backgroundColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.light
              ? Color.fromARGB(255, 134, 185, 224)
              : Color.fromARGB(255, 12, 12, 12),
      appBar: AppBar(
        elevation: 10,
        shadowColor: Color.fromARGB(255, 91, 35, 15),
        iconTheme: IconThemeData(color: Colors.black, size: 33),
        backgroundColor:
            Provider.of<themeProvider>(context, listen: false).themeMode ==
                    ThemeMode.light
                ? Colors.blue[200]
                : Color.fromARGB(255, 29, 28, 28),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
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

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text("Chats",
                  style: Provider.of<themeProvider>(context, listen: false)
                              .themeMode ==
                          ThemeMode.light
                      ? MeroStyle.getStyle(width / 18)
                      : MeroStyle.getStyle2(width / 18)),
            ),
            Expanded(
              flex: 1,
              child: CupertinoButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyProfilePage(
                      userModel: widget.userModel,
                      FirebaseUser: widget.firebaseUser,
                    );
                  }));
                },
                // padding: EdgeInsets.only(right: 85),
                child: CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage(widget.userModel.profilepic!),
                ),
              ),
            ),
          ],
        ),

        // centerTitle: true,
      ),
      body: RefreshIndicator(
        color: Colors.black,
        backgroundColor: Colors.blue[200],
        onRefresh: __handleRefresh,
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("participants.${widget.userModel.uid}", isEqualTo: true)
                // .orderBy("createdon")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // log("Good Connection established");
                if (snapshot.data!.docs.length > 0) {
                  if (snapshot.hasData) {
                    QuerySnapshot chatRoomSnapshot =
                        snapshot.data as QuerySnapshot;
                    //
                    FriendsList.clear();
                    return ListView.builder(
                        itemCount: chatRoomSnapshot.docs.length,
                        //
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.toObject(
                              chatRoomSnapshot.docs[index].data()
                                  as Map<String, dynamic>);
                          //
                          Map<String, dynamic> participants =
                              chatRoomModel.participants!;
                          //

                          List<String> participantsKeys =
                              participants.keys.toList();
                          //
                          // log(participantsKeys.toString());
                          participantsKeys.remove(widget.userModel.uid);
                          //

                          return FutureBuilder(
                            future: FirebaseHelper.getUserModelById(
                                participantsKeys[0]),
                            builder: (context, userData) {
                              if (userData.connectionState ==
                                  ConnectionState.done) {
                                if (userData.data != null) {
                                  UserModel targetUser =
                                      userData.data as UserModel;

                                  MyFriends.addToFriends(targetUser);
                                  // return Container();
                                  return ListTile(
                                    // hoverColor: Colors.red,
                                    // tileColor: isHovered == true
                                    //     ? Colors.black
                                    //     : Color.fromARGB(255, 134, 185, 224),                                          horizontal: 15, vertical: 0),
                                    onTap: () {
                                      // isHovered = true;

                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ChatRoomPage(
                                          targetUser: targetUser,
                                          firebaseUser: widget.firebaseUser,
                                          chatRoom: chatRoomModel,
                                          userModel: widget.userModel,
                                        );
                                      }));
                                      // isHovered = false;
                                      // setState(() {});
                                    },
                                    leading: CircleAvatar(
                                      radius: width / 13.5,
                                      backgroundImage: NetworkImage(
                                          targetUser.profilepic.toString()),
                                    ),
                                    title: Text(
                                      targetUser.fullname.toString(),
                                      style: MeroStyle.getStyle(width / 18),
                                    ),
                                    subtitle: (chatRoomModel.lastMessage
                                                .toString() !=
                                            "")
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              chatRoomModel
                                                          .lastSenderFullname ==
                                                      widget.userModel.fullname
                                                  ? Text(
                                                      "You: ",
                                                      style: chatRoomModel
                                                                      .isLastMsgSeen ==
                                                                  false &&
                                                              chatRoomModel
                                                                      .lastSender !=
                                                                  widget
                                                                      .userModel
                                                                      .uid
                                                          ? TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize:
                                                                  width / 19,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            )
                                                          : MeroStyle.getStyle(
                                                              width / 18),
                                                    )
                                                  : Text(
                                                      "",
                                                      style: chatRoomModel
                                                                  .isLastMsgSeen ==
                                                              true
                                                          ? MeroStyle.getStyle(
                                                              width / 20)
                                                          : TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      7,
                                                                      85,
                                                                      149),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                    ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Text(
                                                  chatRoomModel.lastMessage!
                                                      .split("\n")[0],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: chatRoomModel
                                                                  .isLastMsgSeen ==
                                                              false &&
                                                          chatRoomModel
                                                                  .lastSender !=
                                                              widget
                                                                  .userModel.uid
                                                      ? TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 5, 40, 237),
                                                          fontSize: width / 20,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        )
                                                      : MeroStyle.getStyle(
                                                          width / 20),
                                                ),
                                              ),
                                              SizedBox(width: 30),
                                              chatRoomModel.isLastMsgSeen ==
                                                          true &&
                                                      chatRoomModel
                                                              .lastSender ==
                                                          widget.userModel.uid
                                                  ? CircleAvatar(
                                                      radius: 0009,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              targetUser
                                                                  .profilepic!),
                                                      backgroundColor:
                                                          Colors.grey,
                                                    )
                                                  : Container()
                                            ],
                                          )
                                        //
                                        : Text(
                                            "Say Hi to Your New Friend",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 5, 80, 25),
                                              fontSize: 17,
                                              // letterSpacing: 01
                                            ),
                                          ),
                                  );
                                } else {
                                  // return log("Hell");
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            },
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    // log("No Chat Available");
                    // return Center(
                    //   child: Container(child: Text("No Chats")),
                    // );
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                } else {
                  // log("no data found");
                  return Center(
                    child: Text(
                      "No Chat Room Found !!",
                      style: MeroStyle.getStyle(21),
                    ),
                  );
                }
                // return Container();
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
                // log("Connection not established");
              }
            },
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: null,
              elevation: 30,
              backgroundColor: Color.fromARGB(255, 164, 203, 236),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchPage(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                  );
                }));
              },
              label: Text(
                "Search Friends",
                style: MeroStyle.getStyle(width / 21),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: FloatingActionButton.extended(
                hoverElevation: 11,
                elevation: 30,
                heroTag: null,
                backgroundColor: Color.fromARGB(255, 164, 203, 236),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyLocationPage(
                      userModel: widget.userModel,
                      FirebaseUser: widget.firebaseUser,
                    );
                  }));
                },
                label: Text(
                  "Map",
                  style: MeroStyle.getStyle(width / 21),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';
// import 'dart:ui/painting.dart';
import 'package:chating_app/Chat%20Pages/ChatRoomPage.dart';
import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:chating_app/main.dart';
import 'package:chating_app/models/ChatRoomModel.dart';
// import 'package:chating_app/models/UIHelper.dart';
import 'package:chating_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User? firebaseUser;
  //
  const SearchPage({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //
  TextEditingController searchController = TextEditingController();
  String name = "";

  //
  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;
    //
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();
    if (snapshot.docs.length > 0) {
      // Fetch the existing one                           //
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoom =
          ChatRoomModel.toObject(docData as Map<String, dynamic>);
      chatRoom = existingChatRoom;
    } else {
      final result = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // backgroundColor: Colors.blue[200],
              title: Text(
                "Confirm ?",
                style: MeroStyle.getStyle(20),
              ),
              content: Text(
                "Do you want to create a new chatroom ?",
                style: MeroStyle.getStyle(20),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "Yes",
                    style: MeroStyle.getStyle(20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "No",
                    style: MeroStyle.getStyle(20),
                  ),
                )
              ],
            );
          });
      log(result.toString());
      if (result == true) {
        ChatRoomModel newChatroom = ChatRoomModel(
          chatroomid: uuid.v1(),
          createdon: DateTime.now(),
          lastMessage: "",
          participants: {
            widget.userModel.uid.toString(): true,
            targetUser.uid.toString(): true,
          },
          isLastMsgSeen: false,
          messageids: [],
        );
        //
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(newChatroom.chatroomid)
            .set(newChatroom.toMap());
        chatRoom = newChatroom;
        //
        log("new CharRoom created");
      }
    }
    return chatRoom;
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // log(widget.userModel.toString());
  // }

  //
  @override
  Widget build(BuildContext context) {
    return Consumer<themeProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
            elevation: 10,
            shadowColor: Color.fromARGB(255, 91, 35, 15),
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
                    color: Colors.blue[200],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        spreadRadius: -5,
                        offset: Offset(-5, -5),
                        blurRadius: 30,
                      )
                    ],
                  )),
            ),
            title: Container(
              color: Colors.blue[200],
              child: CupertinoSearchTextField(
                backgroundColor: Colors.white24,
                borderRadius: BorderRadius.circular(20),
                prefixIcon: Center(child: Icon(Icons.search)),
                suffixIcon: Icon(Icons.cancel),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            )),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where("fullname", isNotEqualTo: widget.userModel.fullname)
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshots.hasData) {
                    return ListView.builder(
                        itemCount: snapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          //
                          Map<String, dynamic> userMap =
                              snapshots.data!.docs[index].data()
                                  as Map<String, dynamic>;
                          //
                          UserModel searchedUser = UserModel.fromMap(userMap);

                          if (searchedUser.fullname
                              .toString()
                              .toLowerCase()
                              .contains(name.toLowerCase())) {
                            //
                            return ListTile(
                              onTap: () async {
                                ChatRoomModel? chatroomModel =
                                    await getChatroomModel(searchedUser);

                                if (chatroomModel != null) {
                                  // Navigator.pop(context);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChatRoomPage(
                                      targetUser: searchedUser,
                                      userModel: widget.userModel,
                                      chatRoom: chatroomModel,
                                      firebaseUser: widget.firebaseUser,
                                    );
                                  }));
                                } else {}
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    searchedUser.profilepic!,
                                    scale: 1.0),
                                backgroundColor: Colors.grey,
                              ),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.black,
                              ),
                              textColor: Colors.black,
                              title: Text(searchedUser.fullname!,
                                  style: MeroStyle.getStyle(20)),
                              subtitle: Text(searchedUser.email!,
                                  style: MeroStyle.getStyle(16)),
                            );
                          }
                          return Container();
                        });
                  } else {
                    return Center(child: Text("No Data Found"));
                  }
                }
              }),
        ),
      );
    });
  }
}

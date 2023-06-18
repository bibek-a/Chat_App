import 'dart:developer';

import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Group%20Chat/GroupChatRoomPage.dart';
import 'package:chating_app/Group%20Chat/GroupModel.dart';
// import 'package:chating_app/Providers/chatRoom_provider.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:chating_app/main.dart';
import 'package:chating_app/models/UIHelper.dart';
import 'package:chating_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';

class GroupCreatePage extends StatefulWidget {
  final UserModel userModel;
  const GroupCreatePage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<GroupCreatePage> createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends State<GroupCreatePage> {
  //
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  TextEditingController _controller = TextEditingController();
  String? _groupname = "";
  //
  Future<GroupModel?> getChatroomModel(GroupModel targetGroup) async {
    GroupModel? grouproom;
    //
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("groupchatroom")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("groupname", isEqualTo: targetGroup.groupname)
        .get();
    //
    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      log("Yeah this group includes you");
      var docData = snapshot.docs[0].data();
      GroupModel existingChatRoom =
          GroupModel.toObject(docData as Map<String, dynamic>);
      //
      grouproom = existingChatRoom;
    } else {
      log("Sorry this group doesnot include you");
      QuerySnapshot _snapshot = await FirebaseFirestore.instance
          .collection("groupchatroom")
          .where("groupname", isEqualTo: targetGroup.groupname)
          .where("groupRequests", arrayContains: widget.userModel.uid)
          .get();
      if (_snapshot.docs.length > 0) {
        log("Request is already sent by this user");
        UIHelper.showAlertDialog(context, "Request!!",
            "You had already sent the request Please wait until admin verifies you");
      } else {
        log("You hadnot sent the request yet");
        //Now you can sent the request
        final result = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // backgroundColor: Colors.blue[200],
                title: Text(
                  "Make Sure",
                  style: MeroStyle.getStyle(20),
                ),
                content: Text(
                  "Do you want to request admin to be the member of this group ?",
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

        if (result == true) {
          //asking request to the admin for the existing groupchat
          await FirebaseFirestore.instance
              .collection("groupchatroom")
              .doc(targetGroup.groupchatroomid)
              .update({
            "groupRequests": FieldValue.arrayUnion([widget.userModel.uid]),
          });
          // group request is saved to the firebase
          log("Group Request is sent ");
        } else {
          log("Group request isnot sent");
        }
      }
    }
    return grouproom;
  }

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    // ChatRoomProvider myProvider =
    //     Provider.of<ChatRoomProvider>(context, listen: false);
    return Consumer<themeProvider>(builder: (context, provider, child) {
      return Scaffold(
        // key: _scaffoldKey,
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
            elevation: 7,
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
                        color: Colors.black.withOpacity(0.8),
                        spreadRadius: -5,
                        offset: Offset(10, 8),
                        blurRadius: 20,
                      )
                    ],
                  )),
            ),
            // bottom: PreferredSize(
            //   preferredSize: Size(20, 20),
            //   child: Container(),
            // ),
            title: Container(
              color: Colors.blue[200],
              //
              //
              child: CupertinoTextField(
                placeholder: "Create Group......",
                placeholderStyle: TextStyle(
                  color: Color.fromARGB(255, 54, 54, 54),
                ),
                textAlign: TextAlign.justify,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                controller: _controller,
                suffix: Row(
                  children: [
                    _groupname != ""
                        ? GestureDetector(
                            onTap: () async {
                              // creating group

                              QuerySnapshot __snapshot = await FirebaseFirestore
                                  .instance
                                  .collection("groupchatroom")
                                  .where("groupname",
                                      isEqualTo: _groupname!.trim())
                                  .get();
                              if (__snapshot.docs.length > 0) {
                                log("this group name is already exist");
                                //
                                UIHelper.showAlertDialog(context, "Sorry",
                                    "This group name is already exists");
                              } else {
                                log("You can create the group with this name");
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
                                          "Do you want to create a new group '$_groupname'?",
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
                                if (result == true) {
                                  log("You are now going to create a new group");
                                  //
                                  String newDoucumentId = uuid.v1();
                                  GroupModel newGroup = GroupModel(
                                    lastSender: "",
                                    lastMessage: "",
                                    lastSenderFullname: "",
                                    // isLastMsgSeen: false,
                                    messageid: "",
                                    groupchatroomid: newDoucumentId,
                                    groupname: _groupname,
                                    groupRequests: [],
                                    groupMotto: "",
                                    createdon: DateTime.now(),
                                    nicknames: {
                                      widget.userModel.uid.toString(): "",
                                    },
                                    displaypicture:
                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png",
                                    participants: {
                                      widget.userModel.uid.toString(): true,
                                    },
                                    admin: widget.userModel.uid,
                                  );
                                  await FirebaseFirestore.instance
                                      .collection("groupchatroom")
                                      .doc(newGroup.groupchatroomid)
                                      .set(newGroup.toMap());
                                } else {
                                  log("You are not in the mood of creating this group");
                                }
                              }
                            },
                            child: Icon(
                              Icons.done,
                              color: Color.fromARGB(255, 3, 101, 7),
                              size: 25,
                            ))
                        : Container(),
                    SizedBox(width: 5),
                    GestureDetector(
                        onTap: () {
                          _controller.text = "";
                          setState(() {});
                          _groupname = "";
                        },
                        child: Icon(
                          Icons.cancel,
                          size: 20,
                        )),
                    SizedBox(width: 5),
                  ],
                ),
                onChanged: (val) {
                  setState(() {
                    _groupname = val;
                  });
                },
              ),
            )),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('groupchatroom')
                  // .where("groupname")
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
                          Map<String, dynamic> groupMap =
                              snapshots.data!.docs[index].data()
                                  as Map<String, dynamic>;
                          //
                          GroupModel searchedGroup =
                              GroupModel.toObject(groupMap);

                          if (searchedGroup.groupname
                              .toString()
                              .toLowerCase()
                              .contains(_groupname!.toLowerCase())) {
                            //
                            return ListTile(
                              onTap: () async {
                                GroupModel? groupRoomModel =
                                    await getChatroomModel(searchedGroup);
                                if (groupRoomModel != null) {
                                  // Navigator.pop(context);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return GroupChatRoomPage(
                                      currentGroup: searchedGroup,
                                      userModel: widget.userModel,
                                      // chatRoom: groupRoomModel,
                                      // firebaseUser: widget.firebaseUser,
                                    );
                                  }));
                                } else {}
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  searchedGroup.displaypicture!,
                                ),
                                backgroundColor: Colors.grey,
                              ),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.black,
                              ),
                              textColor: Colors.black,
                              title: Text(searchedGroup.groupname!,
                                  style: MeroStyle.getStyle(20)),
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

import 'dart:developer';
// import 'dart:io';

import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Group%20Chat/GroupModel.dart';
// import 'package:chating_app/Models/UIHelper.dart';
import 'package:chating_app/Providers/GroupChatProvider.dart';
import 'package:chating_app/Providers/chatRoom_provider.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:chating_app/models/FirebaseHelper.dart';
// import 'package:chating_app/models/UIHelper.dart';
import 'package:chating_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
// import "package:flutter/src/material/checkbox.dart";

class GroupInfoPage extends StatefulWidget {
  final GroupModel currentGroup;
  final UserModel userModel;
  // final User? firebaseUser;

  const GroupInfoPage(
      {Key? key,
      required this.userModel,
      // this.firebaseUser,
      required this.currentGroup})
      : super(key: key);

  // const GroupInfoPage({super.key});

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  bool isTapped = false;
  //
  List<UserModel>? selectedUser = [];
  //
  Future<UserModel?> checkInfo(UserModel suggestedUser) async {
    //

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("groupchatroom")
        .where("participants.${suggestedUser.uid}", isEqualTo: true)
        // .where("groupRequests", arrayContains: suggestedUser.uid)
        .where("groupname", isEqualTo: widget.currentGroup.groupname)
        .get();
    if (snapshot.docs.length > 0) {
      //
      log("Yes ${suggestedUser.fullname} is the member of this group");
      return null;
    } else {
      //
      log("No ${suggestedUser.fullname} is not the member of this group");
      //
      QuerySnapshot _snapshot = await FirebaseFirestore.instance
          .collection("groupchatroom")
          // .where("participants.${suggestedUser.uid}", isEqualTo: true)
          .where("groupRequests", arrayContains: suggestedUser.uid)
          .where("groupname", isEqualTo: widget.currentGroup.groupname)
          .get();
      //
      if (_snapshot.docs.length > 0) {
        log("Yes ${suggestedUser.fullname} has already sent the request for this group");
        return null;
      } else {
        // _index++;
        return suggestedUser;
      }
    }
  }

  bool value = false;
  //
  // String? __searchedText = "";
  //
  TextEditingController _controller = TextEditingController();
  //
  Future<void> __handleRefresh() async {
    setState(() {});
    return await Future.delayed(
      Duration(milliseconds: 1000),
    );
  }

  //
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    ChatRoomProvider myProvider =
        Provider.of<ChatRoomProvider>(context, listen: false);
    //
    return Consumer<themeProvider>(builder: (context, provider, child) {
      return Scaffold(
          backgroundColor: provider.themeMode == ThemeMode.light
              ? Color.fromARGB(255, 145, 189, 225)
              : Color.fromARGB(255, 27, 26, 26),
          appBar: AppBar(
            elevation: 7,
            shadowColor: Color.fromARGB(255, 51, 19, 7),
            backgroundColor: provider.themeMode == ThemeMode.dark
                ? Color.fromARGB(255, 123, 117, 117)
                : Colors.blue[200],
            leading: Padding(
              padding: const EdgeInsets.all(5.0),
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
                        color: Colors.black.withOpacity(0.8),
                        spreadRadius: -7,
                        offset: Offset(10, 8),
                        blurRadius: 20,
                      )
                    ],
                  )),
            ),
            title: Text(
              "Group Information",
              style: MeroStyle.getStyle(width / 17),
            ),
          ),
          body: RefreshIndicator(
            color: Colors.black,
            backgroundColor: Color.fromARGB(255, 160, 207, 246),
            onRefresh: __handleRefresh,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    widget.currentGroup.admin == widget.userModel.uid
                        ? Text(
                            "Admin Panel ",
                            style: MeroStyle.getStyle(width / 17),
                          )
                        : Container(),

                    Padding(
                        padding: const EdgeInsets.only(top: 00007),
                        child: GestureDetector(
                          onTap: () {
                            myProvider.checkInternet();
                            log("${myProvider.hasInternet}");
                            if (myProvider.hasInternet) {
                              // showPhotoOptions();
                            } else {
                              // UIHelper.showAlertDialog(
                              //     context,
                              //     "An error Occured",
                              //     "Please Check Your Internet Connection");
                            }
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                                widget.currentGroup.displaypicture!),
                          ),
                        )),
                    //
                    SizedBox(height: 10),
                    _controller.text == ""
                        ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("groupchatroom")
                                .where("groupchatroomid",
                                    isEqualTo:
                                        widget.currentGroup.groupchatroomid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: Container());
                              } else {
                                if (snapshot.hasData) {
                                  QuerySnapshot groupChatRoomSnapshot =
                                      snapshot.data as QuerySnapshot;

                                  GroupModel groupModel = GroupModel.toObject(
                                      groupChatRoomSnapshot.docs[0].data()
                                          as Map<String, dynamic>);
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      groupModel.groupname!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: width / 16,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Container(),
                                  );
                                }
                              }
                            })
                        : Container(),
                    SizedBox(height: 2),
                    // widget.currentGroup.groupMotto != ""
                    //     ? Padding(
                    //         padding: const EdgeInsets.symmetric(vertical: 0),
                    //         child: Text(' "${widget.currentGroup.groupMotto}"',
                    //             style: TextStyle(
                    //               color: Color.fromARGB(255, 1, 32, 2),
                    //               fontWeight: FontWeight.w500,
                    //               fontSize: 17,
                    //             )),
                    //       )
                    //     : GestureDetector(
                    //         onTap: () {
                    //           changeGroupMotto();
                    //         },
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //             color: Colors.blue[200],
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 color: Colors.black.withOpacity(0.8),
                    //                 spreadRadius: -7,
                    //                 offset: Offset(10, 8),
                    //                 blurRadius: 20,
                    //               ),
                    //             ],
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(3.0),
                    //             child: Text(
                    //               "Group Motto will be appeared here, change it",
                    //               style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontWeight: FontWeight.w500,
                    //                 fontSize: 10,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    SizedBox(height: 30),
                    // Padding(
                    //     padding: const EdgeInsets.all(20.0),
                    //     child: CupertinoTextField(
                    //       placeholder: "Add member......",
                    //       placeholderStyle: TextStyle(
                    //         color: Color.fromARGB(255, 0, 0, 0),
                    //       ),
                    //       textAlign: TextAlign.justify,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(20),
                    //         color: Color.fromARGB(255, 213, 211, 211),
                    //       ),
                    //       controller: _controller,
                    //       onChanged: (val) {
                    //         __searchedText = val;
                    //         setState(() {});
                    //       },
                    //       suffix: Row(
                    //         children: [
                    //           SizedBox(width: 5),
                    //           __searchedText != ""
                    //               ? GestureDetector(
                    //                   onTap: () {
                    //                     _controller.text = "";
                    //                     __searchedText = "";
                    //                     setState(() {});
                    //                   },
                    //                   child: Icon(
                    //                     Icons.cancel,
                    //                     size: 20,
                    //                   ))
                    //               : Container(),
                    //           SizedBox(width: 5),
                    //         ],
                    //       ),
                    //     )),
                    // _controller.text == "" ? SizedBox(height: 10) : Container(),
                    // _controller.text == ""
                    //     ?
                    GestureDetector(
                      onTap: () async {
                        changeGroupName();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 14),
                          Container(
                            child: Icon(Icons.edit),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Change Group Name",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 21,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    // : Container(),
                    // _controller.text == "" ? SizedBox(height: 20) : Container(),
                    // _controller.text == ""
                    //     ?
                    GestureDetector(
                      onTap: () async {
                        editNicknames();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 14),
                          Container(
                            child: Icon(CupertinoIcons.hand_draw_fill),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Edit Nicknames",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 21,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // : Container(),
                    // _controller.text == "" ? SizedBox(height: 20) : Container(),
                    // _controller.text == ""
                    //     ?
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        log(widget.currentGroup.groupchatroomid.toString());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 14),
                          Container(
                            child: Icon(
                              CupertinoIcons.search,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Search in Conversation",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 21,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // : Container(),

                    // _controller.text == "" ? SizedBox(height: 20) : Container(),
                    // _controller.text != ""
                    //     ?
                    //  StreamBuilder<QuerySnapshot>(
                    //     stream: FirebaseFirestore.instance
                    //         .collection('users')
                    //         .where("fullname",
                    //             isNotEqualTo: widget.userModel.fullname)
                    //         .snapshots(),
                    //     builder: (context, snapshots) {
                    //       if (snapshots.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return Center(
                    //           child: Container(),
                    //         );
                    //       } else {
                    //         if (snapshots.hasData) {
                    //           return Container(
                    //               height: 200,
                    //               child: ListView.builder(
                    //                 shrinkWrap: true,
                    //                 itemCount: snapshots.data!.docs.length,
                    //                 itemBuilder: (context, index) {
                    //                   //
                    //                   Map<String, dynamic> userMap =
                    //                       snapshots.data!.docs[index].data()
                    //                           as Map<String, dynamic>;
                    //                   //
                    //                   UserModel searchedUser =
                    //                       UserModel.fromMap(userMap);
                    //                   // log(searchedUser.fullname!);

                    //                   //
                    //                   return FutureBuilder(
                    //                     future: checkInfo(searchedUser),
                    //                     builder: ((context, snapshots) {
                    //                       if (snapshots.hasData) {
                    //                         //
                    //                         UserModel targetUser =
                    //                             snapshots.data as UserModel;

                    //                         if (searchedUser.fullname
                    //                             .toString()
                    //                             .toLowerCase()
                    //                             .contains(__searchedText!
                    //                                 .toLowerCase())) {
                    //                           return ListTile(
                    //                               leading: CircleAvatar(
                    //                                 backgroundColor:
                    //                                     Colors.grey,
                    //                                 backgroundImage:
                    //                                     NetworkImage(
                    //                                         targetUser
                    //                                             .profilepic!),
                    //                               ),
                    //                               title: Text(
                    //                                 targetUser.fullname!,
                    //                                 style:
                    //                                     MeroStyle.getStyle(
                    //                                         20),
                    //                               ),
                    //                               subtitle: Text(
                    //                                 targetUser.email!,
                    //                                 style:
                    //                                     MeroStyle.getStyle(
                    //                                         17),
                    //                               ),
                    //                               trailing: Consumer<
                    //                                   GroupProvider>(
                    //                                 builder: (context,
                    //                                         gprovider,
                    //                                         child) =>
                    //                                     Checkbox(
                    //                                   side: BorderSide(
                    //                                     color: Colors.black,
                    //                                   ),
                    //                                   activeColor:
                    //                                       Color.fromARGB(
                    //                                           255,
                    //                                           6,
                    //                                           136,
                    //                                           10),
                    //                                   checkColor:
                    //                                       Color.fromARGB(
                    //                                           255,
                    //                                           18,
                    //                                           18,
                    //                                           18),
                    //                                   value: index ==
                    //                                           gprovider
                    //                                               .selectedIndex
                    //                                       ? gprovider
                    //                                           .isChecked
                    //                                       : false,
                    //                                   onChanged: (val) {
                    //                                     gprovider.addMember(
                    //                                         val, index);
                    //                                     if (val!) {
                    //                                       log(targetUser
                    //                                               .fullname! +
                    //                                           " is added");
                    //                                       selectedUser!.add(
                    //                                           targetUser);
                    //                                     }
                    //                                   },
                    //                                 ),
                    //                               ));
                    //                         }
                    //                       }
                    //                       return Container();
                    //                     }),
                    //                   );

                    //                   // return Container();
                    //                 },
                    //               )

                    //               // return Container();

                    //               );
                    //         } else {
                    //           return Center(child: Text("No Data Found"));
                    //         }
                    //       }
                    //     }),
                    // :
                    SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Text(
                            "Admin :",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        FutureBuilder(
                          future: FirebaseHelper.getUserModelById(
                              widget.currentGroup.admin!),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.hasData) {
                                UserModel admin = userData.data as UserModel;

                                return ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 015),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage:
                                        NetworkImage(admin.profilepic!),
                                  ),
                                  title: Text(
                                    admin.fullname!,
                                    style: MeroStyle.getStyle(20),
                                  ),
                                  subtitle: Text(
                                    admin.email!,
                                    style: MeroStyle.getStyle(18),
                                  ),
                                );
                              }
                            } else {
                              return Container();
                            }
                            return Container();
                          },
                        ),
                        SizedBox(height: 5),
                        widget.currentGroup.admin == widget.userModel.uid
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('groupchatroom')
                                        .where("groupchatroomid",
                                            isEqualTo: widget
                                                .currentGroup.groupchatroomid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.active) {
                                        if (snapshot.data!.docs.length > 0) {
                                          if (snapshot.hasData) {
                                            // QuerySnapshot groupSnap =
                                            //     snapshot.data as QuerySnapshot;
                                            // var datalen = groupSnap.docs.length;
                                            log("group request number: " +
                                                widget.currentGroup
                                                    .groupRequests!.length
                                                    .toString());

                                            return ListView.builder(
                                              physics: NeverScrollableScrollPhysics(
                                                  parent:
                                                      NeverScrollableScrollPhysics()),
                                              // physics: BouncingScrollPhysics(
                                              //     parent:
                                              //         AlwaysScrollableScrollPhysics()),
                                              shrinkWrap: true,
                                              itemCount: widget
                                                  .currentGroup.groupRequests!
                                                  .toList()
                                                  .length, //
                                              itemBuilder: (context, index) {
                                                log("group request number: " +
                                                    widget.currentGroup
                                                        .groupRequests!
                                                        .toList()
                                                        .length
                                                        .toString());
                                                // GroupModel mygroupmodel =
                                                // GroupModel.toObject(
                                                //     groupSnap.docs[0].data()
                                                //         as Map<String,
                                                //             dynamic>);

                                                List<String>
                                                    groupRequestIDList = widget
                                                        .currentGroup
                                                        .groupRequests!
                                                        .toList()
                                                        .cast();

                                                //
                                                String memberUserUid =
                                                    groupRequestIDList[index];
                                                //

                                                return FutureBuilder(
                                                  future: FirebaseHelper
                                                      .getUserModelById(
                                                          memberUserUid),
                                                  builder: (context, userData) {
                                                    if (userData
                                                            .connectionState ==
                                                        ConnectionState.done) {
                                                      if (userData.hasData) {
                                                        UserModel
                                                            groupRequestUser =
                                                            userData.data
                                                                as UserModel;

                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          14.0),
                                                              child: Text(
                                                                "Group Requests :",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 24,
                                                                ),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              onTap: () async {
                                                                allowGroupRequest(
                                                                    groupRequestUser);
                                                              },
                                                              trailing: Icon(
                                                                Icons
                                                                    .keyboard_arrow_right,
                                                                size: 30,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          015),
                                                              leading:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors.grey,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        groupRequestUser
                                                                            .profilepic!),
                                                              ),
                                                              title: Text(
                                                                groupRequestUser
                                                                    .fullname!,
                                                                style: MeroStyle
                                                                    .getStyle(
                                                                        20),
                                                              ),
                                                              subtitle: Text(
                                                                groupRequestUser
                                                                    .email!,
                                                                style: MeroStyle
                                                                    .getStyle(
                                                                        18),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    } else {
                                                      return Container();
                                                    }
                                                    return Container();
                                                  },
                                                );
                                                // return ListTile();
                                              },
                                            );
                                          }
                                        } else {
                                          return Center(
                                              child: Text("No data found"));
                                        }
                                      } else {
                                        return Center(
                                          child: Center(
                                              // color: Colors.red,
                                              ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Text(
                            "Members :",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(height: 0),
                        Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('groupchatroom')
                                    .where("groupchatroomid",
                                        isEqualTo:
                                            widget.currentGroup.groupchatroomid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    if (snapshot.data!.docs.length > 0) {
                                      if (snapshot.hasData) {
                                        // QuerySnapshot groupSnap =
                                        //     snapshot.data as QuerySnapshot;
                                        // var datalen = groupSnap.docs.length;
                                        // log(datalen.toString());

                                        return ListView.builder(
                                          physics: NeverScrollableScrollPhysics(
                                              parent:
                                                  NeverScrollableScrollPhysics()),
                                          shrinkWrap: true,
                                          itemCount: widget
                                              .currentGroup.participants!.keys
                                              .toList()
                                              .length, //2
                                          itemBuilder: (context, index) {
                                            // GroupModel mygroupmodel =
                                            //     GroupModel.toObject(groupSnap
                                            //             .docs[0]
                                            //             .data()
                                            //         as Map<String, dynamic>);
                                            final nickname = widget
                                                .currentGroup.nicknames!.values
                                                .elementAt(index)
                                                .toString(); //
                                            final myNickname = nickname != ""
                                                ? "(" +
                                                    widget.currentGroup
                                                        .nicknames!.values
                                                        .elementAt(index)
                                                        .toString() +
                                                    ")"
                                                : "";
                                            List<String> memberUserIdList =
                                                widget.currentGroup
                                                    .participants!.keys
                                                    .toList();
                                            //
                                            String memberUserUid =
                                                memberUserIdList[index];
                                            //

                                            return FutureBuilder(
                                              future: FirebaseHelper
                                                  .getUserModelById(
                                                      memberUserUid),
                                              builder: (context, userData) {
                                                if (userData.connectionState ==
                                                    ConnectionState.done) {
                                                  if (userData.hasData) {
                                                    UserModel memberUser =
                                                        userData.data
                                                            as UserModel;

                                                    return ListTile(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 015),
                                                      leading: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.grey,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                memberUser
                                                                    .profilepic!),
                                                      ),
                                                      trailing: Text(
                                                        memberUser.status!,
                                                        style:
                                                            MeroStyle.getStyle(
                                                                width / 30),
                                                      ),
                                                      title: Text(
                                                        memberUser.fullname! +
                                                            " " +
                                                            myNickname,
                                                        style:
                                                            MeroStyle.getStyle(
                                                                20),
                                                      ),
                                                      subtitle: Text(
                                                        memberUser.email!,
                                                        style:
                                                            MeroStyle.getStyle(
                                                                18),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  return Container();
                                                }
                                                return Container();
                                              },
                                            );
                                            // return ListTile();
                                          },
                                        );
                                      }
                                    } else {
                                      return Center(
                                          child: Text("No data found"));
                                    }
                                  } else {
                                    return Center(
                                      child: Center(
                                          // color: Colors.red,
                                          ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
    });
  }

  late BuildContext scaffoldContext;
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();

//
//
  changeGroupName() {
    // bool showerror = false;
    _groupNameController.text = widget.currentGroup.groupname.toString();
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Colors.black
              : Color.fromARGB(255, 146, 193, 232),
      title: Text("Change Group Name",
          style: Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? MeroStyle.getStyle2(20)
              : MeroStyle.getStyle(20)),
      content: Consumer<GroupProvider>(
        builder: (context, gprovider, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoTextField(
              controller: _groupNameController,
              // autofocus: true,
              onChanged: (val) {
                gprovider.showMessageForGroupName(val);
                // _groupNameController.text = val;
              },
            ),
            SizedBox(height: 10),
            Text(
              gprovider.message.toString(),
              style: TextStyle(
                fontSize: 16,
                color: gprovider.messageColor,
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_groupNameController.text.length > 3) {
              widget.currentGroup.groupname = _groupNameController.text;

              await FirebaseFirestore.instance
                  .collection("groupchatroom")
                  .doc(widget.currentGroup.groupchatroomid)
                  .update({
                "groupname": _groupNameController.text,
              });
              log("succeed");
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    duration: const Duration(seconds: 4),
                    backgroundColor: Color.fromARGB(255, 141, 193, 236),
                    content: Text(
                      "Group Name Updated, appears soon!!",
                      style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 2, 54, 6),
                      ),
                    )),
              );
            } else {
              log("cannot save");
            }
          },
          child: Text("Save",
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 3, 74, 4),
              )),
        ),
        TextButton(
          onPressed: () {
            Provider.of<GroupProvider>(context, listen: false).message = "";
            Provider.of<GroupProvider>(context, listen: false).isOkay = true;
            Navigator.pop(context);
          },
          child: Text("Cancel",
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 62, 47, 2),
              )),
        )
      ],
    );
    showDialog(
        barrierColor: Color.fromARGB(255, 132, 187, 233).withOpacity(0.7),
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return alertDialog;
        });
  }

//
//
//

  editNicknames() {
    showDialog(
        barrierColor: Color.fromARGB(255, 132, 187, 233).withOpacity(0.6),
        // barrierLabel: "nvv",
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            scrollable: true,
            clipBehavior: Clip.hardEdge,
            backgroundColor: Color.fromARGB(255, 146, 193, 232),
            titlePadding: EdgeInsets.all(0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Text(
                    "Nicknames",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Icon(
                    Icons.cancel,
                    size: 40,
                    color: Color.fromARGB(255, 35, 35, 35),
                  ),
                )
              ],
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 05),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  child: Container(
                    color: Color.fromARGB(255, 146, 193, 232),
                    height: 200,
                    width: 400,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      // shrinkWrap: true,
                      itemCount: widget.currentGroup.participants!.keys
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        //
                        List<String> memberUserIdList =
                            widget.currentGroup.participants!.keys.toList();
                        //
                        String memberUserUid = memberUserIdList[index];

                        return FutureBuilder(
                          future:
                              FirebaseHelper.getUserModelById(memberUserUid),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.hasData) {
                                UserModel memberUser =
                                    userData.data as UserModel;

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    onTap: () {
                                      log("changing nicknames");
                                      // log(widget.currentGroup.groupchatroomid
                                      //     .toString());
                                      _nicknameController.text = widget
                                          .currentGroup.nicknames!.values
                                          .elementAt(index);
                                      // log(widget.currentGroup.nicknames!.values
                                      //     .elementAt(index));

                                      AlertDialog alertDialog = AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor:
                                            Provider.of<themeProvider>(context,
                                                            listen: false)
                                                        .themeMode ==
                                                    ThemeMode.dark
                                                ? Colors.black
                                                : Color.fromARGB(
                                                    255, 146, 193, 232),
                                        content: Consumer<GroupProvider>(
                                          builder:
                                              (context, gprovider, child) =>
                                                  Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CupertinoTextField(
                                                controller: _nicknameController,
                                                // autofocus: true,
                                                onChanged: (val) {
                                                  gprovider
                                                      .showMessageForNickname(
                                                          val);
                                                  // _groupNameController.text = val;
                                                },
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                gprovider.message.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: gprovider.messageColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              // String keys = widget
                                              //     .currentGroup.nicknames!.keys
                                              //     .toList()
                                              //     .toString();
                                              log("uid is " + memberUser.uid!);

                                              if (_nicknameController
                                                      .text.length !=
                                                  0) {
                                                widget.currentGroup.nicknames!
                                                    .update(
                                                        memberUser.uid!,
                                                        (value) =>
                                                            _nicknameController
                                                                .text);
                                                //
                                                await FirebaseFirestore.instance
                                                    .collection("groupchatroom")
                                                    .doc(widget.currentGroup
                                                        .groupchatroomid)
                                                    .set(widget.currentGroup
                                                        .toMap())
                                                    .then((value) => log(
                                                        "success updated the nickname"));
                                                //
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      duration: const Duration(
                                                          seconds: 4),
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              136, 193, 239),
                                                      content: Text(
                                                        "Update Succeed, appears soon!!",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Color.fromARGB(
                                                              255, 7, 57, 2),
                                                        ),
                                                      )),
                                                );
                                              } else {
                                                log("Something went wrong");
                                              }
                                            },
                                            child: Text("Save",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 3, 74, 4),
                                                )),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Provider.of<GroupProvider>(
                                                      context,
                                                      listen: false)
                                                  .message = "";
                                              Provider.of<GroupProvider>(
                                                      context,
                                                      listen: false)
                                                  .isOkay = true;
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancel",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 62, 47, 2),
                                                )),
                                          )
                                        ],
                                      );
                                      showDialog(
                                          barrierColor:
                                              Color.fromARGB(255, 132, 187, 233)
                                                  .withOpacity(0.6),
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return alertDialog;
                                          });
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          NetworkImage(memberUser.profilepic!),
                                    ),
                                    title: Text(
                                      memberUser.fullname!,
                                      style: MeroStyle.getStyle(20),
                                    ),
                                    subtitle: Text(
                                      memberUser.email!,
                                      style: MeroStyle.getStyle(18),
                                    ),
                                    trailing: Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Container();
                            }
                            return Container();
                          },
                        );
                        // return ListTile();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

//
//
//
  allowGroupRequest(UserModel groupRequestUser) {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Colors.black
              : Color.fromARGB(255, 146, 193, 232),
      title: Text("Sure ",
          style: Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? MeroStyle.getStyle2(20)
              : MeroStyle.getStyle(20)),
      content: Consumer<GroupProvider>(
        builder: (context, gprovider, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection("groupchatroom")
                .doc(widget.currentGroup.groupchatroomid)
                .update({
              "groupRequests": FieldValue.arrayRemove([groupRequestUser.uid]),
            }).then((value) => log("This user got access for the group"));
            //
            await FirebaseFirestore.instance
                .collection("groupchatroom")
                .doc(widget.currentGroup.groupchatroomid)
                .set({
              "participants": {
                groupRequestUser.uid: true,
              },
              "nicknames": {
                groupRequestUser.uid: "",
              }
            }, SetOptions(merge: true));

            Navigator.pop(context);
          },
          child: Text("Allow Access",
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 3, 74, 4),
              )),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Not allow",
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 62, 47, 2),
              )),
        )
      ],
    );
    showDialog(
        barrierColor: Color.fromARGB(255, 132, 187, 233).withOpacity(0.7),
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return alertDialog;
        });
  }

  TextEditingController groupMottoController = TextEditingController();
//
  // changeGroupMotto() {
  //   AlertDialog alertDialog = AlertDialog(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     backgroundColor:
  //         Provider.of<themeProvider>(context, listen: false).themeMode ==
  //                 ThemeMode.dark
  //             ? Colors.black
  //             : Color.fromARGB(255, 146, 193, 232),
  //     title: Text("Group Motto ",
  //         style: Provider.of<themeProvider>(context, listen: false).themeMode ==
  //                 ThemeMode.dark
  //             ? MeroStyle.getStyle2(20)
  //             : MeroStyle.getStyle(20)),
  //     content: Consumer<GroupProvider>(
  //       builder: (context, gprovider, child) => Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           CupertinoTextField(
  //             controller: groupMottoController,
  //             onChanged: (val) {
  //               gprovider.showMessageForGroupName(val);
  //               // _groupNameController.text = val;
  //             },
  //           ),
  //           SizedBox(height: 10),
  //           Text(
  //             gprovider.message.toString(),
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: gprovider.messageColor,
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //     actions: [
  //       TextButton(
  //         onPressed: () async {
  //           if (groupMottoController.text.length > 3) {
  //             widget.currentGroup.groupname = _groupNameController.text;
  //             await FirebaseFirestore.instance
  //                 .collection("groupchatroom")
  //                 .doc(widget.currentGroup.groupchatroomid)
  //                 .update({
  //               "groupMotto": groupMottoController.text,
  //             });
  //             log("succeed");
  //             Navigator.pop(context);
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                   duration: const Duration(seconds: 4),
  //                   backgroundColor: Color.fromARGB(255, 141, 193, 236),
  //                   content: Text(
  //                     "Group Motto Updated, appears soon!!",
  //                     style: TextStyle(
  //                       fontSize: 17,
  //                       color: Color.fromARGB(255, 2, 54, 6),
  //                     ),
  //                   )),
  //             );
  //           } else {
  //             log("cannot save");
  //           }
  //         },
  //         child: Text("Save",
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Color.fromARGB(255, 3, 74, 4),
  //             )),
  //       ),
  //       TextButton(
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         child: Text("cancel",
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Color.fromARGB(255, 62, 47, 2),
  //             )),
  //       )
  //     ],
  //   );
  //   showDialog(
  //       barrierColor: Color.fromARGB(255, 132, 187, 233).withOpacity(0.7),
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return alertDialog;
  //       });
  // }
}

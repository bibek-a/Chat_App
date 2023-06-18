import 'package:chating_app/Constants/Style.dart';
import 'package:chating_app/Group%20Chat/CreateGroupPage.dart';
import 'package:chating_app/Group%20Chat/GroupChatRoomPage.dart';
import 'package:chating_app/Group%20Chat/GroupModel.dart';
import 'package:chating_app/Providers/theme_provider.dart';
import 'package:chating_app/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GroupChatHomeScreen extends StatefulWidget {
  final UserModel userModel;
  const GroupChatHomeScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<GroupChatHomeScreen> createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  Future<void> __handleRefresh() async {
    setState(() {});
    return await Future.delayed(
      Duration(milliseconds: 700),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Provider.of<themeProvider>(context, listen: false).themeMode ==
                  ThemeMode.dark
              ? Color.fromARGB(255, 0, 0, 0)
              : Colors.blue[200],
    ));
    // final Size size = MediaQuery.of(context).size;
    return Consumer<themeProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: provider.themeMode == ThemeMode.light
            ? Color.fromARGB(255, 132, 184, 226)
            : Color.fromARGB(255, 27, 26, 26),
        appBar: AppBar(
          elevation: 7,
          shadowColor: Color.fromARGB(255, 41, 16, 7),
          backgroundColor: provider.themeMode == ThemeMode.dark
              ? Color.fromARGB(255, 123, 117, 117)
              : Colors.blue[200],
          iconTheme: IconThemeData(color: Colors.black),
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
          title: Text(
            "Groups",
            style:
                Provider.of<themeProvider>(context, listen: false).themeMode ==
                        ThemeMode.light
                    ? MeroStyle.getStyle(24)
                    : MeroStyle.getStyle2(24),
          ),
          // centerTitle: true,
        ),
        body: RefreshIndicator(
          color: Colors.black,
          backgroundColor: Colors.blue[200],
          onRefresh: __handleRefresh,
          child: Container(
            // alignment: Alignment.center,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("groupchatroom")
                  .where("participants.${widget.userModel.uid}",
                      isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasData) {
                    QuerySnapshot groupChatRoomSnapshot =
                        snapshot.data as QuerySnapshot;
                    return ListView.builder(
                        itemCount: groupChatRoomSnapshot.docs.length,
                        //
                        itemBuilder: (context, index) {
                          GroupModel groupModel = GroupModel.toObject(
                              groupChatRoomSnapshot.docs[index].data()
                                  as Map<String, dynamic>);
                          //

                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return GroupChatRoomPage(
                                  currentGroup: groupModel,
                                  userModel: widget.userModel,
                                );
                              }));
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 28,
                              backgroundImage:
                                  NetworkImage(groupModel.displaypicture!),
                            ),
                            title: Text(
                              groupModel.groupname.toString(),
                              style: MeroStyle.getStyle(23),
                            ),
                            subtitle: Row(
                              children: [
                                groupModel.lastSenderFullname ==
                                        widget.userModel.fullname
                                    ? Text(
                                        "You",
                                        style: MeroStyle.getStyle(19),
                                      )
                                    : Text(
                                        groupModel.lastSenderFullname!
                                            .split(" ")[0],
                                        style: MeroStyle.getStyle(19),
                                      ),
                                groupModel.lastMessage != ""
                                    ? groupModel.lastMessage ==
                                            "Message Deleted"
                                        ? Flexible(
                                            fit: FlexFit.tight,
                                            child: Text(
                                              groupModel.lastMessage!
                                                  .split("\n")[0],
                                              overflow: TextOverflow.ellipsis,
                                              style: MeroStyle.getStyle(20),
                                            ),
                                          )
                                        : Flexible(
                                            fit: FlexFit.tight,
                                            child: Text(
                                              ": " +
                                                  groupModel.lastMessage!
                                                      .split("\n")[0],
                                              overflow: TextOverflow.ellipsis,
                                              style: MeroStyle.getStyle(20),
                                            ),
                                          )
                                    : Text(
                                        "New Group",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 5, 70, 124),
                                            fontSize: 17),
                                      )
                              ],
                            ),
                          );
                        });
                  } else {
                    return Text("No data Found");
                  }
                }
                // return Container();
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return GroupCreatePage(
                userModel: widget.userModel,

                // firebaseUser: widget.firebaseUser,
              );
            }));
          },
          backgroundColor: Colors.blue[200],
          child: Icon(
            Icons.group_add,
            color: Colors.black,
          ),
        ),
      );
    });
  }
}

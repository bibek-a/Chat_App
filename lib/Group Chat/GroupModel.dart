// import 'package:chating_app/models/UserModel.dart';

class GroupModel {
  Map<String, dynamic>? participants;
  Map<String, dynamic>? nicknames;
  String? groupname;
  String? groupchatroomid;
  String? displaypicture;
  String? messageid;
  List<dynamic>? groupRequests;
  String? groupMotto;
  DateTime? createdon;
  String? lastSender;
  String? lastMessage;
  String? lastSenderFullname;
  // bool? isLastMsgSeen;
  String? admin;
  // String? status;

//
//
  GroupModel({
    this.groupname,
    this.displaypicture,
    this.groupchatroomid,
    this.participants,
    this.lastSenderFullname,
    this.groupRequests,
    this.groupMotto,
    this.lastSender,
    this.createdon,
    this.nicknames,
    // this.isLastMsgSeen,
    this.lastMessage,
    this.messageid,
    this.admin,
  });
  //
  //
  GroupModel.toObject(Map<String, dynamic> map) {
    groupname = map["groupname"];
    groupMotto = map["groupMotto"];
    nicknames = map["nicknames"];
    groupchatroomid = map["groupchatroomid"];
    participants = map["participants"];
    displaypicture = map["displaypicture"];
    groupRequests = map["groupRequests"];
    messageid = map["messageid"];
    lastMessage = map["lastMessage"];
    createdon =
        map["createdon"] == null ? DateTime.now() : map["createdon"].toDate();
    lastSender = map["lastSender"];
    // isLastMsgSeen = map["isLastMsgSeen"];
    lastSenderFullname = map["lastSenderFullname"];
    admin = map["admin"];
    // status = map["status"];
  }
  //
  Map<String, dynamic> toMap() {
    return {
      // "uid": uid,
      "groupchatroomid": groupchatroomid,
      "groupname": groupname,
      "nicknames": nicknames,
      "participants": participants,
      "groupMotto": groupMotto,
      "createdon": createdon,
      "messageid": messageid,
      "displaypicture": displaypicture,
      // "isLastMsgSeen": isLastMsgSeen,
      "groupRequests": groupRequests,
      "lastMessage": lastMessage,
      "lastSenderFullname": lastSenderFullname,
      "lastSender": lastSender,
      "admin": admin,
    };
  }
  //
  //
}

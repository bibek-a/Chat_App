class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  List<dynamic>? messageids;

  String? lastMessage;
  String? lastSender;
  String? lastSenderFullname;
  DateTime? createdon;
  bool? isLastMsgSeen = false;
  //
  ChatRoomModel({
    this.lastMessage,
    this.chatroomid,
    this.participants,
    required this.messageids,
    this.lastSender,
    this.lastSenderFullname,
    this.createdon,
    this.isLastMsgSeen = false,
  });
  //

  ChatRoomModel.toObject(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    lastSender = map["lastSender"];
    messageids = map["messageids"];
    lastSenderFullname = map["lastSenderFullname"];
    createdon = map["createdon"] == null
        ? map["createdon"].toDate()
        : map["createdon"].toDate();
    isLastMsgSeen = map["isLastMsgSeen"];
  }
  //

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "messageids": messageids,
      "participants": participants,
      "lastmessage": lastMessage,
      "lastSender": lastSender,
      "lastSenderFullname": lastSenderFullname,
      "createdon": createdon,
      "isLastMsgSeen": isLastMsgSeen,
    };
  }
}

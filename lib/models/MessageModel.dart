class MessageModel {
  String? sender;
  String? text;
  bool? seen;
  String? messageid;
  DateTime? createdon;
  String? msgType;
  String? ImageFile;

//
//
  MessageModel({
    this.messageid,
    this.sender,
    this.text,
    this.seen,
    this.createdon,
    this.msgType,
    this.ImageFile,
  });
  //
  //
  MessageModel.toObject(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"] == null
        ? map["createdon"].toDate()
        : map["createdon"].toDate();

    msgType = map["msgType"];
    ImageFile = map["ImageFile"];
  }
  //
  //
  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon,
      "msgType": msgType,
      "ImageFile": ImageFile,
    };
  }
}

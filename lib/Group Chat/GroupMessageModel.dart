class GroupMessageModel {
  String? sender;
  String? text;
  List<dynamic>? seener;
  String? messageid;
  DateTime? createdon;
  String? msgType;
  String? senderDP;
  String? ImageFile;

//
//
  GroupMessageModel({
    this.messageid,
    this.sender,
    this.text,
    this.seener,
    this.createdon,
    this.senderDP,
    this.msgType,
    this.ImageFile,
  });
  //
  //
  GroupMessageModel.toObject(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    seener = map["seener"];
    createdon = map["createdon"] == null
        ? map["createdon"].toDate()
        : map["createdon"].toDate();
    msgType = map["msgType"];
    senderDP = map["senderDP"];
    ImageFile = map["ImageFile"];
  }
  //
  //
  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "seener": seener,
      "createdon": createdon,
      "senderDP": senderDP,
      "msgType": msgType,
      "ImageFile": ImageFile,
    };
  }
}

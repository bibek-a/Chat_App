class FeedBack {
  String? message;
  String? emoji;
  String? issues;
//
  FeedBack({
    this.message,
    this.emoji,
    this.issues,
  });
//
  FeedBack.toObject(Map<String, dynamic> map) {
    message = map["message"];
    emoji = map["emoji"];
    issues = map["issues"];
  }
//
  Map<String, dynamic> toMap() {
    return {
      "messsage": message,
      "emoji": emoji,
      "issues": issues,
    };
  }
  //
}

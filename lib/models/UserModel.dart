class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;
  String? status;
  Map<String, dynamic>? location;
  String? password;

//
//
  UserModel({
    this.uid,
    this.fullname,
    this.email,
    this.profilepic,
    this.status,
    this.location,
    this.password,
  });
  //
  //
  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    profilepic = map["profilepic"];
    status = map["status"];
    location = map["location"];
    password = map["password"];
  }
  //
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profilepic,
      "status": status,
      "location": location,
      "password": password,
    };
  }
}

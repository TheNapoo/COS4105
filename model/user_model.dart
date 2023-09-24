// ignore_for_file: empty_constructor_bodies, prefer_single_quotes

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String pathImage =
      "https://firebasestorage.googleapis.com/v0/b/emailpassword-5e319.appspot.com/o/profile%2Fprofile%2Ftiger.jpg?alt=media&token=3bf23f56-5d82-4ec8-8062-5247094dae49";

  UserModel(
      this.uid, this.email, this.firstName, this.secondName, this.pathImage);

  //กำลังรับข้อมูล from server
  factory UserModel.fromMap(map) {
    return UserModel(map["uid"], map["email"], map["firstName"],
        map["secondName"], map["pathImage"]);
  }

  //กำลังส่งข้อมูลไปยัง Server
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "firstName": firstName,
      "secondName": secondName,
      "pathImage": pathImage
    };
  }
}

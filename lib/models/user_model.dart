import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id, username, email, phone, gender, imagePath;
  final Timestamp brithDate;
  final List chats, frands, casesSearch;

  UserModel({
    this.id,
    this.username,
    this.casesSearch,
    this.gender,
    this.brithDate,
    this.email,
    this.phone,
    this.chats,
    this.frands,
    this.imagePath,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        casesSearch: json["casesSearch"],
        gender: json["gender"],
        brithDate: json["brithDate"],
        email: json["email"],
        phone: json["phone"],
        chats: json["chats"],
        frands: json["frands"],
        imagePath: json["imagePath"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "casesSearch": casesSearch,
        "gender": gender,
        "brithDate": brithDate,
        "email": email,
        "phone": phone,
        "chats": chats,
        "frands": frands,
        "imagePath": imagePath,
      };
}

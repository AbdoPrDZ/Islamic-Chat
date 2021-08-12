import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id, userId, title, description, type;
  final Map data;
  final Timestamp dateTime;
  final bool seen, isDone;

  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.type,
    this.data,
    this.dateTime,
    this.seen,
    this.isDone,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        userId: json["userId"],
        title: json["title"],
        description: json["description"],
        type: json["type"],
        data: json["data"],
        dateTime: json["dateTime"],
        seen: json["seen"],
        isDone: json["isDone"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "type": type,
        "data": data,
        "dateTime": dateTime,
        "seen": seen,
        "isDone": isDone,
      };
}

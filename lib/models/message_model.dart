import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id, senderUserId, chatId, message;
  final List seenUsersId;
  final Timestamp dateTime;

  MessageModel({
    this.id,
    this.senderUserId,
    this.chatId,
    this.message,
    this.seenUsersId,
    this.dateTime,
  });

  factory MessageModel.fromMap(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        senderUserId: json["senderUserId"],
        chatId: json["chatId"],
        message: json["message"],
        seenUsersId: json["seenUsersId"],
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "senderUserId": senderUserId,
        "chatId": chatId,
        "message": message,
        "seenUsersId": seenUsersId,
        "dateTime": dateTime,
      };
}

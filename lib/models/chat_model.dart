class ChatModel {
  final String id, lastMessageId, chatTitle;
  final bool isOnline, isGroup;
  final List usersId;
  final Map groupData;

  ChatModel(
      {this.id,
      this.lastMessageId,
      this.chatTitle,
      this.isOnline,
      this.isGroup,
      this.groupData,
      this.usersId});

  factory ChatModel.fromMap(Map<String, dynamic> json) => ChatModel(
      id: json["id"],
      lastMessageId: json["lastMessageId"],
      chatTitle: json["chatTitle"],
      isOnline: json["isOnline"],
      isGroup: json["isGroup"],
      groupData: json["groupData"],
      usersId: json["usersId"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "lastMessageId": lastMessageId,
        "chatTitle": chatTitle,
        "isOnline": isOnline,
        "isGroup": isGroup,
        "groupData": groupData,
        "usersId": usersId
      };
}

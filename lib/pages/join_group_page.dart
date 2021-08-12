import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat/models/chat_model.dart';
import 'package:islamic_chat/models/notification_model.dart';
import 'package:islamic_chat/models/user_model.dart';
import 'package:islamic_chat/pkgs/users.dart';
import 'package:islamic_chat/views/raised_gradient_button.dart';

class JoinGroupPage extends StatefulWidget {
  final String userId;
  final UserModel userModel;
  final ChatModel chatModel;
  final FirebaseFirestore reference;

  JoinGroupPage(this.userId, this.userModel, this.chatModel, this.reference);

  @override
  _JoinGroupPageState createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  List<String> rules = [];

  @override
  void initState() {
    super.initState();
    if (widget.chatModel.groupData.containsKey("rules")) {
      List _rules = widget.chatModel.groupData["rules"];
      int i = 0;
      for (String item in _rules) {
        ++i;
        rules.add(i.toString() + "- " + item);
      }
    }
  }

  void joinGroup() {
    String id = widget.reference.collection("notifications").doc().id;
    NotificationModel notificationModel = NotificationModel(
      id: id,
      userId: widget.chatModel.groupData["adminUserId"],
      title: "Join group Request",
      description: widget.userModel.username +
          " request to join to your " +
          widget.chatModel.chatTitle +
          " group",
      type: "join-group-request",
      isDone: false,
      seen: false,
      data: {"chatId": widget.chatModel.id, "memberUserId": widget.userId},
      dateTime: Timestamp.fromDate(DateTime.now()),
    );
    widget.reference
        .collection("notifications")
        .doc(id)
        .set(notificationModel.toMap());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  children: [
                    BackButton(color: Colors.white),
                    Spacer(),
                    Text(
                      "Join To Group",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Spacer(),
                  ],
                )),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.blue, Colors.purple]),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[500], blurRadius: 1, spreadRadius: 1.0)
                ]),
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, 150.0)),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(widget.chatModel.chatTitle ?? "Group Name",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ),
                Padding(padding: EdgeInsets.only(bottom: 30)),
                Text("Group Description:", style: TextStyle(fontSize: 20)),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.98,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.black54,
                      )),
                  child: Text(widget.chatModel.groupData["description"]),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                if (rules.isNotEmpty)
                  Text("Group Rules:", style: TextStyle(fontSize: 20)),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Wrap(
                      direction: Axis.vertical,
                      spacing: 5,
                      children: List.generate(rules.length, (int index) {
                        return Text(rules[index],
                            style: TextStyle(fontSize: 16));
                      })),
                ),
                Padding(padding: EdgeInsets.only(bottom: 30)),
                Align(
                  alignment: Alignment.center,
                  child: RaisedGradientButton(
                    width: MediaQuery.of(context).size.width * 0.6,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Colors.purple,
                      ],
                    ),
                    onPressed: joinGroup,
                    child: Text(
                      "Accept for rules and join",
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

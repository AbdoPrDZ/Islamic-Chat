import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat/models/notification_model.dart';
import 'package:islamic_chat/models/user_model.dart';
import 'package:islamic_chat/views/notification_item_view.dart';

class NotificationsTab extends StatefulWidget {
  final String userId;
  final FirebaseFirestore refrence;
  final UserModel userModel;
  NotificationsTab(this.userId, this.refrence, this.userModel);

  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: widget.refrence
            .collection("notifications")
            .where("userId", isEqualTo: widget.userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot != null) {
            List items = snapshot.data.docs;
            items.sort((m1, m2) {
              return m1.data()["dateTime"].compareTo(m2.data()["dateTime"]);
            });
            if (items.length > 0) {
              return Container(
                child: Column(
                  children: List.generate(items.length, (int index) {
                    return NotificationItemView(
                        widget.userId,
                        widget.refrence,
                        widget.userModel,
                        NotificationModel.fromMap(items[index].data()));
                  }),
                ),
              );
            } else if (items.length == 0) {
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: Text("No notifications to see"));
            }
          } else if (snapshot.hasError) {
            return Text("notifications tab: " + snapshot.error.toString());
          }
          return Center(
              child: Container(
                  margin: EdgeInsets.all(20),
                  child: CircularProgressIndicator()));
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_chat/models/notification_model.dart';
import 'package:islamic_chat/models/user_model.dart';
import 'package:islamic_chat/views/profile_details_item_view.dart';
import 'package:islamic_chat/views/raised_gradient_button.dart';

class ProfileTab extends StatefulWidget {
  final String userId;
  final FirebaseFirestore refrence;
  final UserModel profileUserModel, userModel;
  ProfileTab(this.userId, this.refrence, this.profileUserModel, this.userModel);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool isFrand = false;

  @override
  void initState() {
    super.initState();
    isFrand = widget.userModel.frands.contains(widget.profileUserModel.id);
  }

  void addFrand() async {
    String id = widget.refrence.collection("notifications").doc().id;
    NotificationModel notificationModel = NotificationModel(
      id: id,
      userId: widget.profileUserModel.id,
      title: "New Frand",
      description: widget.userModel.username + " send you to be frands",
      type: "frand-request",
      data: {
        "senderUserId": widget.userId,
      },
      dateTime: Timestamp.fromDate(DateTime.now()),
      seen: false,
      isDone: false,
    );
    await widget.refrence
        .collection("notifications")
        .doc(id)
        .set(notificationModel.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 125,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                widget.profileUserModel.username ?? "Username",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ProfileDetailsItemView(
                  widget.profileUserModel.username, Icons.alternate_email),
              ProfileDetailsItemView(
                  DateFormat("dd-MM-yyyy")
                      .format(widget.profileUserModel.brithDate.toDate()),
                  Icons.calendar_today),
              ProfileDetailsItemView(
                  widget.profileUserModel.gender, Icons.person),
              ProfileDetailsItemView(
                  widget.profileUserModel.email, Icons.email_outlined),
              ProfileDetailsItemView(
                  widget.profileUserModel.phone, Icons.phone_outlined),
              widget.profileUserModel.id != widget.userId
                  ? RaisedGradientButton(
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.blue,
                          Colors.purple,
                        ],
                      ),
                      child: Text(isFrand ? "Unfrand" : "Add frand",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      onPressed: isFrand ? null : addFrand,
                    )
                  : Padding(padding: EdgeInsets.all(0))
            ],
          ),
        ),
      ),
    );
  }
}

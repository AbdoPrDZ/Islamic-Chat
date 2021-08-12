import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat/models/user_model.dart';
import 'package:islamic_chat/tabs/profile_tab.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  final FirebaseFirestore refrance;
  final UserModel profileUserModel, userModel;
  ProfilePage(
      this.userId, this.refrance, this.profileUserModel, this.userModel);

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
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/logo.png")),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Text(profileUserModel.username ?? "username",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
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
      body: ProfileTab(userId, refrance, profileUserModel, userModel),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat/models/user_model.dart';
import 'package:islamic_chat/pkgs/users.dart';
import 'package:islamic_chat/tabs/chats_tab.dart';
import 'package:islamic_chat/tabs/notifications_tab.dart';
import 'package:islamic_chat/tabs/profile_tab.dart';
import 'package:islamic_chat/tabs/settings_tab.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userId;
  UserModel userModel;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final DatabaseReference databaseeRfrence = FirebaseDatabase.instance.reference();
  final FirebaseFirestore reference = FirebaseFirestore.instance;
  Map<int, Widget> tabs;
  int tabIndex;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    userId = auth.currentUser.uid;
    Users(reference).getUser(userId, (muserModel) {
      setState(() {
        userModel = muserModel;
        tabIndex = 0;
        isLoading = false;
      });
    }, (error) {
      print("Error: " + error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: Container(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Text('Islamic Chat',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white))),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.purple]),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[500],
                          blurRadius: 1,
                          spreadRadius: 1.0)
                    ])),
            preferredSize: Size(MediaQuery.of(context).size.width, 150.0)),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : tabIndex == 1
                ? NotificationsTab(userId, reference, userModel)
                : tabIndex == 2
                    ? ProfileTab(userId, reference, userModel, userModel)
                    : tabIndex == 3
                        ? SettingsTab(auth, reference, userId, userModel)
                        : ChatsTab(userId, userModel, reference),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Color(0XFFFFD700),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue, Colors.purple]),
          curve: null,
          style: TabStyle.react,
          items: [
            TabItem(
                icon: Icon(Icons.message_outlined, color: Color(0XDDFFFFFF))),
            TabItem(
                icon: Icon(Icons.notifications_outlined,
                    color: Color(0XDDFFFFFF))),
            TabItem(icon: Icon(Icons.person_outline, color: Color(0XDDFFFFFF))),
            TabItem(
                icon: Icon(Icons.settings_outlined, color: Color(0XDDFFFFFF))),
          ],
          initialActiveIndex: 0,
          onTap: isLoading
              ? null
              : (int i) => setState(() {
                    tabIndex = i;
                  }),
        ));
  }
}

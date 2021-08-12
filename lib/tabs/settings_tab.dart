import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:islamic_chat/models/user_model.dart';
import 'package:islamic_chat/pages/create_group_page.dart';
import 'package:islamic_chat/pages/start_page.dart';
import 'package:islamic_chat/pkgs/show_dialog.dart';
import 'package:islamic_chat/views/setting_item_view.dart';

class SettingsTab extends StatelessWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore refrencae;
  final String userId;
  final UserModel userModel;

  SettingsTab(this.auth, this.refrencae, this.userId, this.userModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                userModel.imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.fitHeight,
              ),
            ),
            SettingItemView(
                Icons.group_add,
                "Create Group",
                () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateGroupPage(userId, refrencae)))),
            SettingItemView(Icons.image_outlined, "Change Photo", () {
              ShowMyDialog(
                  context: context,
                  title: "Chose profile image",
                  message: "How you want to chosse your image?",
                  actions: <String>["Camera", "From files", "Cancel"],
                  onPressed: (String value) async {
                    if (value == "Camera") {
                      File image = await ImagePicker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);
                    } else if (value == "From files") {
                      File image = await ImagePicker.pickImage(
                          source: ImageSource.gallery, imageQuality: 50);
                    }
                  });
            }),
            SettingItemView(
                Icons.logout,
                "Logout",
                () => ShowMyDialog(
                    context: context,
                    title: "Signout",
                    message: "Do you want signout?",
                    actions: ["Yes", "No"],
                    pop: false,
                    onPressed: (value) async {
                      if (value == "Yes") {
                        Navigator.pop(context);
                        ShowLoadingDialog(context);
                        await auth.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StartPage()),
                            (Route<dynamic> route) => false);
                      }
                    })),
          ],
        ),
      ),
    );
  }
}

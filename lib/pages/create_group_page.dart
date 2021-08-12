import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat/models/chat_model.dart';
import 'package:islamic_chat/models/user_model.dart';
import 'package:islamic_chat/pkgs/show_dialog.dart';
import 'package:islamic_chat/views/my_container.dart';
import 'package:islamic_chat/views/raised_gradient_button.dart';

class CreateGroupPage extends StatefulWidget {
  final String userId;
  final FirebaseFirestore referance;
  CreateGroupPage(this.userId, this.referance);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupDescriptionController =
      TextEditingController();
  final TextEditingController ruleController = TextEditingController();
  List<String> rules = [];
  List<String> members = [];
  bool isPrivate = false;

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
    groupDescriptionController.dispose();
    ruleController.dispose();
  }

  void addRule(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            insetPadding: EdgeInsets.all(10),
            contentPadding: EdgeInsets.all(25),
            title: Text("Add rule for your group"),
            children: <Widget>[
              MyContainer(
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextFormField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Rule message",
                    prefixIcon: Icon(Icons.rule),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.white)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  ),
                  controller: ruleController,
                ),
              ),
              RaisedGradientButton(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.purple,
                  ],
                ),
                onPressed: () {
                  String rule = ruleController.text;
                  if (rule.isNotEmpty && !rules.contains(rule)) {
                    setState(() {
                      rules.add(ruleController.text);
                      ruleController.text = "";
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Add",
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  void createGroup() {
    if (groupNameController.text.isNotEmpty ||
        groupDescriptionController.text.isNotEmpty) {
      String id = widget.referance.collection("chats").doc().id;
      members.add(widget.userId);
      ChatModel chatModel = ChatModel(
        id: id,
        chatTitle: groupNameController.text,
        lastMessageId: "",
        isGroup: true,
        isOnline: false,
        groupData: {
          "adminUserId": widget.userId,
          "rules": rules,
          "description": groupDescriptionController.text,
          "isPrivate": isPrivate,
        },
        usersId: members,
      );
      widget.referance.collection("chats").doc(id).set(chatModel.toMap());
      ShowMyDialog(
          context: context,
          title: "Create Group Seccess",
          message:
              "Awsem group create seccessfully you can now chat with your frands",
          onPressed: (value) => Navigator.pop(context));
    } else {
      ShowMyDialog(
          context: context,
          title: "Create Group Error",
          message: "Please fill data");
    }
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
                      "Create New Group",
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
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.group_add,
                size: 125,
              ),
              MyContainer(
                padding: EdgeInsets.all(0),
                child: TextFormField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Group name",
                    prefixIcon: Icon(Icons.group),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.white)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  ),
                  controller: groupNameController,
                ),
              ),
              MyContainer(
                padding: EdgeInsets.all(0),
                child: TextFormField(
                  style: TextStyle(fontSize: 18),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Description",
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.white)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  ),
                  controller: groupDescriptionController,
                ),
              ),
              MyContainer(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Rules:", style: TextStyle(fontSize: 24)),
                        Spacer(),
                        IconButton(
                            onPressed: () => addRule(context),
                            icon: Icon(Icons.add))
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: ListView(
                          children: List.generate(rules.length, (index) {
                        return Container(
                            decoration: BoxDecoration(
                                color: Colors.blue[200],
                                borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Text(
                                  rules[index],
                                  style: TextStyle(fontSize: 18),
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () => setState(() {
                                          rules.remove(rules[index]);
                                        }),
                                    icon:
                                        Icon(Icons.delete, color: Colors.blue))
                              ],
                            ));
                      })),
                    ),
                  ],
                ),
              ),
              MyContainer(
                child: Column(
                  children: [
                    Text("Members:", style: TextStyle(fontSize: 24)),
                    StreamBuilder(
                      stream: widget.referance
                          .collection("users")
                          .where("frands", arrayContains: widget.userId)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData && snapshot != null) {
                          if (snapshot.data.docs.length > 0) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: ListView(
                                  children: List.generate(
                                      snapshot.data.docs.length, (index) {
                                UserModel userModel = UserModel.fromMap(
                                    snapshot.data.docs[index].data());
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue[
                                          members.contains(userModel.id)
                                              ? 200
                                              : 50],
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Row(children: <Widget>[
                                    Text(userModel.username,
                                        style: TextStyle(fontSize: 20)),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () => setState(() {
                                              members.contains(userModel.id)
                                                  ? members.remove(userModel.id)
                                                  : members.add(userModel.id);
                                            }),
                                        icon: Icon(
                                            members.contains(userModel.id)
                                                ? Icons.delete
                                                : Icons.add),
                                        color: Colors.blue),
                                  ]),
                                );
                              })),
                            );
                          } else if (snapshot.data.docs.length == 0) {
                            return Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(20),
                                child: Text(
                                    "You dont have frends, you can search for new frends"));
                          }
                        } else if (snapshot.hasError) {
                          return Text("mambers: " + snapshot.error.toString());
                        }
                        return Center(
                            child: Container(
                                margin: EdgeInsets.all(20),
                                child: CircularProgressIndicator()));
                      },
                    ),
                  ],
                ),
              ),
              MyContainer(
                padding: EdgeInsets.all(0),
                child: ListTile(
                  title: Text("Private", style: TextStyle(fontSize: 24)),
                  leading: Checkbox(
                    value: isPrivate,
                    onChanged: (bool value) {
                      setState(() {
                        isPrivate = value;
                      });
                    },
                  ),
                ),
              ),
              RaisedGradientButton(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.purple,
                  ],
                ),
                onPressed: createGroup,
                child: Text(
                  "Create",
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat/models/chat_model.dart';
import 'package:islamic_chat/models/user_model.dart';
import 'package:islamic_chat/views/chat_item_view.dart';
import 'package:islamic_chat/views/user_item_view.dart';

class ChatsTab extends StatefulWidget {
  final String userId;
  final UserModel userModel;
  final FirebaseFirestore refrence;

  ChatsTab(this.userId, this.userModel, this.refrence);

  @override
  _ChatsTabState createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  bool isSearching = false;
  String searchText = "";
  List<QueryDocumentSnapshot> chats = <QueryDocumentSnapshot>[];

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() => setState(() {
          isSearching = searchFocusNode.hasFocus;
        }));
    initChats();
  }

  void initChats() {
    widget.refrence
        .collection("chats")
        .where("usersId", arrayContains: widget.userId)
        .get()
        .then((value) => setState(() {
              if (!isSearching) chats = value.docs;
            }))
        .asStream();
  }

  void search() {
    setState(() {
      chats.clear();
      if (searchController.text.isNotEmpty) {
        isSearching = false;
        widget.refrence
            .collection("users")
            .where("casesSearch",
                arrayContains: searchController.text.toLowerCase())
            .get()
            .then((QuerySnapshot value) => setState(() {
                  chats.addAll(value.docs);
                }));

        widget.refrence
            .collection("chats")
            .where("chatTitle", isEqualTo: searchController.text)
            .get()
            .then((QuerySnapshot value) => setState(() {
                  for (QueryDocumentSnapshot doc in value.docs) {
                    ChatModel chatModel = ChatModel.fromMap(doc.data());
                    if (chatModel.isGroup) {
                      if (!chatModel.groupData["isPrivate"]) {
                        chats.add(doc);
                      }
                    } else {
                      chats.add(doc);
                    }
                  }
                }));
      } else {
        isSearching = false;
        initChats();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            // onChanged: (value) => setState(() {
            //   searchText = searchController.text;
            // }),
            onChanged: (v) => search(),
            controller: searchController,
            focusNode: searchFocusNode,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              hintText: "Search for people or groups",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              hoverColor: Colors.grey.shade200,
            ),
          ),
          Column(
            children: List.generate(chats.length, (index) {
              Map item = chats[index].data();
              ChatModel chatModel = ChatModel.fromMap(item);
              if (chatModel.isGroup != null) {
                return ChatItemView(widget.userId, widget.userModel, chatModel,
                    widget.refrence);
                ;
              } else {
                UserModel userItemUserModel = UserModel.fromMap(item);
                if (userItemUserModel.id != widget.userId) {
                  return UserItemView(widget.userId, widget.refrence,
                      userItemUserModel, widget.userModel);
                } else {
                  return Padding(padding: EdgeInsets.all(0));
                }
              }
            }),
          ),

          // StreamBuilder(
          //   stream: isSearching
          //       ? widget.refrence
          //           .collection("users")
          //           .where("casesSearch",
          //               arrayContains: searchText.toLowerCase())
          //           .snapshots()
          //       : widget.refrence
          //           .collection("chats")
          //           .where("usersId", arrayContains: widget.userId)
          //           .snapshots(),
          //   builder:
          //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     if (snapshot.hasData && snapshot != null) {
          //       if (snapshot.data.docs.length > 0) {
          //         return SingleChildScrollView(
          //           scrollDirection: Axis.vertical,
          //           child: Container(
          //             padding: EdgeInsets.all(5),
          //             child: Column(
          //               children:
          //                   List.generate(snapshot.data.docs.length, (index) {
          //                 Map<String, dynamic> item =
          //                     snapshot.data.docs[index].data();
          //                 if (!isSearching) {
          //                   ChatModel chatModel = ChatModel.fromMap(item);
          //                   return ChatItemView(
          //                       widget.userId, chatModel, widget.refrence);
          //                 } else {
          //                   UserModel userItemUserModel =
          //                       UserModel.fromMap(item);
          //                   if (userItemUserModel.id != widget.userId) {
          //                     return UserItemView(
          //                         widget.userId,
          //                         widget.refrence,
          //                         userItemUserModel,
          //                         widget.userModel);
          //                   } else {
          //                     return Padding(padding: EdgeInsets.all(0));
          //                   }
          //                 }
          //               }),
          //             ),
          //           ),
          //         );
          //       } else if (snapshot.data.docs.length == 0) {
          //         return Container(
          //             alignment: Alignment.center,
          //             padding: EdgeInsets.all(20),
          //             child: Text(isSearching
          //                 ? "No results"
          //                 : "You dont have frends, you can search for new frends"));
          //       }
          //     } else if (snapshot.hasError) {
          //       return Text("chat tab: " + snapshot.error.toString());
          //     }
          //     return Center(
          //         child: Container(
          //             margin: EdgeInsets.all(20),
          //             child: CircularProgressIndicator()));
          //   },
          // ),
        ],
      ),
    );
  }
}

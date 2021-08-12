import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamic_chat/models/chat_model.dart';
import 'package:islamic_chat/models/message_model.dart';
import 'package:islamic_chat/pkgs/show_dialog.dart';
import 'package:islamic_chat/pkgs/users.dart';
import 'package:islamic_chat/views/message_item_view.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final ChatModel chatModel;
  final FirebaseFirestore reference;
  ChatPage(this.userId, this.chatModel, this.reference);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  String chatTitle = "";

  @override
  void initState() {
    super.initState();

    if (widget.chatModel.isGroup) {
      chatTitle = widget.chatModel.chatTitle;
    } else {
      for (String id in widget.chatModel.usersId) {
        Users(widget.reference).getUser(id, (userModel) {
          if (userModel.id != widget.userId) {
            setState(() {
              chatTitle = userModel.username;
            });
          }
        }, (error) => print(error));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      String id = widget.reference.collection("messages").doc().id;
      MessageModel messageModel = MessageModel(
        id: id,
        senderUserId: widget.userId,
        chatId: widget.chatModel.id,
        message: messageController.text,
        seenUsersId: [widget.userId],
        dateTime: Timestamp.fromDate(DateTime.now()),
      );
      await widget.reference
          .collection("messages")
          .doc(id)
          .set(messageModel.toMap());

      await widget.reference
          .collection("chats")
          .doc(widget.chatModel.id)
          .update({
        "lastMessageId": messageModel.id,
      });

      setState(() {
        messageController.text = "";
      });
    } else {
      ShowMyDialog(
          context: context,
          title: "Message send error",
          message: "Please enter the message");
    }
  }

  void setMessageAsSee(MessageModel messageModel) async {
    List seenUsersId = messageModel.seenUsersId;
    if (!seenUsersId.contains(widget.userId)) {
      seenUsersId.add(widget.userId);
      await widget.reference
          .collection("messages")
          .doc(messageModel.id)
          .update({"seenUsersId": seenUsersId});
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
                      child: CustomPaint(
                        painter: widget.chatModel.isOnline
                            ? ChatImagePainter()
                            : null,
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Text(chatTitle ?? "chat Title",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    Spacer(),
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      tooltip: "Menu",
                      itemBuilder: (context) => [
                        PopupMenuItem(child: Text("Add to favorit")),
                        PopupMenuItem(child: Text("Bloc Notifications")),
                        PopupMenuItem(child: Text("Remove")),
                        PopupMenuItem(
                            child: Text(widget.chatModel.isGroup
                                ? "Leave group"
                                : "Unfreand")),
                      ],
                    )
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
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: widget.reference
                .collection("messages")
                .where("chatId", isEqualTo: widget.chatModel.id)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData && snapshot != null) {
                List items = snapshot.data.docs;
                items.sort((m1, m2) {
                  return m1.data()["dateTime"].compareTo(m2.data()["dateTime"]);
                });
                if (items.length > 0) {
                  return Column(
                    children: List.generate(items.length, (index) {
                      MessageModel messageModel =
                          MessageModel.fromMap(items[index].data());
                      setMessageAsSee(messageModel);
                      return MessageItemView(widget.userId, messageModel);
                    }),
                  );
                } else if (snapshot.data.docs.length == 0) {
                  return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      child: Text("Now you are frand with " +
                          chatTitle +
                          " you can send messages"));
                }
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("chat page: " + snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.12,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.purple]),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[500], blurRadius: 1, spreadRadius: 1.0)
            ]),
        child: Container(
          child: Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.image_outlined, color: Colors.white)),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  controller: messageController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Type your message here...",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Color(0X77EEEEEE),
                    // hoverColor: Color(0X44EEEEEE),
                  ),
                ),
              ),
              IconButton(
                  onPressed: sendMessage,
                  icon: Icon(Icons.send, color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}

class ChatImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width;
    Paint fillBrush = Paint()..color = Color(0xBBCCCCCC);
    canvas.drawCircle(
        Offset(radius * 0.938, radius * 0.9), radius * 0.12, fillBrush);

    fillBrush = Paint()..color = Color(0xFF28B463);
    canvas.drawCircle(
        Offset(radius * 0.938, radius * 0.9), radius * 0.1, fillBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

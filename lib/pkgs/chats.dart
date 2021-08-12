import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:islamic_chat/models/chat_model.dart';

class Chats {
  CollectionReference collection;
  Chats(FirebaseFirestore reference) {
    collection = reference.collection("chats");
  }

  Future<void> getChat(String chatId, Function(ChatModel chatModel) onSeccess,
      Function(String error) onError) async {
    try {
      await collection.doc(chatId).get().then((value) {
        onSeccess(ChatModel.fromMap(value.data()));
      }).onError((error, stackTrace) {
        onError(error.toString());
      });
    } on FirebaseException catch (error) {
      onError(error.message);
    } catch (error) {
      onError(error.toString());
    }
  }
}

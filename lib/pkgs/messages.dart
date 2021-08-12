import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:islamic_chat/models/message_model.dart';

class Messages {
  CollectionReference collection;
  Messages(FirebaseFirestore reference) {
    collection = reference.collection("messages");
  }

  Future<void> getMessage(
      String messageId,
      Function(MessageModel messageModel) onSeccess,
      Function(String error) onError) async {
    try {
      await collection.doc(messageId).get().then((value) {
        onSeccess(MessageModel.fromMap(value.data()));
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

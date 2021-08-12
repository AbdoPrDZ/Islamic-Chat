import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:islamic_chat/models/user_model.dart';

class Users {
  CollectionReference collection;
  Users(FirebaseFirestore reference) {
    collection = reference.collection("users");
  }

  Future<void> getUser(String userId, Function(UserModel userModel) onSeccess,
      Function(String error) onError) async {
    try {
      await collection.doc(userId).get().then((value) {
        onSeccess(UserModel.fromMap(value.data()));
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

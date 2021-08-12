import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:islamic_chat/models/notification_model.dart';

class Notifications {
  CollectionReference collection;
  Notifications(FirebaseFirestore reference) {
    collection = reference.collection("notificationss");
  }

  Future<void> getNotification(
      String notificationId,
      Function(NotificationModel notificationModel) onSeccess,
      Function(String error) onError) async {
    try {
      await collection.doc(notificationId).get().then((value) {
        onSeccess(NotificationModel.fromMap(value.data()));
      }).onError((error, stackTrace) {
        onError(error.toString());
      });
    } on FirebaseException catch (error) {
      onError(error.message);
    } catch (error) {
      onError(error.toString());
    }
  }

  Future<void> addNotification(Map<String, dynamic> notificationMap,
      Function onSeccess, Function(String error) onError) async {
    try {
      String id = collection.doc().id;
      notificationMap["id"] = id;
      collection
          .doc(id)
          .set(notificationMap)
          .whenComplete(onSeccess)
          .onError((error, stackTrace) => onError(error.toString()));
    } on FirebaseException catch (error) {
      onError(error.message);
    } catch (error) {
      onError(error.toString());
    }
  }
}

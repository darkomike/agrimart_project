// ignore_for_file: avoid_print

import 'package:block_agri_mart/domain/notifications/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationFirebaseApi {
  static  addNotification(
      {required String notificationID,
        required Map<String, dynamic> data}) async {
    final docProduct =
    FirebaseFirestore.instance.collection('notifications').doc(notificationID);

    await docProduct.set(data).then((value) {
      print("product is added to firebase cloud store");
      return "done";
    }).catchError((onError) {
      print("Adding product error: $onError");

      return "error";
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      print('Product could not be added. Please try again');
      return "timeout";

    });
  }

  static Stream<List<NotificationModel>> getAllNotifications() => FirebaseFirestore.instance
      .collection('notifications')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => NotificationModel.fromJson(doc.data())).toList());



  static Stream<int> getAllNotificationsLength() => FirebaseFirestore.instance
      .collection('notifications')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => NotificationModel.fromJson(doc.data())).toList().length);




}

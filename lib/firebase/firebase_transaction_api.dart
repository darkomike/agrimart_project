// ignore_for_file: avoid_print

import 'package:block_agri_mart/domain/transactions/model/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionFirebaseApi {
  static addTransaction(
      {required String transactionID,
      required Map<String, dynamic> data}) async {
    final docProduct = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionID);

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

  static Stream<List<TransactionModel>> getAllTransactions() =>
      FirebaseFirestore.instance.collection('transactions').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromJson(doc.data()))
              .toList());

  static Stream<List<TransactionModel>> getPersonalTransactions(
          {required String minerID}) =>
      FirebaseFirestore.instance
          .collection('transactions')
          .where(
            'transactionFrom', 
            isEqualTo: minerID,
          )
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromJson(doc.data()))
              .toList());
}

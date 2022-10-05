import 'dart:developer';
import 'package:block_agri_mart/domain/home/model/catalog_model.dart';
import 'package:block_agri_mart/domain/profile/model/miner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MinerFirebaseApi {
  static Future<Map<String, String>> addMiner(
      {required String minerID, required Map<String, dynamic> data}) async {
    Map<String, String> status = {};
    final docMiner =
        FirebaseFirestore.instance.collection('miners').doc(minerID);

    await docMiner
        .set(data)
        .then((value) {
          status = {
            "message": "Miner is added to firebase cloud store.",
            "status": "success",
          };
        })
        .catchError((onError) {
          status = {
            "message":
                "Error adding miner to firebase cloud store, Error: $onError",
            "status": "error",
          };
        })
        .then((value) {})
        .timeout(const Duration(seconds: 20), onTimeout: () {
          status = {
            "message": "Timeout adding product to firebase cloud store",
            "status": "timeout"
          };
        });

    return status;
  }

  static Future<Map<String, String>> updateMinerFields(
      {required String minerID, required Map<String, dynamic> data}) async {
    Map<String, String> status = {};
    final docMiner =
        FirebaseFirestore.instance.collection('miners').doc(minerID);

    await docMiner
        .update(data)
        .then((value) {
          status = {
            "message": "Miner field is updated",
            "status": "success",
          };
        })
        .catchError((onError) {
          status = {
            "message":
                "Error updating miner field in firebase cloud store, Error: $onError",
            "status": "error",
          };
        })
        .then((value) {})
        .timeout(const Duration(seconds: 20), onTimeout: () {
          status = {
            "message": "Timeout updating miner field to firebase cloud store",
            "status": "timeout"
          };
        });

    return status;
  }

  static getMinerData({required String minerID}) async {
    final data = <String, dynamic>{};

    await FirebaseFirestore.instance
        .collection('miners')
        .doc(minerID)
        .get()
        .then((value) {
      log("Miner Data: ${value.data()!}");
      data["data"] = Miner.fromJson(value.data()!);
      data["status"] = 'success';
    }).catchError((onError) {
      data["data"] = onError.toString();
      data["status"] = 'error';
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      data["data"] = 'Time out';
      data["status"] = 'timeout';
    });

    log("Get Miner Data in Logs $data");
    return data;
  }

  static Stream<List<Miner>> getTopSellers() => FirebaseFirestore.instance
      .collection('miners')
      .orderBy('numberOfProducts', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Miner.fromJson(doc.data())).toList());

  static Stream<List<CatalogModel>> getMinerCatalogs() => FirebaseFirestore
      .instance
      .collection('miners')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CatalogModel(
              catalogID: doc.id, userAvatar: doc.data()["minerAvatar"]))
          .toList());

  // static String getDateJoined({required String userID}) {
  //   String? timeJoined;
  //   FirebaseFirestore.instance
  //       .collection('miners')
  //       .doc(prefs.getString('userMetaMuskAddress'))
  //       .get()
  //       .then((snapshot) {
  //     timeJoined = snapshot.data()!["timeJoined"];
  //   }).catchError((err) {
  //     log("Error fetching data  ${err.toString()}");
  //   });

  //   return timeJoined == null ? "2022" : timeJoined!;
  // }
}

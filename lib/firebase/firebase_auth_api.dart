// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:block_agri_mart/domain/profile/model/miner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseApi {
  static Future<Miner?> getMiner({required String metamuskAddress}) async {
    try {
      final docMiner = await FirebaseFirestore.instance
          .collection('miners')
          .doc(metamuskAddress)
          .get();

      return Miner.fromJson(docMiner.data()!);
    } catch (e) {
      print("Error in miner:$e");
      return null;
    }
  }

  static signinAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
      log(userCredential.toString());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "Authentication was not successful.":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.Please check your internet and try again");
      }
    }
  }

  static Future<String> addMiner(
      {required String minerID, required Map<String, dynamic> data}) async {
    final docMiner =
        FirebaseFirestore.instance.collection('miners').doc(minerID);

    await docMiner.set(data).then((value) {
      print("miner is added to firebase cloud store");
      return "done";
    }).catchError((onError) {
      print("Adding miner error: $onError");

      return "error";
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      print('Miner could not be added. Please try again');
      return "timeout";
    });
    return '';
  }
}

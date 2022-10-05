

import 'package:block_agri_mart/domain/requests/model/request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRequestApi {
   static Stream<List<RequestModel>> getOthersRequests() => FirebaseFirestore.instance 
      .collection('requests') 
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => RequestModel.fromJson(doc.data())).toList());


       static Stream<List<RequestModel>> getPersonalRequests(
          {required String userID}) =>
      FirebaseFirestore.instance
          .collection('requests')        
          .where('requestedBy',
              isEqualTo: userID )
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => RequestModel.fromJson(doc.data()))
              .toList());    
  
}
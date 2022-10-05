import 'dart:developer';

import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/domain/products/model/product.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFirebaseApi {
  static Future<String> updateProductToCloudDatabase(
      {required String ownerAddress,
      required Map<String, dynamic> data}) async {
    String status = '';
    final docProduct =
        FirebaseFirestore.instance.collection('products').doc(ownerAddress);

    await docProduct.set(data).then((value) {
      log("product is added to firebase cloud store");
    }).catchError((onError) {
      log("Adding product error: $onError");
      status = "error";
    }).whenComplete(() {
      status = "success";
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      log('Product could not be added. Please try again');
      status = "timeout";
    });

    return status;
  }

  static Stream<List<Product>> getAllProducts() => FirebaseFirestore.instance
      .collection('products')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  static Stream<List<Product>> getVegetablesProducts() => FirebaseFirestore
      .instance
      .collection('products')
      .where('productCategory',
          isEqualTo: AppUtils.capitalize(value: 'vegetable'))
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  static Stream<List<Product>> getCerealsProducts() => FirebaseFirestore
      .instance
      .collection('products')
      .where('productCategory', isEqualTo: AppUtils.capitalize(value: 'cereal'))
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  static Stream<List<Product>> getFruitsProducts() => FirebaseFirestore.instance
      .collection('products')
      .where('productCategory', isEqualTo: AppUtils.capitalize(value: 'fruit'))
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  static Stream<List<Product>> getAllProductsFromUser(
          {required String userID}) =>
      FirebaseFirestore.instance
          .collection('products')
          .where(ProductField.productOwnerID, isEqualTo: userID)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Product.fromJson(doc.data()))
              .toList());

  static Stream<List<Product>> getVegetablesProductsUser(
          {required String userID}) =>
      FirebaseFirestore.instance
          .collection('products')
          .where(ProductField.productOwnerID, isEqualTo: userID)
          .where('productCategory',
              isEqualTo: AppUtils.capitalize(value: 'vegetable'))
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Product.fromJson(doc.data()))
              .toList());

  static Stream<List<Product>> getCerealsProductsUser(
          {required String userID}) =>
      FirebaseFirestore.instance
          .collection('products')
          .where(ProductField.productOwnerID, isEqualTo: userID)
          .where('productCategory',
              isEqualTo: AppUtils.capitalize(value: 'cereal'))
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Product.fromJson(doc.data()))
              .toList());

  static Stream<List<Product>> searchProduct({required String productName}) =>
      FirebaseFirestore.instance
          .collection('products')
          .where('productName',
              isGreaterThanOrEqualTo: AppUtils.capitalize(value: productName))
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Product.fromJson(doc.data()))
              .toList());

  static Stream<List<Product>> searchProductFromUser(
          {required String productName, required String userID}) =>
      FirebaseFirestore.instance
          .collection('products')
          .where(ProductField.productOwnerID, isEqualTo: userID)
          .where('productName',
              isGreaterThanOrEqualTo: AppUtils.capitalize(value: productName))
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Product.fromJson(doc.data()))
              .toList());

  static Stream<List<Product>> getFruitsProductsUser(
          {required String userID}) =>
      FirebaseFirestore.instance
          .collection('products')
          .where(ProductField.productOwnerID,
              isEqualTo: AppUtils.capitalize(value: userID))
          .where('productCategory',
              isEqualTo: AppUtils.capitalize(value: 'fruit'))
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Product.fromJson(doc.data()))
              .toList());

  static Future<Product?> getProductFromASeller(
      {required String sellerID}) async {
    final docProduct =
        FirebaseFirestore.instance.collection('products').doc('id');

    final snapshot = await docProduct.get();

    if (snapshot.exists) {
      return Product.fromJson(snapshot.data()!);
    }
    return null;
  }

  static updateProduct(
      {required String productID, required Map<String, dynamic> data}) async {
    final docProduct =
        FirebaseFirestore.instance.collection('products').doc(productID);
  }

  static deleteProduct({required String productID}) async {
    final docProduct =
        FirebaseFirestore.instance.collection('products').doc(productID);

    await docProduct.delete();
  }
}

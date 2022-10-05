import 'dart:developer';

import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/domain/cart/model/cart_model.dart';
import 'package:block_agri_mart/domain/products/model/product.dart';
import 'package:block_agri_mart/domain/profile/model/miner.dart';
import 'package:block_agri_mart/main.dart';
import 'package:flutter/widgets.dart';

class CartStateManager extends ChangeNotifier {
  // ignore: prefer_final_fields
  int _itemsInCart = 0;
  double _totalCost = 0.0;
  double _agrolink = 0.0;
  double _agrolinktotal = 0.0;
  List<Cart> _productsInCart = [];
  List<String> _sellersID = [];
  List<String> _productsID = [];
  String _sellerID = '';
  String _sellerNumber = '';
  bool numberAdded = false;

  int get itemsInCart => _itemsInCart;
  double get totalCost => _totalCost;
  double get agrolink => _agrolink;
  double get agrolinktotal => _agrolinktotal;
  bool get isNumberAdded => numberAdded;
  String get sellerID => _sellerID;
  String get sellerNumber => _sellerNumber;
  List<Cart> get productsInCart => _productsInCart;

  List<String> get sellersID => _sellersID;
  List<String> get productsID => _productsID;

  void addItemToCart(Cart productCart, BuildContext context) {
    if (_productsInCart.isEmpty) {
      _sellerID = productCart.productOwnerID;
      _sellerNumber = productCart.productOwnerNumber;

      _productsInCart.add(productCart);
      _productsID.add(productCart.productID);
      AppUtils.showCustomSnackBarWithoutAction(
        duration: 1500,
        context: context,
        label: "${productCart.productName} is added to cart.",
      );
    } else {
      if (_sellerID == productCart.productOwnerID) {
        _productsID = _productsID.toSet().toList();
        bool dup = _productsID.contains(productCart.productID);
        log("Dup: $dup");
        if (dup == false) {
          _productsInCart.add(productCart);
          _productsID.add(productCart.productID);
          AppUtils.showCustomSnackBarWithoutAction(
            duration: 1,
            context: context,
            label: "${productCart.productName} is added to cart.",
          );
        }
      } else {
        AppUtils.showCustomSnackBarWithoutAction(
          duration: 1500,
          context: context,
          label:
              "You cannot add a product from a different seller or market to cart.",
        );
      }
    }
    calculateTotalCost();
    notifyListeners();
  }

  setSellerID({required String sellerID, required String phoneNumber}) {
    _sellerID = sellerID;
    _sellerNumber = sellerNumber;
    notifyListeners();
  }

  void removeProductFormCartAt({required String productID}) {
    _productsInCart.removeWhere((product) => product.productID == productID);
    calculateTotalCost();
    notifyListeners();
  }

  void changeQuantityAtIndexInCart(
      {required int newQuantity, required int index}) {
    if (newQuantity >= 1) {
      _productsInCart.elementAt(index).productQuantity = newQuantity.toString();
    } else {
      _productsInCart.elementAt(index).productQuantity = "1";
    }
    notifyListeners();
  }

  calculateTotalCost() {
    double total = 0.0;
    double agrolink = 0.0;
    for (Cart element in _productsInCart) {
      total += element.productPrice * double.parse(element.productQuantity);
      agrolink += 0.02 * total;
    }
    _totalCost = total;
    _agrolink = agrolink;
    prefs.setString('agrolink', _agrolink.toString());

    notifyListeners();
  }

  calculateagrotokens() {
    double totalagrotokens = 0.0;
    totalagrotokens = _agrolink;
    _agrolinktotal += totalagrotokens;
    notifyListeners();
  }

  void emptyCart() {
    _productsInCart.clear();
    _sellersID.clear();
    _sellerID = '';
    _productsID.clear();
    _totalCost = 0.0;
    _agrolink = 0.0;
    notifyListeners();
  }
}

// A global variable managing the whole cart state
final cartStateManager = CartStateManager();

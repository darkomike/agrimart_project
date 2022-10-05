import 'package:flutter/widgets.dart';

class ProductStateManager extends ChangeNotifier {
  double _totalProductPrice = 0.0;
  String _productUnit = 'grams';
  String _selectedProductImage = 'pineapple';

  get totalProductPrice => _totalProductPrice;
  get productUnit => _productUnit;
  get selectedProductImage => _selectedProductImage;

  calculateTotalProductPrice(double price) {
    _totalProductPrice = price;
    notifyListeners();
  }

  setProductUnit(String value) {
    _productUnit = value.toLowerCase();
    notifyListeners();
  }

  setProductTotalPrice(double value) {
    _totalProductPrice = value;
    notifyListeners();
  }

  setProductImage(String? value) {
    _selectedProductImage = value!.toLowerCase();
    notifyListeners();
  }
}

// A global variable managing the whole product state
final productStateManager = ProductStateManager();

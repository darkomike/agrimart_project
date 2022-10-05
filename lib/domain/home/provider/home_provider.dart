import 'dart:async';
import 'package:block_agri_mart/firebase/firebase_product_api.dart';
import 'package:flutter/widgets.dart';
import '../../products/model/product.dart';


class HomeStateManager with ChangeNotifier {
  int _categorySelectedCard = 0;
  bool _showScrollToTopFAB = false;
  double _mainScrollPositionPixel = 0.0;

  Stream<List<Product>>? _allStream;
  Stream<List<Product>>? _vegetableStream;
  Stream<List<Product>>? _fruitStream;
  Stream<List<Product>>? _cerealStream;
  Stream<List<Product>>? _trendingProductsStream;
  Stream<List<Product>>? _topSellersStream;
  Stream<List<Product>>? _poultryStream;

  Stream<List<Product>>? get poultryStream => _poultryStream;
  Stream<List<Product>>? get vegetableStream => _vegetableStream;
  Stream<List<Product>>? get fruitStream => _fruitStream;
  Stream<List<Product>>? get allStream {
    refreshStreams();
    return _allStream;
  }

  Stream<List<Product>>? get cerealStream => _cerealStream;
  Stream<List<Product>>? get trendingProductsStream => _trendingProductsStream;
  Stream<List<Product>>? get topSellersStream => _topSellersStream;

  get categorySelectedCard => _categorySelectedCard;
  get showScrollToTopFAB => _showScrollToTopFAB;
  get mainScrollPositionPixel => _mainScrollPositionPixel;

  void updateCategoryCard(int category) {
    _categorySelectedCard = category;
    notifyListeners();
  }

  void updateShowScrollToTopFAB(bool showScrollToTopFAB) {
    _showScrollToTopFAB = showScrollToTopFAB;
    notifyListeners();
  }

  void updateMainScrollPositionPixel(double mainScrollPositionPixel) {
    _mainScrollPositionPixel = mainScrollPositionPixel;
    notifyListeners();
  }

  refreshStreams() {
    _allStream = ProductFirebaseApi.getAllProducts();
    _vegetableStream = ProductFirebaseApi.getAllProducts();
    _fruitStream = ProductFirebaseApi.getAllProducts();
    _cerealStream = ProductFirebaseApi.getAllProducts();
    _poultryStream = ProductFirebaseApi.getAllProducts();
    notifyListeners();
  }
}

// A global variable managing the whole app state
final homeStateManager = HomeStateManager();

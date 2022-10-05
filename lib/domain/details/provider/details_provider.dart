import 'package:block_agri_mart/domain/products/model/product.dart';
import 'package:flutter/widgets.dart';

class DetailStateManager extends ChangeNotifier {
  Product _productModel = Product(
    productOwnerNumber: '',
    productTimestamp: '',
    productCategory: '',
    productID: '',
    productUnitWeight: '',
    productDescription: '',
    productOwnerAvatar: 0,
    productDiscount: 0.0,
    productThumbnail: 'pineapple',
    productQuantity: 0,
    productOwnerID: '',
    productName: 'pineapple',
    productPrice: 0.0,
    // productWeight: ''
  );

  Product get productModel => _productModel;

  setProductDetail(Product productModel) {
    _productModel = productModel;
    notifyListeners();
  }
}

// A global variable managing the whole product state
final detailStateManager = DetailStateManager();

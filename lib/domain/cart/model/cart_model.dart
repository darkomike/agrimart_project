import '../../products/model/product.dart';

class Cart {
  String productName = '';
  String productID = '';
  double productPrice = 0.0;
  String productThumbnail = '';
  String productQuantity = '';
  String productOwnerID = '';
  String productOwnerAvatar = '';
  String productOwnerNumber = '';

  Cart({
    required this.productID,
    required this.productThumbnail,
    required this.productQuantity,
    required this.productOwnerID,
    required this.productOwnerAvatar,
    required this.productName,
    required this.productPrice,
    required this.productOwnerNumber,
  });

  Cart.fromJson(Map<String, dynamic> map) {
    productID = map[ProductField.productID];
    productName = map[ProductField.productName];
    productThumbnail = map[ProductField.productThumbnail];
    productQuantity = map[ProductField.productQuantity];
    productOwnerAvatar = map[ProductField.productOwnerAvatar];
    productOwnerID = map[ProductField.productOwnerID];
    productPrice = map[ProductField.productPrice];
    productOwnerNumber = map[ProductField.productOwnerNumber];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data[ProductField.productOwnerNumber];
    data[ProductField.productID] = productID;
    data[ProductField.productName] = productName;
    data[ProductField.productThumbnail] = productThumbnail;
    data[ProductField.productQuantity] = productQuantity;
    data[ProductField.productOwnerAvatar] = productOwnerAvatar;
    data[ProductField.productOwnerID] = productOwnerID;
    data[ProductField.productPrice] = productPrice;
    return data;
  }
}

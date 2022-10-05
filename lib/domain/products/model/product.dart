class ProductField {
  static String productID = "productID";
  static String productName = "productName";
  static String productPrice = "productPrice";
  // static String productWeight = "productWeight";
  static String productUnitWeight = "productUnitWeight";
  static String productThumbnail = "productThumbnail";
  static String productCategory = "productCategory";
  static String productQuantity = "productQuantity";
  static String productDiscount = "productDiscount";
  static String productTimestamp = "productTimestamp";
  static String productDescription = "productDescription";
  static String productOwnerID = "productOwnerID";
  static String productOwnerNumber = 'productOwnerNumber';
  static String productOwnerAvatar = "productOwnerAvatar";
}

class Product {
  String productName = '';
  String productID = '';
  String productUnitWeight = '';
  String productOwnerNumber = '';
  double productPrice = 0.0;
  String productThumbnail = '';
  String productCategory = '';
  int productQuantity = 0;
  double productDiscount = 0.0;
  String productTimestamp = '';
  String productDescription = '';
  String productOwnerID = '';
  int productOwnerAvatar = 0;

  Product({
    required this.productTimestamp,
    required this.productCategory,
    required this.productUnitWeight,
    required this.productID,
    required this.productThumbnail,
    required this.productQuantity,
    required this.productDiscount,
    required this.productOwnerID,
    required this.productOwnerAvatar,
    required this.productDescription,
    required this.productName,
    required this.productPrice,
    required this.productOwnerNumber,
    // required this.productWeight,
  });

  Product.fromJson(Map<String, dynamic> map) {
    productID = map[ProductField.productID];
    productUnitWeight = map[ProductField.productUnitWeight];
    productName = map[ProductField.productName];
    productTimestamp = map[ProductField.productTimestamp];
    productCategory = map[ProductField.productCategory];
    productThumbnail = map[ProductField.productThumbnail];
    productQuantity = map[ProductField.productQuantity];
    productDiscount = map[ProductField.productDiscount];
    productOwnerAvatar = map[ProductField.productOwnerAvatar];
    productDescription = map[ProductField.productDescription];
    productOwnerID = map[ProductField.productOwnerID];
    productPrice = map[ProductField.productPrice];
    productOwnerNumber = map[ProductField.productOwnerNumber];
    // productWeight = map[ProductField.productWeight];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[ProductField.productID] = productID;
    data[ProductField.productName] = productName;
    data[ProductField.productUnitWeight] = productUnitWeight;
    data[ProductField.productTimestamp] = productTimestamp;
    data[ProductField.productCategory] = productCategory;
    data[ProductField.productThumbnail] = productThumbnail;
    data[ProductField.productQuantity] = productQuantity;
    data[ProductField.productDiscount] = productDiscount;
    data[ProductField.productOwnerAvatar] = productOwnerAvatar;
    data[ProductField.productDescription] = productDescription;
    data[ProductField.productOwnerID] = productOwnerID;
    data[ProductField.productOwnerNumber] = productOwnerNumber;
    // data[ProductField.productWeight] = productWeight;
    data[ProductField.productPrice] = productPrice;
    return data;
  }
}

class ProductImagesModel {
  String? productID;

  ProductImagesModel({
    this.productID,
  });

  ProductImagesModel.fromMap(Map<String, dynamic> map) {
    productID = map['productID'];
  }
}

final List<ProductImagesModel> productImages = [
  ProductImagesModel(productID: 'oranges'),
  ProductImagesModel(productID: 'avocado'),
  ProductImagesModel(productID: 'banana'),
  ProductImagesModel(productID: 'grapefruit'),
  ProductImagesModel(productID: 'pepper'),
  ProductImagesModel(productID: 'pineapple'),
  ProductImagesModel(productID: 'cucumber'),
];

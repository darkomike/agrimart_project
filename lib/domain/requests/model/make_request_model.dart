class MakeRequestModel {
  String? productName;
  int? productQuantity;
  double? productMinPrice;
  double? productMaxPrice;

  MakeRequestModel(
      {
      required this.productName,
      required this.productQuantity,
      required this.productMaxPrice,
      required this.productMinPrice
      });

  MakeRequestModel.fromJson(Map<String, dynamic> data) {
    productName = data["productName"];
    productQuantity = data["productQuantity"];
    productMaxPrice = data["productMaxPrice"];
    productMinPrice = data["productMinPrice"];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['productName'] = productName;
    data['productMaxPrice'] = productMaxPrice;
    data['productMinPrice'] = productMinPrice;
    data['productQuantity'] = productQuantity;
    return data;
  }
}

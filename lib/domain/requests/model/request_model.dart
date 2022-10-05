class RequestFields {
  static String requestedProducts = 'requestedProducts';
  static String requestID = 'requestID';
  static String requestedAt = 'requestedAt';
  static String requestedBy = 'requestedBy';
  static String requestedAcceptedBy = 'requestedAcceptedBy';
  static String requestedProductTotalPrice = 'requestedProductsMinTotalPrice';
  static String requestedProductsTotalPriceToPay = 'requestedProductsTotalPriceToPay';
  static String requestedProductsMinTotalPrice =
      'requestedProductsMinTotalPrice';
  static String requestedProductsMaxTotalPrice =
      'requestedProductsMaxTotalPrice';
  static String requestedStatus = 'requestedStatus';
}

class RequestModel {
  String? requestedAt;
  int? requestedStatus;
  String? requestedBy;
  String? requestedAcceptedBy;
  double? requestedProductsMaxTotalPrice;
  double? requestedProductsMinTotalPrice;
  double? requestedProductsTotalPriceToPay;
  String? requestID;
  List<dynamic>? requestedProducts;

  RequestModel(
      {required this.requestedStatus,
      required this.requestedBy,
      required this.requestedAt, required this.requestedProductsTotalPriceToPay,
      required this.requestedAcceptedBy,
      required this.requestedProducts,
      required this.requestID,
      required this.requestedProductsMinTotalPrice,
      required this.requestedProductsMaxTotalPrice});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data[RequestFields.requestedStatus] = requestedStatus;
    data[RequestFields.requestedAt] = requestedAt;
    data[RequestFields.requestedProducts] = requestedProducts;
    data[RequestFields.requestedBy] = requestedBy;
    data[RequestFields.requestedAcceptedBy] = requestedAcceptedBy;
    data[RequestFields.requestedProductsTotalPriceToPay] = requestedProductsTotalPriceToPay;
    data[RequestFields.requestID] = requestID;
    data[RequestFields.requestedProductsMaxTotalPrice] =
        requestedProductsMaxTotalPrice;
    data[RequestFields.requestedProductsMinTotalPrice] =
        requestedProductsMinTotalPrice;
    return data;
  }

  RequestModel.fromJson(Map<String, dynamic> map) {
    requestedStatus = map[RequestFields.requestedStatus];
    requestedProducts = map[RequestFields.requestedProducts];
    requestedAt = map[RequestFields.requestedAt];
    requestedBy = map[RequestFields.requestedBy];
    requestedAcceptedBy = map[RequestFields.requestedAcceptedBy];
    requestedProductsTotalPriceToPay = map[RequestFields.requestedProductsTotalPriceToPay];
    requestedProductsMaxTotalPrice =
        map[RequestFields.requestedProductsMaxTotalPrice];
    requestedProductsMinTotalPrice =
        map[RequestFields.requestedProductsMinTotalPrice];
    requestID = map[RequestFields.requestID];
  }
}

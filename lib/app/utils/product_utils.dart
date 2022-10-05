import 'dart:math';

import 'package:block_agri_mart/app/utils/utils.dart';

class ProductUtils {
  static Map<String, List<double>> productNames = {
    "pineapple": [0.7, 1.0, 500],
    'grapefruit': [0.7, 2.0, 300],
    "avocado": [0.7, 3.0, 500],
    "pepper": [0.7, 4.0, 100],
    "cucumber": [0.7, 4.0, 400],
    'strawberry': [0.7, 4.0, 500],
    'onion': [0.7, 4.0, 700],
    'spring onion': [0.7, 4.0, 600],
    'watermelon': [0.7, 4.0, 450],
    'tomatoes': [0.7, 4.0, 600],
    'okro': [0.7, 4.0, 450],
    'maize': [0.7, 4.0, 450],
    'garlic': [0.7, 4.0, 200],
    'egg plant': [0.7, 4.0, 150],
    'cabbage': [0.7, 4.0, 340],
    'carrot': [0.7, 4.0, 450],
    'banana': [0.7, 4.0, 300]
  };

  static Map<String, dynamic> generatePriceAndQuantity(
      {required double weight, required String unit, required String product}) {
    final Map<String, dynamic> priceAndQuantity = {};
    switch (unit) {
      case 'grams':
        priceAndQuantity['price_min'] = productNames[product]![0];
        priceAndQuantity['price_max'] = productNames[product]![1];
        priceAndQuantity['quantity'] =
            ((weight) / productNames[product]![2]).floorToDouble().toInt();

        return priceAndQuantity;
      case 'kilograms':
        priceAndQuantity['price_min'] = productNames[product]![0];
        priceAndQuantity['price_max'] = productNames[product]![1];
        priceAndQuantity['quantity'] =
            ((weight * 1000) / productNames[product]![2])
                .floorToDouble()
                .toInt();

        return priceAndQuantity;
      case 'tonnes':
        priceAndQuantity['price_min'] = productNames[product]![0];
        priceAndQuantity['price_max'] = productNames[product]![1];
        priceAndQuantity['quantity'] =
            ((weight * 1000000) / productNames[product]![2])
                .floorToDouble()
                .toInt();
        return priceAndQuantity;

      default:
        return {'price_min': 0.7, 'price_max': 1.0, 'quantity': 0};
    }
  }

  static double getProductDiscount({required double discount}) {
    if (discount < 0) {
      return 0.0;
    } else {
      return discount / 100;
    } 
  }

  static double changeWeightToGrams(
      {required double weight, required String unit}) {
    switch (unit) {
      case 'grams':
        return weight;
      case 'kilograms':
        return weight / 1000;
      case 'tonnes':
        return weight / 1000000;

      default:
        return 0.0;
    }
  }
}

class RequestUtils {
  // ignore: prefer_final_fields
  

  static String generateRequestID({required String minerID}) {
    return minerID.substring(0, (minerID.length ~/ 2)) +
        " ${AppUtils.getRandomString(8)}";
  }

  static bool compareRequestIDs(
      {required String minerID, required String requestID}) {
    final first = requestID.split(" ");
    bool compare =
        minerID.substring(0, minerID.length ~/ 2) == first[0].toString();
    return compare;
  }

  static setSearchParam(String caseNumber) {
  List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < caseNumber.length; i++) {
    temp = temp + caseNumber[i];
    caseSearchList.add(temp);
  }
  return caseSearchList;
}
}

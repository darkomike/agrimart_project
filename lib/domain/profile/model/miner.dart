class Miner {
  String minerID = '';
  int productSold = 0;

  int minerAvatar = 0;
  String phoneNumber = '';
  String timeJoined = '';
  int numberOfProducts = 0;
  int productPurchased = 0;
  double totalRevenue = 0.0;
  List<dynamic> accounts = [];

  Miner(
      {required this.minerID,
      required this.accounts,
      required this.timeJoined,
      required this.phoneNumber,
      required this.minerAvatar,
      required this.productPurchased,
      required this.numberOfProducts,
      required this.productSold,
      required this.totalRevenue});

  Miner.fromJson(Map<String, dynamic> map) {
    minerID = map["minerID"];
    minerAvatar = map["minerAvatar"];
    phoneNumber = map["phoneNumber"];
    timeJoined = map["timeJoined"];
    productSold = map["productSold"];
    productPurchased = map["productPurchased"];
    numberOfProducts = map["numberOfProducts"];
    accounts = map["accounts"];
    totalRevenue = map["totalRevenue"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data["minerID"] = minerID;
    data["phoneNumber"] = phoneNumber;
    data["minerAvatar"] = minerAvatar;
    data["timeJoined"] = timeJoined;
    data["productSold"] = productSold;
    data["productPurchased"] = productPurchased;
    data["numberOfProducts"] = numberOfProducts;
    data["accounts"] = accounts;
    data["totalRevenue"] = totalRevenue;
    return data;
  }
}

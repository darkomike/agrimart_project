import 'package:hive/hive.dart';
part 'miner_model.g.dart';

@HiveType(typeId: 1)
class MinerModel extends HiveObject {
  @HiveField(0)
  String minerID;
  @HiveField(1)
  int productSold;
  @HiveField(2)
  int minerAvatar;
  @HiveField(3)
  int numberOfProducts;
  @HiveField(4)
  int productPurchased;
  @HiveField(5)
  double totalRevenue;
  @HiveField(6)
  List<dynamic> accounts;
  @HiveField(7)
  String phoneNumber;

  MinerModel(
      {required this.minerID,
      required this.phoneNumber,
      required this.minerAvatar,
      required this.accounts,
      required this.productPurchased,
      required this.numberOfProducts,
      required this.productSold,
      required this.totalRevenue});
}

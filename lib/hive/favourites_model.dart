import 'package:hive/hive.dart';
part 'favourites_model.g.dart';

@HiveType(typeId: 0)
class FavoriteModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String productName;

  FavoriteModel({required this.id, required this.productName});
}



import 'package:hive/hive.dart';
part 'chat_model.g.dart';


@HiveType(typeId: 2)
class ChatModel extends HiveObject {
  @HiveField(0)
  String text;
   @HiveField(1)
  String time;
   @HiveField(2)
  bool type;

  ChatModel({required this.text, required this.time, required this.type});
}

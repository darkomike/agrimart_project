import 'package:block_agri_mart/hive/chat_model.dart';
import 'package:block_agri_mart/hive/favourites_model.dart';
import 'package:block_agri_mart/hive/miner_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<FavoriteModel> getFavorites() =>
      Hive.box<FavoriteModel>('favorites');

  static deleteAllFavourites() {
    Hive.box<FavoriteModel>('favorites').clear();
  }

  static deleteFavouritesAt({required int key}) {
    Hive.box('favorites').deleteAt(key);
  }

//Current Miner
  static Box<MinerModel> getMiners() => Hive.box<MinerModel>('miners');

  static deleteMiner() {
    Hive.box<MinerModel>('miners').clear(); 
  } 

  // Chats
  static Box<ChatModel> getChats() => Hive.box<ChatModel>('chats');

  static deleteAllChats() {
    Hive.box<ChatModel>('chats').clear();
  }
   static deleteChatAt({required int key}) {
    Hive.box('chats').deleteAt(key);
  }
}

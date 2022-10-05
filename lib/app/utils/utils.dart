import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:block_agri_mart/app/constants/text.dart';
import 'package:block_agri_mart/hive/boxes.dart';
import 'package:block_agri_mart/hive/chat_model.dart';
import 'package:block_agri_mart/hive/favourites_model.dart';
import 'package:block_agri_mart/hive/miner_model.dart';
import 'package:encrypt/encrypt.dart' as key;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static key.Encrypted encodeText({required String plainText}) {
    key.Encrypted encryptedText = key.Encrypted.fromBase64('0000');
    try {
      final generatedKey = key.Key.fromLength(32);
      final iv = key.IV.fromLength(8);
      final encrypter = key.Encrypter(key.Salsa20(generatedKey));

      encryptedText = encrypter.encrypt(plainText, iv: iv);
    } catch (e) {
      print('Error in encrypt func: $e');
    }

    return encryptedText;
  }

  static decodeText({required String cipherText}) {
    String decryptedText = '';
    try {
      final generatedKey = key.Key.fromLength(32);
      final iv = key.IV.fromLength(8);
      final encrypter = key.Encrypter(key.Salsa20(generatedKey));

      decryptedText =
          encrypter.decrypt(key.Encrypted.fromBase64(cipherText), iv: iv);
    } catch (e) {
      print('Error in encrypt func: $e');
    }

    return decryptedText;
  }

  final s = DateFormat('yyyy-MM-dd KK:mm:ss a').format(DateTime.now());

  static String appKey = "BbCcwDdEeeFfGgwHhIiJjKkL3lMmNnOo";

  static String chars =
      'A1aBbCcwDdEeeFfGgwHhIiJjKkL3lMmNnOoPpQqRerSsTtUuVvWwXxYyZz123g45g6789wq0';

  // ignore: prefer_final_fields
  static Random _rnd = Random();

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))));

  static int defaultAvatar = 0;
  static String capitalize({required String value}) {
    return value[0].toUpperCase() + value.substring(1);
  }

  static roundToDecimalPlace(
      {required double decimal, required int decimalPlace}) {
    return double.parse(decimal.toStringAsFixed(decimalPlace));
  }

  static showCustomSnackBarWithoutAction({
    required BuildContext context,
    required String label,
    Color? color,
    int? duration,
    void Function()? onVisible,
    Animation<double>? animation,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: duration ?? 2000),
      onVisible: onVisible,
      animation: animation,
      content: Container(
          alignment: Alignment.centerLeft, height: 40, child: Text(label)),
      backgroundColor: color ?? Colors.black.withOpacity(0.9),
    ));
  }

  static showCustomSnackBarWithAction1({
    required BuildContext context,
    required String label,
    required String actionLabel,
    Color? color,
    int? duration,
    void Function()? onVisible,
    required void Function() onPressedAction,
    Animation<double>? animation,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: duration ?? 5),
      onVisible: onVisible,
      animation: animation,
      content: Container(
          alignment: Alignment.centerLeft, height: 40, child: Text(label)),
      backgroundColor: color ?? Colors.black.withOpacity(0.9),
      action: SnackBarAction(
        label: actionLabel,
        onPressed: onPressedAction,
      ),
    ));
  }

  static double appMQ({required BuildContext context, required String flag}) {
    double defaultPadding = MediaQuery.of(context).size.width / 20;
    double defaultMargin = MediaQuery.of(context).size.width / 20;

    switch (flag) {
      case 'pad':
        return defaultPadding;
      case 'mar':
        return defaultMargin;
      case 'h':
        return MediaQuery.of(context).size.height;
      case 'w':
        return MediaQuery.of(context).size.width;
      default:
        return MediaQuery.of(context).size.width;
    }
  }

  static delayFunction({required int duration, required Function()? action}) {
    Future.delayed(Duration(milliseconds: duration), action);
  }

  static getRandomNumber() {
    Random random = Random();
    return random.nextInt(18) + 1;
  }

  static List<String> sortString(List<String> list) {
    list.sort((a, b) => a.compareTo(b));
    return list;
  }

  static getCategory({required String value}) {
    if (productAndCategory['vegetable'].contains(value.toLowerCase())) {
      return "Vegetable";
    } else if (productAndCategory['fruit'].contains(value.toLowerCase())) {
      return "Fruit";
    } else {
      return "Cereal";
    }
  }

  static Map<String, dynamic> productAndCategory = {
    'vegetable': [
      "pepper",
      'cabbage',
      'cucumber',
      'carrot',
      'egg plant',
      'garlic',
      'okro',
      'onion',
      'spring onion',
      'tomatoes'
    ],
    'cereal': ['maize'],
    'fruit': [
      "banana",
      "grapefruit",
      'strawberry',
      'watermelon'
          "avocado",
      "orange",
      "pineapple"
    ],
  };

  static navigatePush(
      {required BuildContext context, required Widget destination}) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }

  static navigatePushReplace(
      {required BuildContext context, required Widget destination}) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => destination));
  }

  static String getAvatarImage({required int key}) =>
      "assets/images/avatars/Blerg-$key.png";

  static String getProductImage({required String name}) =>
      "assets/images/products/$name.png";
  static String getImage({required String name}) => "assets/images/$name.png";

  static String getLottie({required String name}) => "assets/lottie/$name.json";

  static String getIcon({required String name}) => "assets/icons/$name.svg";

  static showCustomDialog(
          {required BuildContext context,
          required Widget content,
          List<Widget>? actions}) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                contentPadding: const EdgeInsets.all(5),
                content: content,
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 4,
                actions: actions,
              ));

  static String generateProductID(
          {required String userAddress, required String productName}) =>
      userAddress.substring(0, (userAddress.length ~/ 2)) +
      " " +
      productName +
      " ${AppUtils.getRandomString(5)}";

  static int generateRandomNumberExcerpt({required int excerpt}) {
    Random random = Random();
    int generatedNumber;
    do {
      generatedNumber = random.nextInt(61);
    } while (generatedNumber == excerpt);

    return generatedNumber;
  }

  static String shortenAddress1({
    required String userAddress,
  }) =>
      userAddress.substring(0, (userAddress.length ~/ 2)) + "...";

  static String shortenAddress2({
    required String userAddress,
  }) =>
      userAddress.substring(0, (userAddress.length ~/ 3)) + "...";

  static String getTimeFromDateTime({required String datetime}) {
    return DateFormat("KK:mm a").format(DateTime.parse(datetime));
  }

  static String getAddress() {
    Random random = Random();
    int len = TextConstant.fakeAddress.length;
    return "${TextConstant.fakeAddress[random.nextInt(len - 1)]}";
  }

  static addFavorite(
      {required String id,
      required String productName,
      required BuildContext context}) {
    final favorite = FavoriteModel(id: id, productName: productName);
    final box = Boxes.getFavorites();
    box.add(favorite);
  }

  static addMinerToLocal(
      {required String minerID,
      required String phoneNumber,
      required int minerAvatar,
      required List<dynamic> accounts,
      required int productPurchased,
      required int numberOfProducts,
      required productSold,
      required double totalRevenue}) {
    final miner = MinerModel(
        minerID: minerID,
        phoneNumber: phoneNumber,
        minerAvatar: minerAvatar,
        accounts: accounts,
        productPurchased: productPurchased,
        numberOfProducts: numberOfProducts,
        productSold: productSold,
        totalRevenue: totalRevenue);
    final box = Boxes.getMiners();
    box.add(miner);
  }

  // static MinerModel getMiner() {
  //   return Boxes.getMiners().values.toList().cast<MinerModel>()[0];
  // }

  static deleteMiner() {
    Boxes.deleteMiner();
  }

  static deleteAllFavorite() {
    Boxes.deleteAllFavourites();
  }

  static deleteFavoriteAt({required FavoriteModel favoriteModel}) {
    // final box = Boxes.getFavorites();
    favoriteModel.delete();
  }

  static appLog(String message) {
    developer.log(message);
  }
}

const spaceW1 = SizedBox(
  width: 10,
);

const spaceW2 = SizedBox(
  width: 5,
);

const spaceH1 = SizedBox(
  height: 10,
);

const spaceH2 = SizedBox(
  height: 5,
);

const bold = FontWeight.bold;

final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));

class ChatsUtils {
  static addChat(
      {required String text, required String time, required bool type}) {
    final chat = ChatModel(text: text, time: time, type: type);
    final box = Boxes.getChats();
    box.add(chat);
  }

  static deleteAllChats() {
    Boxes.deleteAllChats();
  }

  static deleteChatAt({required ChatModel chatModel}) {
    // Boxes.deleteChatAt(key: index);
    chatModel.delete();
  }

  static getChatDate() {
    return (DateTime.now()).toString();
  }
}


//
// Future uploadFileToFireStorage() async {
//   var _productImageSelected;
//   if (_productImageSelected == null) return;
//
//   final destination = "uploads/$_productImageName";
//   task =
//       ProductFirebaseApi.uploadProduct(destination, _productImageSelected!);
//
//   if (task == null) return null;
//
//   final snapshot = await task!.whenComplete(() {
//     print("File added");
//   });
//
//   final urlDownload = await snapshot.ref.getDownloadURL();
//
//   setState(() {
//     _productThumbnail = urlDownload;
//     print("Product URL: $_productThumbnail");
//   });
//
//   return task;
// }

//
// pickProductImageFromLocal() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['jpg', 'png', 'jpeg'],
//   );
//
//   if (result != null) {
//     setState(() {
//       _productImageSelected = File(result.files.first.path!);
//       _productImageName = result.files.first.name;
//     });
//     debugPrint("$_productImageName");
//   } else {
//     // User canceled the picker
//
//   }
// }

// child: Center(
//   child: MaterialButton(
//       height: 50,
//       onPressed: () {
//         // pickProductImageFromLocal();
//       },
//       color: ColorConstants.primaryColor.withOpacity(0.1),
//       child: const Text(
//         "Select Product Avatar",
//         style: TextStyle(color: Colors.white),
//       ),
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//           side: BorderSide(
//               width: 1,
//               color: ColorConstants.primaryColor))),
// )
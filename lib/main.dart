import 'dart:async';
import 'dart:developer';
import 'package:block_agri_mart/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'domain/auth/components/passcodes.dart';
import 'domain/domain.dart';
import 'domain/home/home.dart';
import 'domain/products/provider/product_provider.dart';
import 'hive/chat_model.dart';
import 'hive/favourites_model.dart';
import 'hive/miner_model.dart';

late SharedPreferences prefs;

localPersistence() {
  prefs.setBool("loggedIn", prefs.getBool('loggedIn') ?? false);
  prefs.setString("passcode", prefs.getString('passcode') ?? '0000');
  prefs.setBool("isDarkModeOn", prefs.getBool('isDarkModeOn') ?? false);
  prefs.setInt("profileImage",
      prefs.getInt('profileImage') ?? AppUtils.getRandomNumber());
  prefs.setString("userType", prefs.getString('userType') ?? "buyer");
  prefs.setString(
      "userMetaMuskAddress", prefs.getString('userMetaMuskAddress') ?? '');
  prefs.setInt(
      "userAvatar", prefs.getInt('userAvatar') ?? AppUtils.defaultAvatar);
  prefs.setInt("favCount", prefs.getInt('favCount') ?? 0);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    //Local Persistence
    prefs = await SharedPreferences.getInstance();
    localPersistence();
    await Hive.initFlutter();
    Hive.registerAdapter(FavoriteModelAdapter());
    Hive.registerAdapter(MinerModelAdapter());
    Hive.registerAdapter(ChatModelAdapter());
    await Hive.openBox<FavoriteModel>('favorites');
    await Hive.openBox<MinerModel>('miners');
    await Hive.openBox<ChatModel>('chats');

    await Firebase.initializeApp();
    InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            // ignore: avoid_print
            prefs.setBool("isOnline", true);

            log('Data connection is available.');
            break;
          case InternetConnectionStatus.disconnected:
            // ignore: avoid_print
            prefs.setBool("isOnline", false);

            log('You are disconnected from the internet.');
            break;
        }
      },
    );
    runApp(const MyApp());
  } catch (e) {
    print("main.dart: Error in void func: $e ");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => appStateManager),
        ChangeNotifierProvider(create: (context) => homeStateManager),
        ChangeNotifierProvider(create: (context) => detailStateManager),
        ChangeNotifierProvider(create: (context) => productStateManager),
        ChangeNotifierProvider(create: (context) => cartStateManager),
      ],
      child: Consumer<AppStateManager>(builder: ((context, appState, child) {
        ThemeData theme;
        if (appState.darkModeOn) {
          theme = DarkTheme.dark();
        } else {
          theme = LightTheme.light();
        }

        return MaterialApp(
          title: 'AgriMart',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: theme,
          color: ColorConstants.primaryColor,
          home: prefs.getBool('loggedIn')!
              ? const PassCodeScreen(
                  fromAuth: true,
                )
              : const AuthScreen(),
        );
      })),
    );
  }
}

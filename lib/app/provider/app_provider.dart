import 'dart:developer';

import 'package:block_agri_mart/app/constants/web3terminal.dart';
import 'package:block_agri_mart/domain/profile/model/miner.dart';
import 'package:flutter/widgets.dart';
import '../../main.dart';

class AppStateManager with ChangeNotifier {
  bool _loggedIn = prefs.getBool('loggedIn')!;
  bool _darkModeOn = prefs.getBool('isDarkModeOn')!;
  int _navigationBottomSelected = 0;
  String _userType = prefs.getString('userType')!;
  String _userMetaMuskAddress = prefs.getString('userMetaMuskAddress')!;
  int _userAvatar = prefs.getInt('userAvatar')!;
  int _favCount = prefs.getInt('favCount')!;

  Miner _loggedInMiner = Miner(
      minerID: 'minerID',
      timeJoined: DateTime.now().toIso8601String(),
      accounts: [],
      minerAvatar: 0,
      phoneNumber: '',
      productPurchased: 0,
      numberOfProducts: 0,
      productSold: 0,
      totalRevenue: 0.0);

  bool _showDashboardFAB = true;

  int _authPageIndex = 0;

  //getters
  bool get loggedIn => _loggedIn;
  bool get darkModeOn => _darkModeOn;
  Miner get loggedInMiner => _loggedInMiner;
  String get userType => _userType;
  String get userMetaMuskAddress => _userMetaMuskAddress;
  int get userAvatar => _userAvatar;
  int get favCount => _favCount;
  int get navigationBottomSelected => _navigationBottomSelected;
  int get authPageIndex => _authPageIndex;
  bool get showDashboardFAB => _showDashboardFAB;

  //setters
  setIsLoggedIn(bool isLoggedIn) {
    prefs.setBool('loggedIn', isLoggedIn);
    _loggedIn = isLoggedIn;
    notifyListeners();
  }

  setIsDarkModeOn(bool isDarkModeOn) {
    _darkModeOn = isDarkModeOn;
    prefs.setBool('isDarkModeOn', isDarkModeOn);

    notifyListeners();
  }

  showFAB(bool value) {
    _showDashboardFAB = value;
    notifyListeners();
  }

  changeAuthPageIndex(int value) {
    _authPageIndex = value;
    notifyListeners();
  }

  changeNavigationBottomSelected(int value) {
    _navigationBottomSelected = value;
    notifyListeners();
  }

  setUserType(String userType) {
    _userType = userType;
    prefs.setString('userType', userType);
    notifyListeners();
  }

  setLoggedInMiner(Miner miner) {
    _loggedInMiner = miner;
    notifyListeners();
  }

  setUserMetaMuskAddress(String userMetaMuskAddress) {
    _userMetaMuskAddress = userMetaMuskAddress;
    prefs.setString('userMetaMuskAddress', userMetaMuskAddress);
    notifyListeners();
  }

  setUserAvatar(int userType) {
    _userAvatar = userType;
    prefs.setInt('userAvatar', userAvatar);
    notifyListeners();
  }

  setFavCount() {
    int count = prefs.getInt('favCount')! + 1;
    _favCount = count;
    prefs.setInt('favCount', count);
    notifyListeners();
  }

  logout() {
    prefs.setBool('loggedIn', false);
    prefs.setString('userType', 'buyer');
    prefs.setString('userMetaMuskAddress', '');
    prefs.setString('passcode', '0000');
    // prefs.setInt('userAvatar', 0);
    _loggedIn = false;
    _authPageIndex = 0;
    _navigationBottomSelected = 0;
    _userType = 'buyer';
    _userMetaMuskAddress = userMetaMuskAddress;
    // _userAvatar = 0;
    _loggedInMiner = Miner(
        minerID: 'minerID',
        accounts: [],
        timeJoined: DateTime.now().toIso8601String(),
        productPurchased: 0,
        phoneNumber: '',
        minerAvatar: 0,
        numberOfProducts: 0,
        productSold: 0,
        totalRevenue: 0.0);
    notifyListeners();
  }

  switchMode({required String userType}) {
    _userType = userType.toLowerCase();
    prefs.setString('userType', userType.toLowerCase());
    notifyListeners();
  }
}

// A global variable managing the whole app state
final appStateManager = AppStateManager();

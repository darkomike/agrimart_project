import 'dart:developer';

import 'package:block_agri_mart/app/constants/constant.dart';
import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/app/widgets/widgets.dart';
import 'package:block_agri_mart/domain/auth/components/passcodes.dart';
import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/firebase/firebase_auth_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../app/provider/app_provider.dart';
import '../../../main.dart';
import '../../profile/model/miner.dart';

class NewLogin extends StatefulWidget {
  const NewLogin({Key? key}) : super(key: key);

  @override
  State<NewLogin> createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {
  bool _enablePartOne = true;
  bool _enablePartTwo = false;
  bool _enablePartThree = false;
  bool _isAuthenticating = false;
  bool numberadded = false;

  int? _currentImageAvatar;
  String initialDialCode = '+233';

  bool disabledth = false;

  var address;
  var ethbal;

  final TextEditingController _metaMuskController = TextEditingController();

  final TextEditingController _phoneNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  selectAnAvatar() {
    AppUtils.showCustomDialog(
        context: context,
        actions: [
          CommonButton(
            bgColor: ColorConstants.secondaryColor,
            label: "Back",
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
        content: SizedBox(
          height: AppUtils.appMQ(context: context, flag: 'h') * (2 / 3),
          width: AppUtils.appMQ(context: context, flag: 'w') - 20,
          child: Flexible(
            child: GridView.builder(
              itemCount: 60,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5, mainAxisSpacing: 5, crossAxisCount: 3),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    _currentImageAvatar = index + 1;
                    _enablePartTwo = true;
                  });
                  context.read<AppStateManager>().setUserAvatar(index + 1);

                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              AppUtils.getAvatarImage(key: index + 1)))),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    _currentImageAvatar = prefs.getInt('userAvatar');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        isDashboard: false,
        showCart: false,
        showAddProduct: false,
        showNotification: false,
        title: "Connect Wallet",
        showProfilePic: false,
        onTransparentBackground: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: AppUtils.appMQ(context: context, flag: 'h'),
        color: Theme.of(context).backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgress(context),
                _connectWalletFormPage(context),
              ]),
        ),
      ),
    );
  }

  Expanded _connectWalletFormPage(BuildContext context) {
    return Expanded(
      flex: 10,
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        color: Theme.of(context).backgroundColor,
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildPartOne(context),
                SizedBox(
                  height:
                      AppUtils.appMQ(context: context, flag: 'h') * (1 / 26),
                ),
                _buildPartTwo(context),
                SizedBox(
                  height:
                      AppUtils.appMQ(context: context, flag: 'h') * (1 / 11),
                ),
                _buildPartThree(context)
              ]),
        ),
      ),
    );
  }

  Container _buildPartThree(BuildContext context) {
    return Container(
      width: AppUtils.appMQ(context: context, flag: 'w') - 40,
      color: Theme.of(context).backgroundColor,
      child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 80,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  IntlPhoneField(
                    controller: _phoneNumber,
                    onCountryChanged: (country) {
                      setState(() {
                        initialDialCode = "+" + country.dialCode;
                      });
                    },
                    validator: (value) {
                      return value == null ? " Fill in the fields " : null;
                    },
                    readOnly: numberadded == true ? true : false,
                    decoration: InputDecoration(
                      hintText: "Phone number",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorConstants.primaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorConstants.primaryColor)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorConstants.primaryColor)),
                    ),
                    initialCountryCode: 'GH',
                    onChanged: (phone) {},
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CommonButton(
                        bgColor: ColorConstants.errorColor,
                        label: 'save',
                        height: 30,
                        onTap: () {
                          setState(() {
                            numberadded = true;
                          });
                        }),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          disabledColor: Colors.grey.shade500,
                          height: 50,
                          color: _enablePartOne &&
                                  _enablePartTwo &&
                                  _enablePartThree &&
                                  numberadded
                              ? ColorConstants.primaryColor
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: _enablePartOne &&
                                  _enablePartTwo &&
                                  _enablePartThree &&
                                  numberadded
                              ? connect
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                  label: _isAuthenticating
                                      ? 'Authenticating...'
                                      : 'Authenticate',
                                  fontSize: 15,
                                  color: Colors.white),
                              const SizedBox(
                                width: 10,
                              ),
                              _isAuthenticating
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ))
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const CustomText(
            //   label: 'Authenticate anonymously',
            //   fontSize: 18,
            //   fontWeight: bold,
            // ),
          ]),
    );
  }

  connect() {
    try {
      setState(() {
        _isAuthenticating = true;
      });
      final minerID = _metaMuskController.text.trim();
      final phoneNumber = _phoneNumber.text.trim();

      prefs.setString("userMetaMuskAddress", _metaMuskController.text.trim());
      prefs.setString("userPhonenumber", _phoneNumber.text.trim());

      final miner = Miner(
          accounts: [minerID],
          minerAvatar: prefs.getInt('userAvatar')!,
          minerID: minerID,
          timeJoined: DateTime.now().toIso8601String(), 
          phoneNumber: phoneNumber,
          numberOfProducts: 0,
          productPurchased: 0,
          productSold: 0,
          totalRevenue: 0.0);

      FirebaseFirestore.instance
          .collection('miners')
          .doc(minerID)
          .get()
          .then((value) {
        if (value.data() == null) {
          FirebaseFirestore.instance
              .collection('miners')
              .doc(minerID)
              .set(miner.toJson())
              .then((value) async {
            await AuthFirebaseApi.signinAnonymously();
            AppUtils.navigatePush(
                context: context,
                destination: const PassCodeScreen(
                  fromAuth: true,
                ));

            AppUtils.addMinerToLocal(
                minerID: minerID,
                phoneNumber: phoneNumber,
                minerAvatar: miner.minerAvatar,
                accounts: miner.accounts,
                productPurchased: miner.productPurchased,
                numberOfProducts: miner.numberOfProducts,
                productSold: miner.productSold,
                totalRevenue: miner.totalRevenue);

            AppUtils.showCustomSnackBarWithoutAction(
              context: context,
              color: ColorConstants.primaryColor,
              label: 'Authentication successful',
            );
          });
        } else {
          Provider.of<AppStateManager>(context, listen: false)
              .setLoggedInMiner(Miner.fromJson(value.data()!));
          AuthFirebaseApi.signinAnonymously();
          AppUtils.navigatePush(
              context: context,
              destination: const PassCodeScreen(
                fromAuth: true,
              ));
          AppUtils.showCustomSnackBarWithoutAction(
            context: context,
            color: ColorConstants.primaryColor,
            label: 'Authentication successful',
          );
        }
      }).catchError((onError) {
        setState(() {
          _isAuthenticating = false;
        });
        AppUtils.showCustomSnackBarWithoutAction(
          context: context,
          label:
              'Something went wrong. Please check your internet connection and try again. $onError',
        );
      });
    } catch (e) {
      log("login.dart: Error in connect func: $e");
    }
  }

  addEthWallet(var privateKey) async {
    String rpcUrl = "http://192.168.43.20:7545";
    String wsUrl = "ws://192.168.43.20:7545/";
    Web3Client client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
    try {
      Credentials credentials = EthPrivateKey.fromHex(privateKey);
      var addy = await credentials.extractAddress();
      EtherAmount ethbalance = await client.getBalance(addy);
      setState(() {
        ethbal = ethbalance.getValueInUnit(EtherUnit.ether);
        address = addy;
        _metaMuskController.text = address.toString();
      });
    } on WebSocketChannelException catch (e) {
      AppUtils.showCustomSnackBarWithoutAction(
          context: context, label: e.toString());
      _enablePartThree = false;
    }

    log(privateKey);
    log(address.toString());

    await prefs.setString('address', '$address');
    await prefs.setString('privateKey', privateKey);
    await prefs.setString('ethbalance', ethbal.toString());
  }

  Container _buildPartTwo(BuildContext context) {
    return Container(
      width: AppUtils.appMQ(context: context, flag: 'w') - 40,
      color: Theme.of(context).backgroundColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const CustomText(
          label: 'Add private key',
          fontSize: 16,
          fontWeight: bold,
        ),
        spaceH1,
        TextFormField(
          readOnly: _enablePartTwo ? false : true,
          controller: _metaMuskController,
          validator: (value) {
            return value!.isEmpty ? "Invalid Input" : null;
          },
          style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'MetaMusk ID',
            hintStyle:
                Theme.of(context).textTheme.headline3!.copyWith(fontSize: 14),
            border: const OutlineInputBorder(),
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
        spaceH2,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CommonButton(
                bgColor:
                    _enablePartTwo ? ColorConstants.primaryColor : Colors.grey,
                label: 'Add',
                onTap: () {
                  // if (_formKey.currentState!.validate()) { 
                    print("add pressed");
                    addEthWallet(_metaMuskController.text.trim()).then((value) {
                      AppUtils.showCustomSnackBarWithoutAction(
                          context: context,
                          label: 'Ethereum address added successfully!');
                    });

                    _enablePartThree = true;
                  // }
                })
          ],
        )
      ]),
    );
  }

  Container _buildPartOne(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: AppUtils.appMQ(context: context, flag: 'w') - 40,
      color: Theme.of(context).backgroundColor,
      child: Column(children: [
        const CustomText(
          label: 'Select an Avatar',
          fontSize: 18,
          fontWeight: bold,
        ),
        Center(
          child: GestureDetector(
            onTap: selectAnAvatar,
            child: Stack(
              // alignment: Alignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(AppUtils.getAvatarImage(
                    key: _currentImageAvatar ?? prefs.getInt('userAvatar')!,
                  )),
                  radius: AppUtils.appMQ(context: context, flag: 'w') / 6.0,
                ),
                Positioned(
                    bottom: 0,
                    right: 10,
                    child: CircleAvatar(
                        backgroundColor:
                            ColorConstants.primaryColor.withOpacity(0.95),
                        child: const Icon(Icons.account_circle,
                            color: Colors.white)))
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget _buildProgress(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(
            top: AppUtils.appMQ(context: context, flag: 'h') * (1 / 100) + 7),
        child: Column(
          children: [
            AnimatedContainer(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    color: _enablePartOne
                        ? ColorConstants.primaryColor
                        : ColorConstants.tertiaryColor,
                    borderRadius: BorderRadius.circular(20)),
                duration: const Duration(milliseconds: 500)),
            AnimatedContainer(
                height:
                    AppUtils.appMQ(context: context, flag: 'h') * (1 / 4) + 15,
                width: 3,
                decoration: BoxDecoration(
                  color: _enablePartOne && _enablePartTwo
                      ? ColorConstants.primaryColor
                      : ColorConstants.tertiaryColor,
                ),
                duration: const Duration(milliseconds: 500)),
            AnimatedContainer(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    color: _enablePartOne && _enablePartTwo
                        ? ColorConstants.primaryColor
                        : ColorConstants.tertiaryColor,
                    borderRadius: BorderRadius.circular(20)),
                duration: const Duration(milliseconds: 500)),
            AnimatedContainer(
                height:
                    AppUtils.appMQ(context: context, flag: 'h') * (1 / 4) + 10,
                width: 3,
                decoration: BoxDecoration(
                  color: _enablePartOne && _enablePartTwo && _enablePartThree
                      ? ColorConstants.primaryColor
                      : ColorConstants.tertiaryColor,
                ),
                duration: const Duration(milliseconds: 500)),
            AnimatedContainer(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    color: _enablePartOne && _enablePartTwo && _enablePartThree
                        ? ColorConstants.primaryColor
                        : ColorConstants.tertiaryColor,
                    borderRadius: BorderRadius.circular(20)),
                duration: const Duration(milliseconds: 500)),
          ],
        ),
      ),
    );
  }
}

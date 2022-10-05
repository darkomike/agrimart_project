import 'dart:developer';
import 'dart:ffi';

import 'package:block_agri_mart/app/app.dart';
import 'package:block_agri_mart/app/constants/escrow.dart';
import 'package:block_agri_mart/app/constants/web3terminal.dart';
import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/domain/transactions/model/transaction_model.dart';
import 'package:block_agri_mart/firebase/firebase_transaction_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../main.dart';
import '../../home/home.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool _isMakingPayment = false;

  @override
  Widget build(BuildContext context) {
    String amountpayable = Provider.of<CartStateManager>(context, listen: false)
        .totalCost
        .toString();
    double agrolink =
        Provider.of<CartStateManager>(context, listen: false).agrolink;
    return Scaffold(
      bottomNavigationBar: _buildMakePayment(context),
      appBar: const CustomAppBar(
          showCart: true,
          showProfilePic: true,
          title: 'Make Payment',
          showAddProduct: false,
          isDashboard: false,
          showNotification: true,
          onTransparentBackground: false),
      body: Container(
        height: AppUtils.appMQ(context: context, flag: 'h'),
        width: AppUtils.appMQ(context: context, flag: 'w'),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: const BoxDecoration(),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Form(
                child: Column(
              children: [
                _idcard(
                    context, 'Seller\'s ID:', '${prefs.getString('address')}'),
                const SizedBox(height: 10),
                _idcard(context, 'Number of items:',
                    '${Provider.of<CartStateManager>(context, listen: false).productsInCart.length}'),
                const SizedBox(height: 10),
                _idcard(context, 'Total Amount Payable', amountpayable),
                const SizedBox(height: 10),
                _idcard(context, 'Agrolink Tokens awarded:', '$agrolink AG'),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      '0.02% of total amount payable',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    children: [
                      const Text(
                        'NB:',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Gas prices may fluctuate per time of transaction',
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontSize: 16.0, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Container _buildMakePayment(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, left: 5, top: 5, right: 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MaterialButton(
              minWidth: 250,
              disabledColor: Colors.grey.shade500,
              height: 45,
              color: ColorConstants.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: 4 == 4
                  ? () {
                      _isMakingPayment = true;
                      String? ethereum = prefs.getString('ethbalance') ?? '0';
                      int items =
                          Provider.of<CartStateManager>(context, listen: false)
                              .productsInCart
                              .length;

                      if (double.parse(ethereum) < 0.0) {
                        AppUtils.showCustomSnackBarWithoutAction(
                            context: context,
                            label: 'Ethereum balance is not sufficient');
                      }
                      if (items < 0) {
                        AppUtils.showCustomSnackBarWithoutAction(
                            context: context,
                            label: 'There are no items in the cart');
                      } else {
                        makeTransactionstoescrow(
                            context, prefs.getString('address'));
                      }
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                      label: _isMakingPayment
                          ? 'Processing Payment...'
                          : 'Make Payment',
                      fontSize: 15,
                      color: Colors.white),
                  const SizedBox(
                    width: 10,
                  ),
                  _isMakingPayment
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
    );
  }

  makeTransactionstoescrow(
      BuildContext context, var receiverWalletAddress) async {
    String rpcUrl = Web3Terminal.rpcUrl;
    String wsUrl = Web3Terminal.wsUrl;
    Web3Client client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    var privateKey = prefs.getString('privateKey') ?? '';
    String buyer = prefs.getString('address') ?? '';
    double amount =
        Provider.of<CartStateManager>(context, listen: false).totalCost;
    Credentials credentials = EthPrivateKey.fromHex(privateKey);
    EthereumAddress _address = await credentials.extractAddress();
    EtherAmount etherAmount = await client.getBalance(_address);
    var ethereum = etherAmount.getValueInUnit(EtherUnit.ether);

    String transactionID = buyer + amount.toString();
    log(transactionID);

    try {
      if (ethereum >= amount) {
        try {
          await client
              .sendTransaction(
                  credentials,
                  Transaction(
                    from: _address,
                    to: EthereumAddress.fromHex(Escrow.escrow),
                    gasPrice: EtherAmount.inWei(BigInt.one),
                    maxGas: 100000,
                    value: EtherAmount.fromUnitAndValue(
                        EtherUnit.ether, amount.floor()),
                  ))
              .then((value) {
            TransactionModel model = TransactionModel(
                transactionSeller:
                    Provider.of<CartStateManager>(context, listen: false)
                        .sellerID,
                transactionStatus: 0,
                transactionID: transactionID,
                transactionAmount: amount.toString(),
                transactionTimeStamp: DateTime.now().toIso8601String(),
                transactionBuyer: buyer);

            TransactionFirebaseApi.addTransaction(
                transactionID: transactionID, data: model.toJson());
            AppUtils.delayFunction(
                duration: 1,
                action: () async {
                  setState(() {
                    prefs.setString('ethbalance',
                        etherAmount.getValueInUnit(EtherUnit.ether).toString());
                    Provider.of<CartStateManager>(context, listen: false)
                        .calculateagrotokens();
                  });

                  AppUtils.showCustomDialog(
                      context: context,
                      content: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        height: AppUtils.appMQ(context: context, flag: 'h') / 2,
                        child: Column(children: [
                          Center(
                            child: SizedBox(
                                height: AppUtils.appMQ(
                                        context: context, flag: 'h') /
                                    3,
                                width: 150,
                                child: Image.asset(
                                    AppUtils.getImage(name: 'shield'))),
                          ),
                          const CustomText(label: "Operation Successful"),
                          const SizedBox(height: 10),
                          CommonButton(
                            bgColor: ColorConstants.primaryColor,
                            label: 'Contact Seller',
                            onTap: () {
                              final Uri smsUri = Uri(
                                
                                  scheme: 'sms',
                                  path: Provider.of<CartStateManager>(context,listen: false)
                                      .sellerNumber);

                              launchUrl(smsUri).then((value) {
                                Provider.of<CartStateManager>(context,
                                        listen: false) 
                                    .emptyCart();
                                AppUtils.navigatePushReplace(
                                    context: context,
                                    destination: const LandingScreen());
                              });
                            },
                          ),
                        ]),
                      ));
                });
            setState(() {});
          });
        } on Exception catch (e) {
          AppUtils.showCustomSnackBarWithoutAction(
              context: context, label: e.toString());
        }
      } else {
        AppUtils.showCustomDialog(
            context: context,
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const CustomText(label: 'OK'))
            ],
            content: SizedBox(
                height: 100,
                width: 200,
                child: CustomText(
                  label: 'Insufficient Balance in your Wallet',
                  fontWeight: FontWeight.w300,
                  color: ColorConstants.errorColor,
                )));
      }
    } on WebSocketChannelException catch (e) {
      AppUtils.showCustomSnackBarWithoutAction(
          context: context, label: e.toString());
    }
  }
}

ListTile _idcard(BuildContext context, String leading, String title) {
  return ListTile(
    leading: Text(
      leading,
      style: Theme.of(context)
          .textTheme
          .headline3!
          .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
    ),
    title: Container(
      height: 40,
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.5, color: ColorConstants.primaryColor)),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

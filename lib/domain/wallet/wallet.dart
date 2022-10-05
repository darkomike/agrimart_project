import 'dart:developer';

import 'package:block_agri_mart/app/app.dart';
import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/domain/transactions/transactions.dart';
import 'package:block_agri_mart/firebase/firebase_transaction_api.dart';
import 'package:block_agri_mart/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../transactions/model/transaction_model.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Stream<List<TransactionModel>> alltransactions;
  late Stream<List<TransactionModel>> personaltransactions;

  @override
  void initState() {
    alltransactions = TransactionFirebaseApi.getAllTransactions();
    personaltransactions = TransactionFirebaseApi.getPersonalTransactions(
        minerID: prefs.getString('userMetaMuskAddress')!);
    log("Other Requests: ${alltransactions.first}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBar(
          showCart: false,
          showProfilePic: true,
          title: 'My Wallet',
          showAddProduct: false,
          isDashboard: false,
          showNotification: false,
          onTransparentBackground: false),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildWalletCard(size),
            spaceH1,
            spaceH1,
            _buildTradingHistory()
          ],
        ),
      ),
    );
  }

  Flexible _buildTradingHistory() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
              label: 'Trading History', fontWeight: FontWeight.w500),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                SizedBox(
                  child: StreamBuilder<List<TransactionModel>>(
                      stream: personaltransactions,
                    initialData: [],
                      builder: (context, snapshot) {
                        if (snapshot.data!.isNotEmpty) {
                          final transactions = snapshot.data!;

                          return Flexible(
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  return NewTransactionCard(
                                      transactionfrom:
                                          transaction.transactionBuyer,
                                      transactionto:
                                          transaction.transactionSeller,
                                      transactionAmount:
                                          transaction.transactionAmount,
                                      transactionID: transaction.transactionID,
                                      transactionStatus: transaction.transactionStatus, 
                                         
                                      transactionTime:
                                          transaction.transactionTimeStamp);
                                },
                                separatorBuilder: ((context, index) {
                                  return const SizedBox(
                                    height: 3,
                                  );
                                }),
                                itemCount: snapshot.data!.length), 
                          );
                        } else if (!snapshot.hasData) {
                          return Flexible(
                            child: ListView.separated(
                              itemCount: 7,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ShimmerWidget.circular(
                                  height: 60,
                                  width: double.infinity,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  thickness: 1.0,
                                  height: 4,
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: CustomText(
                              label: 'No Personal Transactions',
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildWalletCard(Size size) {
    double agrolink =
        Provider.of<CartStateManager>(context, listen: false).agrolinktotal;
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorConstants.primaryColor.withOpacity(.5),
      ),
      width: size.width - 10,
      child: Stack(
        children: [
          const Positioned(
              left: 10,
              top: 10,
              child: Text(
                'Ethereum Wallet Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )),
          Positioned(
              left: 10,
              top: 30,
              child: CustomText(
                  color: ColorConstants.secondaryColor,
                  label: AppUtils.shortenAddress1(
                      userAddress: prefs.getString("userMetaMuskAddress")!),
                  fontSize: 22,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700)),
          const Positioned(
              left: 10,
              top: 60,
              child: Text(
                'Ethereum Wallet Balance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )),
          Positioned(
              left: 10,
              top: 80,
              child: Text(
                '${prefs.getString('ethbalance')} ETH',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red.withOpacity(0.8),
                    fontWeight: FontWeight.w500),
              )),
          Positioned(
              left: 10,
              bottom: 25,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: CustomText(
                    label: 'AgroLink Tokens : $agrolink AG',
                    fontSize: 18,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500),
              )),
          Positioned(
            right: 0,
            child: CustomPaint(
              size: const Size(100,
                  200), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: RPSCustomPainter(),
            ),
          )
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.quadraticBezierTo(size.width * -0.0034500, size.height * 0.4088000, 0,
        size.height * 0.2616500);
    path0.cubicTo(
        size.width * 0.1250000,
        size.height * 0.1962375,
        size.width * 0.2410000,
        size.height * 0.0940000,
        size.width * 0.5000000,
        0);
    path0.quadraticBezierTo(size.width * 0.6001000, size.height * 0.3284500,
        size.width, size.height * 0.2500000);
    path0.quadraticBezierTo(size.width * 0.9553000, size.height * 0.6571000,
        size.width * 0.7500000, size.height * 0.7500000);
    path0.cubicTo(
        size.width * 0.5887500,
        size.height * 0.7767500,
        size.width * 0.5822500,
        size.height * 0.3893500,
        size.width * 0.2550000,
        size.height * 0.5000000);
    path0.quadraticBezierTo(
        size.width * 0.0646000, size.height * 0.5964000, 0, size.height);
    path0.close();

    throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Path path0 = Path();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

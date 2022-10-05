import 'dart:developer';

import 'package:block_agri_mart/app/constants/text.dart';
import 'package:block_agri_mart/app/constants/web3terminal.dart';
import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/app/widgets/custom_text.dart';
import 'package:block_agri_mart/app/widgets/widgets.dart';
import 'package:block_agri_mart/domain/transactions/model/transaction_model.dart';
import 'package:block_agri_mart/firebase/firebase_transaction_api.dart';
import 'package:block_agri_mart/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogflow_grpc/generated/google/protobuf/unittest_custom_options.pbjson.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:web_socket_channel/io.dart';
import '../../app/constants/color_constant.dart';
import '../../app/constants/escrow.dart';
import '../../app/widgets/shimmer_widget.dart';
import '../domain.dart';
import '../nav/tab/tab_button.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late PageController _pageController;

  int currentTabIndex = 0;

  late Stream<List<TransactionModel>> allTransactionsStream;
  late Stream<List<TransactionModel>> personalTransactionsStream;
  final String minerID = prefs.getString('userMetaMuskAddress')!;

  @override
  void initState() {
    super.initState();
    allTransactionsStream = TransactionFirebaseApi.getAllTransactions();
    personalTransactionsStream = TransactionFirebaseApi.getPersonalTransactions(
        minerID: prefs.getString('userMetaMuskAddress')!);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pageController = PageController();

    return Scaffold(
        appBar: CustomAppBar(
          isDashboard: false,
          showAddProduct: true,
          showCart: true,
          showNotification: true,
          title: "Transactions",
          showProfilePic: true,
          onTransparentBackground: false,
          bottom: PreferredSize(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorConstants.primaryColor.withOpacity(0.15),
              ),
              height: 60,
              padding: const EdgeInsets.only(left: 10, right: 10),
              margin: const EdgeInsets.only(left: 3, right: 3),
              child: Row(
                children: [
                  TabButton(
                    shouldExpand: true,
                    currentIndex: currentTabIndex,
                    index: 0,
                    label: 'Personal',
                    onPressed: () {
                      setState(() {
                        currentTabIndex = 0;
                        _pageController.jumpToPage(0);
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TabButton(
                    shouldExpand: true,
                    currentIndex: currentTabIndex,
                    index: 1,
                    label: 'All',
                    onPressed: () {
                      setState(() {
                        currentTabIndex = 1;
                        _pageController.jumpToPage(1);
                      });
                    },
                  ),
                ],
              ),
            ),
            preferredSize: const Size.fromHeight(50),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
          child: Flexible(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentTabIndex = index;
                });
              },
              children: [
                StreamBuilder<List<TransactionModel>>(
                    stream: personalTransactionsStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Flexible(
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
                          ),
                        );
                      } else {
                        if (snapshot.data!.isNotEmpty) {
                          final transactions = snapshot.data!;
                          log("Transaction: $transactions");

                          return TransactionSection(
                              sectionName: '',
                              sectionBody: Flexible(
                                child: ListView.separated(
                                  itemCount: snapshot.data!.length,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final transaction = transactions[index];
                                    return NewTransactionCard(
                                        transactionfrom:
                                            transaction.transactionBuyer,
                                        transactionto:
                                            transaction.transactionSeller,
                                        transactionAmount:
                                            transaction.transactionAmount,
                                        transactionID:
                                            transaction.transactionID,
                                        transactionStatus:
                                            transaction.transactionStatus,
                                        transactionTime:
                                            transaction.transactionTimeStamp);
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      thickness: 1.0,
                                      height: 4,
                                    );
                                  },
                                ),
                              ));
                        } else {
                          return const Center(
                            child: CustomText(
                              label: 'No Personal Transactions',
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        }
                      }
                    }),
                StreamBuilder<List<TransactionModel>>(
                    stream: allTransactionsStream,
                    // initialData: const [],
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Flexible(
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
                          ),
                        );
                      } else {
                        if (snapshot.data!.isNotEmpty) {
                          final requests = snapshot.data!;
                          log("Rquest: $requests");
                          return ListView.separated(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final transaction = requests[index];
                              return NewTransactionCard(
                                  transactionfrom: transaction.transactionBuyer,
                                  transactionto: transaction.transactionSeller,
                                  transactionAmount:
                                      transaction.transactionAmount,
                                  transactionID: transaction.transactionID,
                                  transactionStatus:
                                      transaction.transactionStatus,
                                  transactionTime:
                                      transaction.transactionTimeStamp);
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                thickness: 1.0,
                                height: 4,
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CustomText(
                              label: 'No Transactions',
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        }
                      }
                    }),
                Container(),
              ],
            ),
          ),
        ));
  }
}

class NewTransactionCard extends StatefulWidget {
  const NewTransactionCard(
      {Key? key,
      required this.transactionAmount,
      required this.transactionfrom,
      required this.transactionto,
      required this.transactionID,
      required this.transactionStatus,
      required this.transactionTime})
      : super(key: key);

  final String transactionID;
  final int transactionStatus;
  final String transactionTime;
  final String transactionfrom;
  final String transactionto;
  final String transactionAmount;

  @override
  State<NewTransactionCard> createState() => _NewTransactionCardState();
}

class _NewTransactionCardState extends State<NewTransactionCard> {
  sendmoneytoseller({required String tid}) async {
    String rpcUrl = Web3Terminal.rpcUrl;
    String wsUrl = Web3Terminal.wsUrl;
    web3.Web3Client client =
        web3.Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    web3.Credentials credentials = web3.EthPrivateKey.fromHex(Escrow.pk);
    web3.EthereumAddress _address = await credentials.extractAddress();
    web3.EtherAmount etherAmount = await client.getBalance(_address);
    var ethereum = etherAmount.getValueInUnit(web3.EtherUnit.ether);

    if (widget.transactionStatus == 0 &&
        ethereum >= double.parse(widget.transactionAmount)) {
      try {
        AppUtils.showCustomDialog(
            actions: [
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      height: 39,
                      width: 59,
                      bgColor: ColorConstants.primaryColor,
                      label: 'Yes',
                      onTap: () async {
                        await client
                            .sendTransaction(
                                credentials,
                                web3.Transaction(
                                  from: web3.EthereumAddress.fromHex(
                                      Escrow.escrow),
                                  to: web3.EthereumAddress.fromHex(
                                      widget.transactionto),
                                  gasPrice: web3.EtherAmount.inWei(BigInt.one),
                                  maxGas: 100000,
                                  value: web3.EtherAmount.fromUnitAndValue(
                                      web3.EtherUnit.ether,
                                      double.parse(widget.transactionAmount)
                                          .floor()),
                                ))
                            .then((value) {
                          FirebaseFirestore.instance
                              .collection('transactions')
                              .doc(tid)
                              .update({"transactionStatus": 1});
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                  spaceW1,
                  spaceW1,
                  Expanded(
                    child: CommonButton(
                        height: 39,
                        width: 59,
                        bgColor: ColorConstants.alertColor,
                        label: 'No',
                        onTap: (() => Navigator.pop(context))),
                  )
                ],
              )
            ],
            context: context,
            content: CustomText(
              label:
                  'Confirm transaction of ${widget.transactionAmount} to\n ${widget.transactionto}? ',
              fontFamily: "Quicksand",
            ));
      } on Exception catch (e) {
        AppUtils.showCustomSnackBarWithoutAction(
            context: context, label: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(colors: [
              ColorConstants.primaryColor.withOpacity(0.3),
              ColorConstants.secondaryColor.withOpacity(0.3)
            ])),
        child: ExpansionTile(
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: [
              Row(
                children: [
                  CustomText(
                    label: 'SellerID:  ',
                    fontSize: 12,
                    color: ColorConstants.secondaryColor,
                  ),
                  CustomText(label: widget.transactionto, fontSize: 10),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CustomText(
                    label: 'BuyerID:  ',
                    fontSize: 12,
                    color: ColorConstants.secondaryColor,
                  ),
                  CustomText(label: widget.transactionfrom, fontSize: 10),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CustomText(
                      label: 'Amount:  ',
                      color: ColorConstants.primaryColor,
                      fontSize: 12),
                  CustomText(
                      label: widget.transactionAmount,
                      color: ColorConstants.errorColor,
                      fontSize: 12),
                ],
              ),
              spaceH1,
              widget.transactionStatus == 0
                  ? widget.transactionfrom ==
                          prefs.getString("userMetaMuskAddress")
                      ? Row(
                          children: [
                            Expanded(
                                child: CommonButton(
                              bgColor: ColorConstants.secondaryColor,
                              label: 'Confirm Transaction',
                              onTap: () {
                                sendmoneytoseller(tid: widget.transactionID);
                                setState(() {});
                              },
                            ))
                          ],
                        )
                      : const SizedBox()
                  : const SizedBox()
            ],
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).backgroundColor,
              child: Icon(
                Icons.transfer_within_a_station_sharp,
                color: widget.transactionStatus == 0
                    ? Colors.orange
                    : ColorConstants.primaryColor,
              ),
            ),
            title: CustomText(
              fontSize: 10,
              label: widget.transactionID,
            ),
            trailing: CustomText(
              label: widget.transactionTime,
              fontSize: 10,
            )));
  }
}

class TransactionSection extends StatelessWidget {
  const TransactionSection(
      {Key? key, required this.sectionName, required this.sectionBody})
      : super(key: key);

  final String sectionName;
  final Widget sectionBody;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            label: sectionName,
            fontWeight: bold,
          ),
          spaceH1,
          sectionBody
        ],
      ),
    );
  }
}

class CustomSectionTitleAndTiles extends StatelessWidget {
  const CustomSectionTitleAndTiles(
      {Key? key, required this.sectionName, required this.sectionBody})
      : super(key: key);

  final String sectionName;
  final Widget sectionBody;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label: sectionName,
          fontWeight: bold,
        ),
        spaceH1,
        sectionBody
      ],
    );
  }
}

//
//                 StreamBuilder<List<TransactionModel>>(
//                     stream: null,
//                     initialData: const [],
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return ListView.separated(
//                           itemCount: 7,
//                           shrinkWrap: true,
//                           physics: const BouncingScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return ShimmerWidget.circular(
//                               height: 60,
//                               width: double.infinity,
//                               shapeBorder: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                             );
//                           },
//                           separatorBuilder: (context, index) {
//                             return const Divider(
//                               thickness: 1.0,
//                               height: 4,
//                             );
//                           },
//                         );
//                       } else {
//                         final transactions = snapshot.data!;
//                         if (snapshot.data!.isNotEmpty) {
//                           return ListView.separated(
//                             itemCount: snapshot.data!.length,
//                             shrinkWrap: true,
//                             physics: const BouncingScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               final transaction = transactions[index];
//                               return TransactionCard(
//                                   body: transaction.transactionContent,
//                                   time: transaction.transactionTimeStamp,
//                                   title: transaction.transactionTitle);
//                             },
//                             separatorBuilder: (context, index) {
//                               return const Divider(
//                                 thickness: 1.0,
//                                 height: 4,
//                               );
//                             },
//                           );
//                         } else {
//                           return const Center(
//                             child: CustomText(
//                               label: 'No Transactions',
//                               fontWeight: FontWeight.w700,
//                             ),
//                           );
//                         }
//                       }
//                     }),

import 'dart:developer';

import 'package:block_agri_mart/app/utils/product_utils.dart';
import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/app/widgets/shimmer_widget.dart';
import 'package:block_agri_mart/domain/requests/make_request.dart';
import 'package:block_agri_mart/domain/requests/model/make_request_model.dart';
import 'package:block_agri_mart/domain/requests/model/request_model.dart';
import 'package:block_agri_mart/firebase/firebase_request_api.dart';
import 'package:block_agri_mart/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/constants/color_constant.dart';
import '../../app/widgets/custom_text.dart';
import '../domain.dart';
import '../nav/tab/tab_button.dart';
import '../transactions/transactions.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _pageController;
  int currentTabIndex = 0;

  late Stream<List<RequestModel>> othersRequests;
  late Stream<List<RequestModel>> personalRequests;

  @override
  void initState() {
    othersRequests = FirebaseRequestApi.getOthersRequests();
    personalRequests = FirebaseRequestApi.getPersonalRequests(
        userID: prefs.getString('userMetaMuskAddress')!);
    log("Other Requests: ${othersRequests.first}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _pageController = PageController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      key: _scaffoldKey,
      appBar: CustomAppBar(
        isDashboard: true,
        showCart: true,
        showAddProduct: true,
        showNotification: true,
        title: "Requests",
        bottom: _buildRequestsTabs(),
        showProfilePic: true,
        onTransparentBackground: false,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'requests',
        backgroundColor: ColorConstants.primaryColor,
        onPressed: () {
          AppUtils.navigatePush(
              context: context, destination: const MakeRequest());
        },
        child: const Icon(
          Icons.send_time_extension,
          color: Colors.white,
        ),
      ),
      body: SizedBox(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          children: [
            _buildPersonalRequests(),
            _buildOthersRequests(),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildRequestsTabs() {
    return PreferredSize(
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
              label: 'Others',
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
    );
  }

  _buildOthersRequests() {
    return OtherRequests(othersRequests: othersRequests);
  }

  _buildPersonalRequests() {
    return PersonalRequests(personalRequests: personalRequests);
  }
}

class OtherRequests extends StatelessWidget {
  const OtherRequests({
    Key? key,
    required this.othersRequests,
  }) : super(key: key);

  final Stream<List<RequestModel>> othersRequests;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RequestModel>>(
        stream: othersRequests,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            log("Snapshot Data: ${snapshot.data![0]}");
            return Flexible(
              child: ListView.separated(
                itemCount: snapshot.data!.length,
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
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const CustomText(label: "Something went wrong"),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonButton(
                        bgColor: ColorConstants.primaryColor,
                        label: 'Try Again',
                        onTap: () {},
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )),
            );
          } else {
            final requests = snapshot.data!;

            return snapshot.data!.isEmpty
                ? Center(
                    child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: const [
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: CustomText(
                                label: 'No Requests',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )),
                  )
                : Flexible(
                    child: ListView.separated(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        return RequestCard(
                          requestContent: [
                            spaceH1,
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(
                                    label: 'Total Price',
                                    fontFamily: 'Quicksand',
                                    fontSize: 16,
                                    fontWeight: bold,
                                  ),
                                  CustomText(
                                    label:
                                        "${request.requestedProductsTotalPriceToPay} ETH",
                                    fontFamily: 'Quicksand',
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: bold,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                                height: 10,
                                thickness: 1.5,
                                endIndent: 10,
                                indent: 20),
                            Container(
                                padding:
                                    const EdgeInsets.only(left: 27, top: 10),
                                alignment: Alignment.centerLeft,
                                child: const CustomText(
                                  label: 'Items Requested',
                                  fontFamily: 'Quicksand',
                                  fontSize: 16,
                                  fontWeight: bold,
                                )),
                            SizedBox(
                                child: Flexible(
                              child: request.requestedProducts!.isEmpty
                                  ? const Center(
                                      child: CustomText(
                                        label: 'No products Requested',
                                      ),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      reverse: false,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final product =
                                            MakeRequestModel.fromJson(request
                                                .requestedProducts![index]);
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                AppUtils.getProductImage(
                                                    name: product.productName!
                                                        .toLowerCase())),
                                          ),
                                          title: CustomText(
                                            label: product.productName!,
                                            fontSize: 14,
                                          ),
                                          subtitle: CustomText(
                                            label:
                                                "Quantity: ${product.productQuantity!} units",
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          spaceH1,
                                      itemCount:
                                          request.requestedProducts!.length),
                            )),
                            RequestUtils.compareRequestIDs(
                                    minerID:
                                        prefs.getString('userMetaMuskAddress')!,
                                    requestID: request.requestID!)
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: CommonButton(
                                          bgColor:
                                              ColorConstants.secondaryColor,
                                          label: "Accept Request",
                                          onTap: () {},
                                          height: 40,
                                        )),
                                      ],
                                    ),
                                  )
                          ],
                          requestID: request.requestID!.split(' ')[0],
                          requestStatus: request.requestedStatus!,
                          requestTime: DateFormat("KK:mm a")
                              .format(DateTime.parse(request.requestedAt!)),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return spaceH1;
                      },
                    ),
                  );
          }
        });
  }
}

class RequestCard extends StatelessWidget {
  const RequestCard(
      {Key? key,
      required this.requestContent,
      required this.requestID,
      required this.requestStatus,
      required this.requestTime})
      : super(key: key);
  final String requestID;
  final int requestStatus;
  final String requestTime;
  final List<Widget> requestContent;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(colors: [
              ColorConstants.primaryColor.withOpacity(0.3),
              ColorConstants.secondaryColor.withOpacity(0.3)
            ])),
        child: ExpansionTile(
            initiallyExpanded: false,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).backgroundColor,
              child: Icon(
                Icons.send,
                color: requestStatus == 0
                    ? ColorConstants.primaryColor
                    : ColorConstants.secondaryColor,
              ),
            ),
            children: requestContent,
            title: CustomText(
              fontSize: 12,
              label: requestID,
            ),
            trailing: CustomText(
              label: requestTime,
              fontSize: 10,
            )));
  }
}

class PersonalRequests extends StatelessWidget {
  const PersonalRequests({
    Key? key,
    required this.personalRequests,
  }) : super(key: key);

  final Stream<List<RequestModel>> personalRequests;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RequestModel>>(
        stream: personalRequests,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            log("Snapshot Data: ${snapshot.data![0]}");
            return _buildShimmerEffect();
          } else if (snapshot.hasError) {
            return _buildErrorWIdget();
          } else {
            final requests = snapshot.data!;

            return snapshot.data!.isEmpty
                ? _buildEmptyRequest()
                : _buildRequestsWidget(snapshot, requests);
          }
        });
  }

  Container _buildRequestsWidget(
      AsyncSnapshot<List<RequestModel>> snapshot, List<RequestModel> requests) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Flexible(
        child: ListView.separated(
          itemCount: snapshot.data!.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final request = requests[index];
            return RequestCard(
              requestContent: [
                spaceH1,
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        label: 'Total Price',
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        fontWeight: bold,
                      ),
                      CustomText(
                        label:
                            "${request.requestedProductsTotalPriceToPay} ETH",
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: bold,
                      ),
                    ],
                  ),
                ),
                const Divider(
                    height: 10, thickness: 1.5, endIndent: 10, indent: 20),
                Container(
                    padding: const EdgeInsets.only(left: 27, top: 10),
                    alignment: Alignment.centerLeft,
                    child: const CustomText(
                      label: 'Items Requested',
                      fontFamily: 'Quicksand',
                      fontSize: 16,
                      fontWeight: bold,
                    )),
                SizedBox(
                    child: request.requestedProducts!.isEmpty
                        ? const Center(
                            child: CustomText(
                              label: 'No products Requested',
                            ),
                          )
                        : Flexible(
                            child: ListView.separated(
                                shrinkWrap: true,
                                reverse: false,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final product = MakeRequestModel.fromJson(
                                      request.requestedProducts![index]);
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          AppUtils.getProductImage(
                                              name: product.productName!
                                                  .toLowerCase())),
                                    ),
                                    title: CustomText(
                                      label: product.productName!,
                                      fontSize: 14,
                                    ),
                                    subtitle: CustomText(
                                      label:
                                          "Quantity: ${product.productQuantity!} units",
                                      fontSize: 12,
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => spaceH1,
                                itemCount: request.requestedProducts!.length),
                          )),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   child: Row(
                //     children: [
                //       Expanded(
                //           child: CommonButton(
                //         bgColor: ColorConstants.alertColor,
                //         label: "Cancel Request",
                //         onTap: () {
                //           //TODO: Cancel Request
                //           showDialog(
                //               context: context,
                //               builder: (context) => AlertDialog(
                //                     backgroundColor: Theme.of(context)
                //                         .backgroundColor
                //                         .withOpacity(1),
                //                     title: Text(
                //                       "Do you want to cancel request?",
                //                       style: Theme.of(context)
                //                           .textTheme
                //                           .headline3!
                //                           .copyWith(fontSize: 16),
                //                     ),
                //                     actions: [
                //                       MaterialButton(
                //                           child: Text(
                //                             "No",
                //                             style: Theme.of(context)
                //                                 .textTheme
                //                                 .headline3!
                //                                 .copyWith(fontSize: 12),
                //                           ),
                //                           onPressed: () =>
                //                               Navigator.pop(context)),
                //                       MaterialButton(
                //                           child: Text(
                //                             "Yes",
                //                             style: Theme.of(context)
                //                                 .textTheme
                //                                 .headline3!
                //                                 .copyWith(fontSize: 12),
                //                           ),
                //                           onPressed: () {
                //                             FirebaseFirestore.instance
                //                                 .collection('requests')
                //                                 .doc(request.requestID)
                //                                 .delete();
                //                             Navigator.pop(context);
                //                           })
                //                     ],
                //                   ));
                //         },
                //         height: 40,
                //       )),
                //     ],
                //   ),
                // )
              ],
              requestID: request.requestID!.split(' ')[0],
              requestStatus: request.requestedStatus!,
              requestTime: DateFormat("KK:mm a")
                  .format(DateTime.parse(request.requestedAt!)),
            );
          },
          separatorBuilder: (context, index) {
            return spaceH1;
          },
        ),
      ),
    );
  }

  Center _buildEmptyRequest() {
    return Center(
      child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: const [
              SizedBox(
                height: 30,
              ),
              Center(
                child: CustomText(
                  label: 'No Personal Requests',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          )),
    );
  }

  Center _buildErrorWIdget() {
    return Center(
      child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const CustomText(label: "Something went wrong"),
              const SizedBox(
                height: 10,
              ),
              CommonButton(
                bgColor: ColorConstants.primaryColor,
                label: 'Try Again',
                onTap: () {},
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          )),
    );
  }

  Flexible _buildShimmerEffect() {
    return Flexible(
      child: ListView.separated(
        itemCount: 7,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return ShimmerWidget.circular(
            height: 60,
            width: double.infinity,
            shapeBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
  }
}

// class RequestCard extends StatelessWidget {
//   const RequestCard(
//       {Key? key,
//       required this.requestContent,
//       required this.requestID,
//       required this.requestStatus,
//       required this.requestTime})
//       : super(key: key);
//   final String requestID;
//   final int requestStatus;
//   final String requestTime;
//   final List<Widget> requestContent;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             gradient: LinearGradient(colors: [
//               ColorConstants.primaryColor.withOpacity(0.3),
//               ColorConstants.secondaryColor.withOpacity(0.3)
//             ])),
//         child: ExpansionTile(
//             initiallyExpanded: false,
//             leading: CircleAvatar(
//               backgroundColor: Theme.of(context).backgroundColor,
//               child: Icon(
//                 Icons.send,
//                 color: requestStatus == 0
//                     ? ColorConstants.primaryColor
//                     : ColorConstants.secondaryColor,
//               ),
//             ),
//             children: requestContent,
//             title: CustomText(
//               fontSize: 12,
//               label: requestID,
//             ),
//             trailing: CustomText(
//               label: requestTime,
//               fontSize: 10,
//             )));
//   }
// }

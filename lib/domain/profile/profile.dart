import 'dart:developer';

import 'package:block_agri_mart/app/constants/text.dart';
import 'package:block_agri_mart/domain/chatbot/chat_bot.dart';
import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/domain/products/components/my_products.dart';
import 'package:block_agri_mart/main.dart';
import 'package:dialogflow_grpc/generated/google/type/phone_number.pb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/provider/app_provider.dart';
import '../../app/constants/color_constant.dart';
import '../../app/utils/utils.dart';
import '../../app/widgets/custom_text.dart';
import '../auth/components/passcodes.dart';

class ProfileScreen extends StatefulWidget {
  // final MinerModel miner;

  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String phonenumber = prefs.getString('userPhonenumber') ?? '';
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.chat_bubble,
            color: Colors.white,
          ),
          backgroundColor: ColorConstants.primaryColor,
          onPressed: () {
            AppUtils.navigatePush(context: context, destination: const Chat());
          }),
      key: _scaffoldKey,
      body: NestedScrollView(
        headerSliverBuilder: ((context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 200,
                backgroundColor:
                    Theme.of(context).backgroundColor.withOpacity(1),
                pinned: true,
                floating: true,
                snap: true,
                leading: const SizedBox(),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(bottom: 15, left: 5),
                  title: GestureDetector(
                    onTap: () {
                      AppUtils.showCustomDialog(
                          context: context,
                          content: SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                const CustomText(
                                  label: "User ID",
                                  fontSize: 14,
                                ),
                                spaceW2,
                                CustomText(
                                  label:
                                      prefs.getString('userMetaMuskAddress')!,
                                  fontSize: 14,
                                  color: ColorConstants.secondaryColor,
                                ),
                                spaceW1,
                              ],
                            ),
                          ));
                    },
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, top: 5, bottom: 5, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.5)),
                        child: CustomText(
                            label: AppUtils.shortenAddress1(
                                userAddress:
                                    prefs.getString("userMetaMuskAddress")!),
                            fontSize: 12)),
                  ),
                  background: Image.asset(
                    AppUtils.getAvatarImage(key: prefs.getInt("userAvatar")!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ]),
        body: Flexible(
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   const CustomText(
                    label: "Joined",
                    fontSize: 14,
                  ),
                  spaceW1
                  ,  CustomText(
                    label: "2022",
                    fontSize: 14,
                    color: ColorConstants.secondaryColor,
                  ),
                  spaceW1
                ],
              ),
              spaceW2,          
              spaceH1,
              context.watch<AppStateManager>().userType == "seller"
                  ? ListTile(
                      title:
                          const CustomText(label: 'My Products', fontSize: 16),
                      onTap: () {
                        AppUtils.navigatePush(
                            context: context,
                            destination: MyProducts(
                              ownerID: prefs.getString('userMetaMuskAddress')!,
                              fromSelf: true,
                            ));
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color:
                            Theme.of(context).iconTheme.color!.withOpacity(0.8),
                      ),
                    )
                  : const SizedBox(),
              ListTile(
                title: const CustomText(label: 'Phone Number', fontSize: 16),
                trailing: CustomText(label: phonenumber, fontSize: 16),
              ),
              ListTile(
                title: const CustomText(label: 'About us', fontSize: 16),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AboutDialog(
                            applicationIcon: SizedBox(
                              width: 50,
                              height: 50,
                              child: LottieWidget(
                                lottiePath: AppUtils.getLottie(name: '4'),
                              ),
                            ),
                            applicationName: 'AgriMart',
                            applicationVersion: '1.0.0',
                          ));
                },
              ),
              SwitchListTile(
                  activeColor: ColorConstants.primaryColor,
                  title: CustomText(
                      label: context.watch<AppStateManager>().darkModeOn
                          ? 'Dark Mode On'
                          : 'Dark Mode Off',
                      fontSize: 16),
                  value: context.watch<AppStateManager>().darkModeOn,
                  onChanged: (value) {
                    context.read<AppStateManager>().setIsDarkModeOn(value);
                  }),
              ListTile(
                title: CustomText(
                  label: context.watch<AppStateManager>().userType == 'buyer'
                      ? 'Switch to Seller Mode'
                      : 'Switch to Buyer Mode',
                  fontSize: 16,
                  color: Colors.red,
                ),
                onTap: () {
                  Provider.of<AppStateManager>(context, listen: false)
                      .switchMode(
                          userType: prefs.getString('userType') == 'buyer'
                              ? 'seller'
                              : 'buyer');
                },
              ),
              ListTile(
                title: const CustomText(
                  label: 'Change passcode',
                  fontSize: 16,
                  color: Colors.red,
                ),
                onTap: () {
                  AppUtils.navigatePush(
                      context: context,
                      destination: PassCodeScreen(fromAuth: false));
                },
              ),
              ListTile(
                title: const CustomText(
                  label: 'Privacy Policy',
                  fontSize: 16,
                  color: Colors.red,
                ),
                onTap: () {
                  AppUtils.showCustomDialog(
                      context: context, content: readPrivacyPolicy());
                },
              ),
              ListTile(
                title: const CustomText(
                  label: 'Terms of Service',
                  fontSize: 16,
                  color: Colors.red,
                ),
                onTap: () {
                  AppUtils.showCustomDialog(
                      context: context, content: readTermsOfService());
                },
              ),
              ListTile(
                  title: const CustomText(
                    label: 'Logout',
                    fontSize: 16,
                    color: Colors.red,
                  ),
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            backgroundColor: Theme.of(context).backgroundColor,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              height: 140,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "User Logout",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Do you want to logout?",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: MaterialButton(
                                              height: 40,
                                              color: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  side: const BorderSide(
                                                    width: 1,
                                                    color: Colors.red,
                                                  )),
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          child: MaterialButton(
                                              height: 40,
                                              color:
                                                  ColorConstants.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  side: BorderSide(
                                                    width: 1,
                                                    color: ColorConstants
                                                        .primaryColor,
                                                  )),
                                              child: const Text(
                                                "Logout",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                try {
                                                  context
                                                      .read<AppStateManager>()
                                                      .logout();
                                                  AppUtils.showCustomSnackBarWithoutAction(
                                                      context: context,
                                                      label:
                                                          'Logging user out...',
                                                      duration: 3);
                                                  AppUtils.delayFunction(
                                                      duration: 3,
                                                      action: () {
                                                        AppUtils.navigatePushReplace(
                                                            context: context,
                                                            destination:
                                                                const AuthScreen());
                                                      });
                                                } catch (e) {
                                                  log("profile_icon.dart: Error in logout func $e");
                                                }
                                              })),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            elevation: 10,
                          )))
            ],
          ),
        ),
      ),
    );
  }

  Flexible readTermsOfService() {
    return Flexible(
      child: SizedBox(
        height: AppUtils.appMQ(context: context, flag: 'h') * (2 / 3),
        width: AppUtils.appMQ(context: context, flag: 'w') - 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
                label: 'Terms of Service', fontWeight: bold, fontSize: 16),
            spaceH1,
            Flexible(
              child: ListView(
                children: [
                  CustomText(
                      label: TextConstant.dummyText3 +
                          TextConstant.dummyText3 +
                          TextConstant.dummyText3 +
                          TextConstant.dummyText3,
                      fontSize: 13),
                  spaceH1,
                  spaceH1,
                  CommonButton(
                      bgColor: ColorConstants.secondaryColor,
                      label: 'Back',
                      onTap: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Flexible readPrivacyPolicy() {
    return Flexible(
      child: SizedBox(
        height: AppUtils.appMQ(context: context, flag: 'h') * (2 / 3),
        width: AppUtils.appMQ(context: context, flag: 'w') - 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
                label: 'Privacy Policy', fontWeight: bold, fontSize: 18),
            spaceH1,
            Flexible(
              child: ListView(
                children: [
                  CustomText(
                      label: TextConstant.dummyText3 +
                          TextConstant.dummyText3 +
                          TextConstant.dummyText3 +
                          TextConstant.dummyText3,
                      fontSize: 13),
                  spaceH1,
                  spaceH1,
                  CommonButton(
                      bgColor: ColorConstants.secondaryColor,
                      label: 'Back',
                      onTap: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

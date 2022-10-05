import 'package:block_agri_mart/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../../../../app/provider/app_provider.dart';
import '../../../../app/constants/color_constant.dart';
import '../../../../app/utils/utils.dart';
import '../../../../hive/miner_model.dart';
import '../../../../main.dart';

class ProfileIcon extends StatefulWidget {
  const ProfileIcon({
    required this.tag,
    Key? key,
  }) : super(key: key);

  final String tag;

  @override
  State<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends State<ProfileIcon> {
  bool visible = false;
  @override
  void initState() {
    super.initState();
    InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            // ignore: avoid_print
            setState(() {
              visible = true;
            });

            print('Data connection is available.');
            break;
          case InternetConnectionStatus.disconnected:
            // ignore: avoid_print
            setState(() {
              visible = false;
            });
            print('You are disconnected from the internet.');
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppUtils.navigatePush(
            context: context, destination: const ProfileScreen());
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  backgroundColor: Theme.of(context).backgroundColor,
                  child: Flexible(
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
                                    fontSize: 14, fontWeight: FontWeight.bold),
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
                                        style: TextStyle(color: Colors.white),
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
                                      color: ColorConstants.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(
                                            width: 1,
                                            color: ColorConstants.primaryColor,
                                          )),
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        try {
                                          context
                                              .read<AppStateManager>()
                                              .logout();
                                          AppUtils
                                              .showCustomSnackBarWithoutAction(
                                                  context: context,
                                                  label: 'Logging user out...',
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
                                          print(
                                              "profile_icon.dart: Error in logout func $e");
                                        }
                                      })),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  elevation: 10,
                ));
      },
      child: Stack(
        children: [
          Hero(
            tag: widget.tag,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: AssetImage(
                    AppUtils.getAvatarImage(key: prefs.getInt("userAvatar")!)),
              ),
            ),
          ),
          visible
              ? Positioned(
                  right: 8,
                  bottom: 5,
                  child: Icon(
                    Icons.circle,
                    color: ColorConstants.primaryColor,
                    size: 14,
                  ))
              : const SizedBox()
        ],
      ),
    );
  }
}

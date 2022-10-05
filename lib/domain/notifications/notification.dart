import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/app/widgets/shimmer_widget.dart';
import 'package:block_agri_mart/app/widgets/404.dart';
import 'package:block_agri_mart/domain/notifications/components/empty_notifications.dart';
import 'package:block_agri_mart/domain/notifications/models/notification_model.dart';
import 'package:block_agri_mart/firebase/firebase_notification_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../app/constants/color_constant.dart';
import '../../app/widgets/custom_text.dart';
import '../nav/appbar/custom_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late Stream<List<NotificationModel>> notificationStreams;

  // @override
  // void initState() {
  //   super.initState();
  //   notificationStreams = NotificationFirebaseApi.getAllNotifications();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: const CustomAppBar(
            isDashboard: false,
            showCart: true,
            showAddProduct: false,
            showNotification: false,
            title: 'Notifications',
            showProfilePic: true,
            onTransparentBackground: false),
        body: StreamBuilder<List<NotificationModel>>(
            stream: NotificationFirebaseApi.getAllNotifications(),
            initialData: const [],
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => ShimmerWidget.circular(
                        width: double.infinity,
                        height: 70,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 4,
                      );
                    },
                  );
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          NotificationModel notification =
                              snapshot.data![index];

                          return Dismissible(
                            background: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.red,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ],
                                )),
                            onDismissed: (direction) {
                              try {
                                FirebaseFirestore.instance
                                    .collection('notifications')
                                    .doc(notification.notificationID)
                                    .delete();
                              } catch (e) {
                                AppUtils.appLog(
                                    'Notification: Error in dismissible: $e ');
                              }
                            },
                            key: UniqueKey(),
                            child: NotificationCard(
                                body: notification.notificationMessage!,
                                time: AppUtils.getTimeFromDateTime(
                                    datetime:
                                        notification.notificationTimeStamp!),
                                title: notification.notificationTitle!),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 4,
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CustomText(
                          label: 'No Notifications',
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Page404();
                  } else {
                    return const EmptyNotifications();
                  }

                default:
              }

              if (snapshot.hasData) {
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    NotificationModel notification = snapshot.data![index];

                    return NotificationCard(
                        body: notification.notificationMessage!,
                        time: AppUtils.getTimeFromDateTime(
                            datetime: notification.notificationTimeStamp!),
                        title: notification.notificationTitle!);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 4,
                    );
                  },
                );
              } else {
                return const EmptyNotifications();
              }
            }));
  }

  Future<dynamic> showNotificationContent(
      BuildContext context, MediaQueryData data) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const CustomText(label: "Notification Title", fontSize: 18),
            content: Container(
              height: data.size.height / 2,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                children: const [],
              ),
            ),
          );
        });
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    required this.body,
    required this.time,
    required this.title,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final void Function()? onTap;
  final String time;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      leading: CircleAvatar(
          backgroundColor: ColorConstants.primaryColor,
          // foregroundColor: ColorConstants.someRockGreen,
          child: const Icon(Icons.notifications, color: Colors.white)),
      trailing: CustomText(
        label: time,
        fontSize: 10,
      ),
      children: [
        CustomText(
          label: body,
        )
      ],
      childrenPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      backgroundColor: ColorConstants.primaryColor.withOpacity(0.15),
      title: CustomText(
        label: title,
        fontSize: 13,
      ),
    );
  }
}

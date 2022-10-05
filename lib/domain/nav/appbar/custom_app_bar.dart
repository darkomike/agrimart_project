import 'package:block_agri_mart/domain/domain.dart';
import 'package:block_agri_mart/domain/products/components/add_product.dart';
import 'package:block_agri_mart/firebase/firebase_notification_api.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../app/provider/app_provider.dart';
import '../../../app/constants/color_constant.dart';
import '../../../app/utils/utils.dart';
import '../../../app/widgets/custom_shader_mask.dart';
import '../../../app/widgets/custom_text.dart';
import 'components/app_bar_icon_button.dart';
import 'components/profile_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key,
      required this.showCart,
      required this.showProfilePic,
      this.showDrawer,
      this.bottom,
      required this.title,
      required this.showAddProduct,
      required this.isDashboard,
      required this.showNotification,
      required this.onTransparentBackground})
      : super(key: key);

  final bool showCart;
  final bool showNotification;
  final bool showAddProduct;
  final bool showProfilePic;
  final bool? showDrawer;
  final bool isDashboard;
  final bool onTransparentBackground;
  final PreferredSize? bottom;

  final String title;

  @override
  Size get preferredSize =>
      Size.fromHeight(title.toLowerCase() == ('transactions') ||
              title.toLowerCase() == ('requests') ||
              // title.toLowerCase() == ('agrimart') ||
              title.toLowerCase() == ('product catalogs') ||
              title.toLowerCase() == ('search products')
          ? 110.0
          : 60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leadingWidth: 0,
        // centerTitle: true,
        elevation: 0.0,
        leading: const SizedBox(
          height: 0,
          width: 0,
        ),
        bottom: bottom,
        backgroundColor: onTransparentBackground
            ? Colors.transparent
            : Theme.of(context).backgroundColor,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              showNotification
                  ? StreamBuilder<int>(
                      stream:
                          NotificationFirebaseApi.getAllNotificationsLength(),
                      builder: (context, snapshot) {
                        return AppBarIconButton(
                          showBgColor: onTransparentBackground,
                          buttonMarginT: 5,
                          onTap: () {
                            AppUtils.navigatePush(
                                context: context,
                                destination: const NotificationScreen());
                          },
                          icon: const Icon(
                            Icons.notifications_active_outlined,
                          ),
                          showCount: true,
                          count: snapshot.data ?? 0,
                        );
                      })
                  : const SizedBox(),
              showCart
                  ? context.watch<AppStateManager>().userType.toLowerCase() ==
                          "buyer"
                      ? AppBarIconButton(
                          showBgColor: onTransparentBackground,
                          onTap: () {
                            AppUtils.navigatePush(
                                context: context,
                                destination: const CartScreen());
                          },
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                          ),
                          showCount: true,
                          buttonMarginT: 5,
                          buttonMarginL: 7,
                          count: context
                              .watch<CartStateManager>()
                              .productsInCart
                              .length,
                        )
                      : const SizedBox()
                  : const SizedBox(
                      width: 10,
                    ),
              showAddProduct
                  ? context.watch<AppStateManager>().userType.toLowerCase() ==
                          'seller'
                      ? AppBarIconButton(
                          showBgColor: onTransparentBackground,
                          onTap: () {
                            AppUtils.navigatePush(
                                context: context,
                                destination: const AddProductScreen());
                          },
                          icon: const Icon(
                            Icons.add_business_outlined,
                          ),
                          showCount: false,
                          buttonMarginT: 5,
                          count: 0,
                        )
                      : const SizedBox()
                  : const SizedBox(),
              showProfilePic
                  ? Container(
                      margin: const EdgeInsets.only(
                        right: 5,
                      ),
                      child: ProfileIcon(
                        tag: title,
                      ),
                    )
                  : const SizedBox(),
            ],
          )
        ],
        title: title.toLowerCase() == 'agrimart'
            ? Row(
                children: [
                  CustomShaderMask(
                    blendMode: BlendMode.srcIn,
                    gradient: LinearGradient(colors: [
                      ColorConstants.primaryColor,
                      ColorConstants.secondaryColor,
                    ]),
                    child: CustomText(
                      label: title,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  LottieBuilder.asset(
                    AppUtils.getLottie(name: '4'),
                    width: 20,
                    height: 20,
                  ),
                ],
              )
            : CustomShaderMask(
                blendMode: BlendMode.srcIn,
                gradient: LinearGradient(
                    colors: [ColorConstants.primaryColor, Colors.blue]),
                child: CustomText(
                  label: title,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ));
  }
}

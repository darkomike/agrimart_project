import 'package:block_agri_mart/app/constants/text.dart';
import 'package:block_agri_mart/app/widgets/custom_shader_mask.dart';
import 'package:flutter/material.dart';
import '../../../app/constants/color_constant.dart';
import '../../../app/utils/utils.dart';
import '../../../app/widgets/custom_text.dart';
import '../../domain.dart';

class OnBoardScreenFour extends StatefulWidget {
  const OnBoardScreenFour({
    Key? key,
  }) : super(key: key);

  @override
  State<OnBoardScreenFour> createState() => _OnBoardScreenFourState();
}

class _OnBoardScreenFourState extends State<OnBoardScreenFour> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor.withOpacity(1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(
            flex: 2,
          ),
          LottieWidget(lottiePath: AppUtils.getLottie(name: "connect_wallet")),
          const Spacer(
            flex: 1,
          ),
          const CustomText(
              label: "Login into AgriMart",
              fontFamily: 'Quicksand',
              fontSize: 24,
              fontWeight: FontWeight.w500),
          const SizedBox(
            height: 10,
          ),
          CustomShaderMask(
            blendMode: BlendMode.srcIn,
            gradient: LinearGradient(
                tileMode: TileMode.mirror,
                colors: [Colors.red.shade900, Colors.blue]),
            child: const CustomText(
                label: "You need a metamask wallet to use AgriMart",
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600),
          ),
          spaceH1,
          buildTCAgreement(context),
          const Spacer(
            flex: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MaterialButton(
              onPressed: _agreed
                  ? () {
                      try {
                        AppUtils.navigatePushReplace(
                            context: context, destination: NewLogin());
                      } catch (e) {
                        print("Connect Wallet: $e");
                      }
                    }
                  : null,
              child: const CustomText(
                label: "GET CONNECTED",
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w800,
              ),
              height: 50,
              color: ColorConstants.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              minWidth: AppUtils.appMQ(context: context, flag: 'w') - 30,
              elevation: 2,
            ),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  Row buildTCAgreement(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: _agreed,
            onChanged: (value) {
              setState(() {
                _agreed = value!;
              });
            }),
        Expanded(
          child: Row(children: [
            const CustomText(
              label: 'Please read the ',
              fontSize: 12,
            ),
            InkWell(
              onTap: () {
                AppUtils.showCustomDialog(
                    context: context, content: readTermsOfService());
              },
              child: CustomText(
                label: 'Term of Service',
                color: ColorConstants.secondaryColor,
                fontWeight: bold,
                fontSize: 12,
              ),
            ),
            const CustomText(
              label: ' and ',
              fontSize: 12,
            ),
            InkWell(
              onTap: () {
                AppUtils.showCustomDialog(
                    context: context, content: readPrivacyPolicy());
              },
              child: CustomText(
                label: 'Privacy Policy',
                color: ColorConstants.secondaryColor,
                fontWeight: bold,
                fontSize: 12,
              ),
            ),
          ]),
        )
      ],
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

class CommonButton extends StatelessWidget {
  const CommonButton(
      {Key? key,
      required this.bgColor,
      required this.label,
      this.height,
      this.width,
      this.onTap})
      : super(key: key);

  final VoidCallback? onTap;
  final String label;
  final double? height;
  final double? width;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height ?? 45,
      minWidth: width,
      color: bgColor,
      onPressed: onTap,
      shape: shape,
      child: CustomText(
        label: label,
        color: Colors.white,
      ),
    );
  }
}

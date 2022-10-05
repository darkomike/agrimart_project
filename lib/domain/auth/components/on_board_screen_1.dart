import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/app/widgets/custom_text.dart';
import 'package:block_agri_mart/domain/auth/auth.dart';
import 'package:flutter/material.dart';

class OnBoardScreenOne extends StatelessWidget {
  const OnBoardScreenOne({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        LottieWidget(lottiePath: AppUtils.getLottie(name: "4")),
        const CustomText(
            label: "Welcome to Agrimart",
            fontSize: 20,
            fontWeight: FontWeight.w600),
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: CustomText(
              label:
                  "AgriMart is the world's largest\ndigital Argo-product marketplace.",
              fontWeight: FontWeight.w700,
              fontSize: 15,
              fontFamily: 'Quicksand'),
        ),
      ]),
    );
  }
}

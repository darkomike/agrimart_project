

import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:block_agri_mart/domain/auth/auth.dart';
import 'package:flutter/material.dart';

class OnBoardScreenTwo extends StatelessWidget {
  const OnBoardScreenTwo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        LottieWidget(lottiePath:  AppUtils.getLottie(name: "3") ), 
        Text(
          "Connect with Customers",
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }
}


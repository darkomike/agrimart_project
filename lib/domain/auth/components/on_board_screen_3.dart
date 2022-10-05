import 'package:block_agri_mart/app/utils/utils.dart';
import 'package:flutter/material.dart';
import '../auth.dart';

class OnBoardScreenThree extends StatelessWidget {
  const OnBoardScreenThree({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        LottieWidget(lottiePath: AppUtils.getLottie(name: "1")),
        Text(
          "Track and trace transactions", 
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }
}

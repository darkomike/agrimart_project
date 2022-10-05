import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../provider/app_provider.dart';
import '../constants/color_constant.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular(
      {Key? key, this.width = double.infinity, required this.height})
      : shapeBorder = const RoundedRectangleBorder(),
        super(key: key);

  const ShimmerWidget.circular(
      {Key? key,
      required this.width,
      required this.height,
      this.shapeBorder = const CircleBorder()})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      child: Container(
        margin: const  EdgeInsets.all(10),
        height: height,
        width: width,
        decoration: ShapeDecoration(
          color: Colors.blueGrey,
          shape: shapeBorder),
      ),
      baseColor: ColorConstants.primaryColor.withOpacity(0.4),
      highlightColor: context.watch<AppStateManager>().darkModeOn
          ? Colors.white.withOpacity(0.5)
          : Colors.black.withOpacity(0.5));
}

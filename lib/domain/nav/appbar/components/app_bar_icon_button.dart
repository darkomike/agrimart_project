import 'package:block_agri_mart/app/widgets/custom_shader_mask.dart';
import 'package:flutter/material.dart';

import '../../../../app/constants/color_constant.dart';

class AppBarIconButton extends StatelessWidget {
  const AppBarIconButton({
    this.buttonMarginT,
    this.buttonMarginL,
    
    this.buttonMarginB,
    required this.count,
    required this.onTap,

    required this.showBgColor,required this.icon,
    required this.showCount,
    Key? key,
  }) : super(key: key);

  final void Function()? onTap;


  final int? count;
  final bool showCount;
  final bool showBgColor;
  final Icon icon;
  final double? buttonMarginL;
  final double? buttonMarginB;
  final double? buttonMarginT;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: EdgeInsets.only(
          right: 5,
          bottom: buttonMarginB ?? 0,
          top: buttonMarginT ?? 0,
          left: buttonMarginL ?? 0),
      decoration: BoxDecoration(
          color: showBgColor
              ? Theme.of(context).backgroundColor.withOpacity(0.65)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(5)),
      height: 40,
      child: Stack(
        children: [
          CustomShaderMask(
            blendMode: BlendMode.srcIn,
                    gradient: LinearGradient(colors: [ColorConstants.primaryColor, Colors.blue]),
            child: IconButton(
              onPressed: onTap,
             icon:icon,
            ),
          ),
          showCount
              ? Positioned(
                  left: 2,
                  top: 2,
                  child: Container(
                      // height: 15,
                      //   width: 15,
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      decoration: BoxDecoration(
                          color: ColorConstants.primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "$count",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      )),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../app/constants/color_constant.dart';

class TabButton extends StatelessWidget {
  const TabButton({
    Key? key,
    required this.currentIndex,
    required this.index,
    required this.shouldExpand,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final int index;
  final int currentIndex;
  final void Function()? onPressed;
  final String label;
  final bool shouldExpand;
  @override
  Widget build(BuildContext context) {
    return shouldExpand
        ? Expanded(
            flex: 1,
            child: MaterialButton(
              elevation: 0,
              animationDuration: const Duration(milliseconds: 1500),
              height: 40,
              color: index == currentIndex
                  ? ColorConstants.primaryColor
                  : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                label,
                style: TextStyle(
                    color: index == currentIndex ? Colors.white : Colors.black),
              ),
              onPressed: onPressed,
            ))
        : Flexible(
            flex: 1,
            child: MaterialButton(
              animationDuration: const Duration(milliseconds: 1500),
              height: 40,
              color: index == currentIndex
                  ? ColorConstants.primaryColor
                  : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                label,
                style: TextStyle(
                    color: index == currentIndex ? Colors.white : Colors.black),
              ),
              onPressed: onPressed,
            ));
  }
}

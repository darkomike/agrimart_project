import 'package:flutter/material.dart';

import '../../../../app/constants/color_constant.dart';

class CustomBottomNavigationItem extends StatelessWidget {
  const CustomBottomNavigationItem({
    Key? key,
    required this.onTap,
    required this.isSelected, required this.currentIndex,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final void Function()? onTap;
  final int isSelected;
  final int currentIndex;
  final String label;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: isSelected ==
                          currentIndex
                      ? 18
                      : 16,
                  color: isSelected ==
                         currentIndex
                      ? ColorConstants.primaryColor
                      : Theme.of(context).iconTheme.color!.withOpacity(0.9)),
              Text(label,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontSize: 10,
                          fontWeight: currentIndex ==
                              isSelected
                          ? FontWeight.w500: FontWeight.normal
                          ,
                      color: currentIndex ==
                              isSelected
                          ? ColorConstants.primaryColor
                          : Theme.of(context)
                              .iconTheme
                              .color!
                              .withOpacity(0.9)))
            ],
          ),
        ),
      ),
    );
  }
}

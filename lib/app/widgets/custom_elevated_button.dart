import 'package:flutter/material.dart';

class CommonButton1 extends StatelessWidget {
  const CommonButton1(
      {Key? key,
      required this.title,
      this.buttonOutlineColor,
      this.titleStyle,
      this.borderRadius,
      this.backgroundColor,
      this.alignment,
      this.elevation,
      this.overlayColor,
      this.onPressed})
      : super(key: key);

  final String title;
  final double? elevation;
  final double? borderRadius;
  final Color? buttonOutlineColor;
  final TextStyle? titleStyle;  
  final AlignmentGeometry? alignment;
  final Function()? onPressed;
  final MaterialStateProperty<Color?>? backgroundColor;
  final MaterialStateProperty<Color?>? overlayColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

        style: ButtonStyle(
            elevation: MaterialStateProperty.all(elevation ?? 0),
            side: MaterialStateProperty.all(
              BorderSide(color: buttonOutlineColor ?? Colors.green.shade100),
            ),
            backgroundColor: backgroundColor,
            overlayColor: overlayColor,
            animationDuration: const Duration(milliseconds: 500),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 5)))),
        onPressed: onPressed,
        child: Text(
          title,
          style: titleStyle ?? Theme.of(context).textTheme.headline6,
        ));
  }
}

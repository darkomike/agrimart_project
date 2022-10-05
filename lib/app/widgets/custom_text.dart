import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomText extends StatelessWidget {
  final String label;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? color;
  const CustomText({
    required this.label,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.fontFamily,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      
      label,
      softWrap: true,
      style: Theme.of(context).textTheme.headline3!.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            
            fontStyle: fontStyle,
          ),
    );
  }
}

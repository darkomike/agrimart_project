import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/color_constant.dart';


class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.disabledBorder,
    this.autofocus,
    this.minLines,
    this.maxLines,
    this.cursorColor,
    this.focusedBorder,
    this.keyboardAppearance,
    this.keyboardType,
    this.suffix,
    this.border, this.helperText,
    this.labelStyle,
    this.enabledBoarder,
    this.focusColor,
    this.onChanged,this.inputFormatters,
    this.validator, this.initialValue,
    this.hintText,
    this.label,
  }) : super(key: key);

  final TextEditingController controller;
  final Widget? label;

  final String? hintText;
  final String? initialValue;
  final String? helperText;
  final int? maxLines;
  final int? minLines;

  final String? Function(String?)? validator;
  final bool? autofocus;
  final Color? cursorColor;
  final Color? focusColor;
  
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final Brightness? keyboardAppearance;
  final Widget? suffix;
  final TextStyle? labelStyle;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? border;
  final InputBorder? enabledBoarder;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      enableInteractiveSelection: true,
      enableIMEPersonalizedLearning: true,
      autocorrect: true,
      initialValue: initialValue,
      autofocus: autofocus ?? false,
      cursorColor: cursorColor ?? ColorConstants.primaryColor,
      keyboardType: keyboardType,
      onChanged: onChanged,
      keyboardAppearance: keyboardAppearance,
      minLines: minLines,
      style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 14),
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          labelStyle: labelStyle,
          focusedBorder: focusedBorder,
          disabledBorder: disabledBorder,
          enabledBorder: enabledBoarder,
          fillColor: ColorConstants.primaryColor,
          focusColor: ColorConstants.primaryColor,
          
          label: label,
          hintText: hintText,
          helperText: helperText, 
          helperStyle:  TextStyle(color: ColorConstants.primaryColor),
          // helperStyle: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 10),
          iconColor: Theme.of(context).iconTheme.color,
          hintStyle:
              Theme.of(context).textTheme.headline3!.copyWith(fontSize: 12),
          suffix: suffix,
          border: border),
    );
  }
}

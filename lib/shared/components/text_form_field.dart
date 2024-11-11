import 'package:church/shared/style/color_manager.dart';
import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final String label;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final Function(String?) validator;
  final bool readOnly;

  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    required this.controller,
    required this.validator,
    this.prefixIcon,
    required this.label,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      textAlign: TextAlign.right,
      // Apply text alignment for the input text
      decoration: InputDecoration(
        labelText: label,
        labelStyle: FontForm.TextStyle30bold.copyWith(
            backgroundColor: ColorManager.colorWhit
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,  // هذا السطر يثبت الـ label فوق الحقل
        isDense: false,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        focusedBorder: focusedBorder ?? OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: enabledBorder ?? OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        hintStyle: hintStyle,
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: backgroundColor ?? Colors.white,
        filled: true,
      ),
      obscureText: isObscureText ?? false,
      controller: controller,
      validator: (value) {
        return validator(value);
      },
    );
  }
}

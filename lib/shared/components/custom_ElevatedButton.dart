import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';

import '../style/color_manager.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final void Function()? OnPressed;
  final double width;
  final double height;
  final Color colorBorder;
  final Color colorButton;
  final Color colorText;

  CustomElevatedButton({
    super.key,
    required this.text,
    required this.OnPressed,
    this.height = 62,
    this.width = 327,
    this.colorBorder = ColorManager.colorGray,
    this.colorButton = ColorManager.colorGray,
    this.colorText = ColorManager.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: OnPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: colorButton,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 4,
                    color: colorBorder,
                  ),
                  borderRadius: BorderRadius.circular(18),
                )),
            child: Text(text,
                style: FontForm.TextStyle40bold.copyWith(color: colorText)),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../style/color_manager.dart';

class CustomElevatedButton extends StatelessWidget {
  String text;
  void Function()? OnPressed;
  double width;
  double height;
  Color colorBorder;
  Color colorButton;
  Color colorText;

  CustomElevatedButton({
    required this.text,
    required this.OnPressed,
    this.height = 62,
    this.width = 327,
    this.colorBorder = ColorManager.scondeColor,
    this.colorButton = ColorManager.scondeColor,
    this.colorText = ColorManager.colorWhit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              style: TextStyle(
                color: colorText,
                fontSize: 20,
              )),
        ),
      ),
    );
  }
}

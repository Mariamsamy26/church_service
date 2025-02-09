import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';

import '../style/color_manager.dart';

class CustomIconBottom extends StatelessWidget {
  String iconPath;
  String text;
  double radius;
  double width;
  double height;
  double heightIcon;
  double widthIcon;
  void Function()? OnPressed;

  CustomIconBottom({
    required this.text,
    required this.OnPressed,
    this.radius = 5,
    required this.width,
    required this.heightIcon,
    required this.widthIcon,
    required this.height,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: OnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.colorGray,
            elevation: 0.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(0.1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                ),
                child: Text(text, style: FontForm.TextStyle50bold),
              ),
            ],
          )),
    );
  }
}

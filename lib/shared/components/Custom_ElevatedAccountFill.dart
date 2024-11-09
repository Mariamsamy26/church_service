import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';
import '../style/color_manager.dart';

class CustomElevatedAccountFill extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final double width;
  final double height;
  final IconData icon;
  final IconData icon2;
  final Color dividerColor;

  const CustomElevatedAccountFill({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.height = 80,
    this.width = 400,
    this.icon2 = Icons.arrow_forward_ios_outlined,
    this.dividerColor = ColorManager.colorGray,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        child: Column(
          children: [
            SizedBox(height: 15),
            Row(
              children: [
                Icon(icon, color: ColorManager.colorGrayBlue ,size: 50),
                Text(
                  text,
                  style: FontForm.TextStyle30bold,
                ),
                Spacer(),
                Icon(icon2, color: ColorManager.colorGrayBlue),
              ],
            ),
            Divider(
              color: dividerColor,
              height: 4,
            )
          ],
        ),
      ),
    );
  }
}
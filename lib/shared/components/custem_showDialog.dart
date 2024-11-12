import 'package:flutter/material.dart';
import 'custom_ElevatedAccountFill.dart';

class CustomShowDialog extends StatelessWidget {
  final String title;
  final String firstText;
  final String secondText;
  final IconData frisIcon;
  final IconData secIcon;
  final VoidCallback? onFirstPressed;
  final VoidCallback? onSecondPressed;
  final VoidCallback? onCancelPressed;

  const CustomShowDialog({
    Key? key,
    required this.title,
    required this.firstText,
    required this.secondText,
    required this.frisIcon,
    required this.secIcon,
    required this.onFirstPressed,
    required this.onSecondPressed,
    this.onCancelPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedAccountFill(
            icon: frisIcon,
            text: firstText,
            onPressed: onFirstPressed ??
                () {
                  Navigator.of(context).pop('G');
                },
            dividerColor: Colors.transparent,
          ),
          SizedBox(height: 5),
          CustomElevatedAccountFill(
            icon: secIcon,
            text: secondText,
            onPressed: onSecondPressed ??
                () {
                  Navigator.of(context).pop('B');
                },
            dividerColor: Colors.transparent,
          ),
          Row(
            children: [
              Spacer(),
              InkWell(
                onTap: onCancelPressed ??
                    () {
                      Navigator.of(context).pop();
                    },
                child: Text(
                  'إلغاء',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'Custom_ElevatedAccountFill.dart';

class CustemshowDialog extends StatelessWidget {
  const CustemshowDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'gender . . . ',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 25),
          CustomElevatedAccountFill(
            icon: Icons.girl_outlined,
            text: 'بنت',
            onPressed: () {
              Navigator.of(context).pop('G');
            },
            dividerColor: Colors.transparent,
          ),
          SizedBox(height: 5),
          CustomElevatedAccountFill(
            icon: Icons.boy_outlined,
            text: 'ولد',
            onPressed: () {
              Navigator.of(context).pop('B');
            },
            dividerColor: Colors.transparent,
          ),
          Row(
            children: [
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'الغاء',
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

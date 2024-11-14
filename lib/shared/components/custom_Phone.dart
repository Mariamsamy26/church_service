import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../style/color_manager.dart';
import '../style/fontForm.dart';

class customPhone extends StatelessWidget {
  final String phone;

  const customPhone({Key? key, required this.phone}) : super(key: key);


  Future<void> requestPhonePermission() async {
    PermissionStatus status = await Permission.phone.request();
    if (status.isGranted) {
      makePhoneCall(phone.toString());
    } else {
      print("Permission denied.");
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    requestPhonePermission();
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => makePhoneCall(phone.toString()),
      child: Text(
        phone.toString(),
        style: FontForm.TextStyle20bold.copyWith(
          color: ColorManager.liteblueGray,
          decoration: TextDecoration.underline ,
          decorationColor: ColorManager.liteblueGray,
        ),
      ),
    );
  }
}

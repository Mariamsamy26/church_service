import 'package:church/shared/style/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../style/fontForm.dart';

class CustomCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final int phone;
  final String id;
  final IconData icon;
  final VoidCallback iconFunction;

  const CustomCard({
    super.key,
    required this.profileImage,
    required this.name,
    required this.phone,
    required this.id,
    required this.icon,
    required this.iconFunction,
  });

  // دالة لفتح تطبيق الهاتف وإجراء مكالمة
  void makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.asset(
            profileImage,
            width: 70,
            height: 70,
          ),
          title: Text(
            name,
            style: FontForm.TextStyle30bold,
          ),
          subtitle: GestureDetector(
            onTap: () => makePhoneCall(phone.toString()),
            child: Text(
              phone.toString(),
              style: FontForm.TextStyle20bold.copyWith(
                color: ColorManager.liteblueGray,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: iconFunction,
            icon: Icon(
              icon,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

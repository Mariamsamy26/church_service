import 'package:flutter/material.dart';

import '../style/fontForm.dart';

class CustomCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String birthDate;
  final String id;
  final IconData icon;
  final VoidCallback iconFunction;

  const CustomCard({
    super.key,
    required this.profileImage,
    required this.name,
    required this.birthDate,
    required this.id,
    required this.icon,
    required this.iconFunction,
  });

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
            name ,
            style: FontForm.TextStyle30bold,
          ),
          subtitle: Text(
            birthDate,
            style: FontForm.TextStyle20bold,
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
import 'package:flutter/material.dart';
import '../style/fontForm.dart';
import 'custom_Phone.dart';

class CustomCard extends StatelessWidget {
  final String? profileImage;
  final String name;
  final String? phone;
  final int numCH;
  final String id;
  final IconData icon;
  final VoidCallback iconFunction;
  final bool showImage;
  final String? subtitleData;

  const CustomCard({
    super.key,
    this.numCH = 0,
    this.profileImage,
    required this.name,
    this.phone,
    required this.id,
    required this.icon,
    required this.iconFunction,
    this.showImage = true,
    this.subtitleData,
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
          leading: showImage && profileImage != null && profileImage!.isNotEmpty
              ? Image.network(
                  profileImage!,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 50);
                  },
                )
              : CircleAvatar(
                  radius: 25,
                  child: Text(
                    numCH > 0 ? "$numCH" : "-",
                    style: FontForm.TextStyle30bold,
                  ),
                ),
          title: Text(
            name,
            style: FontForm.TextStyle30bold,
          ),
          subtitle: subtitleData != null
              ? Text(subtitleData!, style: FontForm.TextStyle20bold)
              : (phone != null && phone!.isNotEmpty
                  ? customPhone(phone: phone!)
                  : const SizedBox()),
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

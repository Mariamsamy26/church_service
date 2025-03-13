import 'package:flutter/material.dart';
import '../style/color_manager.dart';
import '../style/fontForm.dart';

class AppbarCom extends StatelessWidget implements PreferredSizeWidget {
  final String textAPP;
  final IconData? iconApp;
  final VoidCallback? onPressedApp;

  const AppbarCom({
    Key? key,
    required this.textAPP,
    this.iconApp,
    this.onPressedApp,
  }) : super(key: key);

  /*
  SearchTextField(
  controller: searchController,
  onClear: () {
    context.read<NewsLogic>().getNewsSearch(text: '');
  },
  hintText: '... اسم المخدوم ',
),

   */
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorManager.primaryColor,
      centerTitle: true,
      title: Text(
        textAPP,
        style: FontForm.TextStyle50bold.copyWith(
          color: ColorManager.colorWhit,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onPressedApp,
          icon: Icon(
            iconApp,
            color: ColorManager.colorWhit,
            size: 50,
          ),
        ),
      ],
    );
  }

  // Implementing PreferredSizeWidget requires defining the preferredSize
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

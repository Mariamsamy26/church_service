import 'package:flutter/material.dart';

import '../style/color_manager.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function onClear;
  final String hintText;

  const SearchTextField({
    Key? key,
    required this.controller,
    required this.onClear,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              controller.clear();
              onClear();
            },
            icon: Icon(Icons.highlight_remove_outlined),
          ),
          fillColor: ColorManager.primaryColor,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.primaryColor,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(12),
          hintText: hintText,
        ),
      ),
    );
  }
}

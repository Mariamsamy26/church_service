import 'package:flutter/material.dart';
import 'package:church/shared/style/color_manager.dart';

class CustomDropdownButtonFormField extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final String labelText;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;
  final double width;

  const CustomDropdownButtonFormField({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.labelText,
    required this.onChanged,
    this.validator,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            labelText: labelText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            fillColor: ColorManager.colorWhit,
            filled: true,
          ),
          validator: validator,
        ),
      ),
    );
  }
}

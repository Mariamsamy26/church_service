import 'package:church/shared/components/custom_ElevatedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/components/custom_DropdownButtonFormField.dart';
import '../../shared/dataApp.dart';
import '../../shared/style/color_manager.dart';

class FiltersBar extends StatefulWidget {
  final ValueChanged<String?> onMonthChanged;

  const FiltersBar({super.key, required this.onMonthChanged});

  @override
  State<FiltersBar> createState() => _FiltersBarState();
}

class _FiltersBarState extends State<FiltersBar> {
  String? selectedMonths = '0';
  String selectedButton = "";

  @override
  void initState() {
    super.initState();
    selectedMonths = "كل الاشهر";
    selectedButton = "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: MediaQuery.of(context).size.height * 0.008),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomDropdownButtonFormField(
              width: MediaQuery.of(context).size.width * 0.30,
              selectedValue: selectedMonths,
              items: DataApp.months,
              labelText: "شهر عيد الميلاد",
              onChanged: (String? value) {
                setState(() {
                  selectedMonths = value;
                  selectedButton = "";
                });
                widget.onMonthChanged(value);
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            CustomElevatedButton(
              colorBorder: selectedButton == "الحضور"
                  ? ColorManager.colorWhit
                  : ColorManager.primaryColor,
              colorButton: selectedButton == "الحضور"
                  ? ColorManager.primaryColor
                  : ColorManager.colorWhit,
              colorText: selectedButton == "الحضور"
                  ? ColorManager.colorWhit
                  : ColorManager.primaryColor,
              width: MediaQuery.of(context).size.height * 0.19,
              text: 'الحضور',
              OnPressed: () {
                setState(() {
                  widget.onMonthChanged("13");
                  selectedButton = "الحضور";
                });
              },
            ),
            CustomElevatedButton(
              colorBorder: selectedButton == "الافتقاد"
                  ? ColorManager.colorWhit
                  : ColorManager.primaryColor,
              colorButton: selectedButton == "الافتقاد"
                  ? ColorManager.primaryColor
                  : ColorManager.colorWhit,
              colorText: selectedButton == "الافتقاد"
                  ? ColorManager.colorWhit
                  : ColorManager.primaryColor,
              width: MediaQuery.of(context).size.height * 0.19,
              text: 'الافتقاد',
              OnPressed: () {
                setState(() {
                  widget.onMonthChanged("14");
                  selectedButton = "الافتقاد";
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.09),
          ],
        ),
      ),
    );
  }
}

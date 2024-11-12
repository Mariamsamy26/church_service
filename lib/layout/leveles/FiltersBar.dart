import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/components/custom_DropdownButtonFormField.dart';
import '../../shared/dataApp.dart';

class FiltersBar extends StatefulWidget {
  @override
  State<FiltersBar> createState() => _FiltersBarState();
}

class _FiltersBarState extends State<FiltersBar> {
  String? selectedMonths;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: MediaQuery.of(context).size.height * 0.008),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomDropdownButtonFormField(
              width: MediaQuery.of(context).size.width * 0.35,
              selectedValue: selectedMonths,
              items: DataApp.months,
              labelText: "شهر عيد الميلاد",
              onChanged: (String? value) {},
            ),

            SizedBox(width: 10), // Add some spacing between the dropdowns
            // Add some spacing between the dropdowns
            // Add more CustomDropdownButtonFormField widgets as needed
          ],
        ),
      ),
    );
  }
}

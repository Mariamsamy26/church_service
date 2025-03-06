import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime) onDateChanged;

  const CustomDatePicker({Key? key, required this.onDateChanged})
      : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  int selectedDay = DateTime.now().day;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  List<int> days = List.generate(31, (index) => index + 1);
  List<int> months = List.generate(12, (index) => index + 1);
  List<int> years = List.generate(50, (index) => DateTime.now().year - index);

  void _updateDate() {
    final selectedDate = DateTime(
        selectedYear ?? DateTime.now().year,
        selectedMonth ?? DateTime.now().month,
        selectedDay ?? DateTime.now().day);
    widget.onDateChanged(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: buildDropdown("اليوم", days, selectedDay, (value) {
            setState(() {
              selectedDay = value!;
              _updateDate();
            });
          }),
        ),
        const SizedBox(width: 5),
        Flexible(
          flex: 3,
          child: buildDropdown("الشهر", months, selectedMonth, (value) {
            setState(() {
              selectedMonth = value!;
              _updateDate();
            });
          }),
        ),
        const SizedBox(width: 5),
        Flexible(
          flex: 3,
          child: buildDropdown("السنة", years, selectedYear, (value) {
            setState(() {
              selectedYear = value!;
              _updateDate();
            });
          }),
        ),
      ],
    );
  }

  Widget buildDropdown(String label, List<int> items, int selectedValue,
      ValueChanged<int?> onChanged) {
    return DropdownButtonFormField<int>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items: items.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

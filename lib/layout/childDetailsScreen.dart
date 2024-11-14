import 'package:church/shared/components/appBar.dart';
import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/child.dart';
import '../shared/components/custom_ElevatedButton.dart';
import '../shared/components/custom_Phone.dart';
import '../shared/components/text_form_field.dart';
import '../shared/style/color_manager.dart';

class ChildDetailsScreen extends StatefulWidget {
  final ChildData childData;

  ChildDetailsScreen({required this.childData});

  @override
  _ChildDetailsScreenState createState() => _ChildDetailsScreenState();
}

class _ChildDetailsScreenState extends State<ChildDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController bDayController;
  late TextEditingController notesController;
  late TextEditingController phoneController;
  DateTime selectedDate = DateTime.now();
  Color defaultColor = ColorManager.redSoft;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.childData.name);
    bDayController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(widget.childData.bDay!));
    notesController = TextEditingController(text: widget.childData.notes);
    phoneController = TextEditingController(text: widget.childData.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    bDayController.dispose();
    notesController.dispose();
    phoneController.dispose();
    super.dispose();
  }

// Function to check if a specific date is a Friday
  bool isFriday(DateTime date) {
    return date.weekday == DateTime.friday;
  }

  @override
  Widget build(BuildContext context) {
    final Widget betwwen =
        SizedBox(height: MediaQuery.of(context).size.height * 0.03);
    return Scaffold(
      appBar: AppbarCom(
        textAPP: "تفاصيل ",
        iconApp: Icons.delete_forever,
        onPressedApp: () {},
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 5, vertical: MediaQuery.of(context).size.height * 0.05),
        child: ListView(
          children: [
            //img
            ClipOval(
              child: Image.asset(
                widget.childData.imgUrl!,
                width: 150, // Adjust size as needed
                height: 150,
              ),
            ),
            betwwen,

            //name
            AppTextFormField(
              controller: nameController,
              hintText: "الاسم",
              validator: (text) {
                if (text?.isEmpty ?? true) {
                  return "اكتب اسم المخدوم";
                }
                return null;
              },
              label: 'الاسم',
            ),
            betwwen,

            //phone
            AppTextFormField(
              controller: phoneController,
              suffixIcon: IconButton(
                onPressed: () {
                  customPhone(
                    phone: widget.childData.phone,
                  ).makePhoneCall(widget.childData.phone);
                },
                icon: Icon(
                  Icons.phone,
                  color: ColorManager.liteblueGray,
                ),
              ),
              hintText: "الرقم الجديد",
              validator: (text) {
                if (text?.isEmpty ?? true) {
                  return "اكتب الرقم الجديد";
                }
                return null;
              },
              label: 'الرقم الهاتف ',
            ),
            betwwen,

            // Editable Birthdate
            AppTextFormField(
              controller: bDayController,
              suffixIcon: IconButton(
                onPressed: () async {
                  DateTime? chosenDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    initialDate: selectedDate,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: ColorManager.liteblueGray,
                            onSurface: ColorManager.scondeColor,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: ColorManager.liteblueGray,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (chosenDate != null) {
                    selectedDate = chosenDate;
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(chosenDate);
                    bDayController.text = formattedDate;
                    setState(() {});
                  }
                },
                icon: Icon(
                  Icons.calendar_month_sharp,
                  color: ColorManager.scondeColor,
                ),
              ),
              hintText: "تاريخ الميلاد",
              validator: (text) {
                if (text?.isEmpty ?? true) {
                  return "اكتب تاريخ الميلاد";
                }
                return null;
              },
              label: 'تاريخ الميلاد',
              readOnly: true,
            ),
            betwwen,

            // Editable Notes
            AppTextFormField(
              controller: notesController,
              hintText: "الملاحظات",
              validator: (text) {
                if (text?.isEmpty ?? true) {
                  return "اكتب ملاحظات";
                }
                return null;
              },
              label: 'الملاحظات',
            ),
            betwwen,

            // Attendance Dates
            Text(
              "الغياب",
              style: FontForm.TextStyle30bold.copyWith(
                  backgroundColor: ColorManager.colorWhit),
            ),
            TableCalendar(
              firstDay: DateTime.utc(2023, 11, 01),
              lastDay: DateTime.now(),
              focusedDay: DateTime.utc(2024, 11, 01),
              selectedDayPredicate: (day) {
                return day.weekday == DateTime.friday;
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: ColorManager.redSoft,
                  // Highlight Fridays with red by default
                  shape: BoxShape.rectangle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                // Handle day selection here if needed
              },
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, events) {
                  Color color = defaultColor; // Red as default for Fridays

                  // Check if the date is in attendance list (att)
                  bool isInAttendance = widget.childData.att.any(
                      (attendanceDate) =>
                          attendanceDate.year == date.year &&
                          attendanceDate.month == date.month &&
                          attendanceDate.day == date.day);

                  // Apply green if date is in attendance list, else keep it red for Fridays
                  if (isInAttendance) {
                    color = ColorManager.greenSoft;
                  } else if (isFriday(date)) {
                    color =
                        ColorManager.redSoft; // Set Fridays as red by default
                  } else {
                    color = ColorManager
                        .colorWhit; // Set other days to default background color
                  }

                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: color,
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: FontForm.TextStyle20bold.copyWith(
                          color: ColorManager.scondeColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: CustomElevatedButton(
                    colorBorder: ColorManager.primaryColor,
                    colorButton: ColorManager.colorWhit,
                    colorText: ColorManager.primaryColor,
                    text: 'إلغاء',
                    OnPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: CustomElevatedButton(
                    colorBorder: ColorManager.primaryColor,
                    colorButton: ColorManager.primaryColor,
                    colorText: ColorManager.colorWhit,
                    text: 'حفظ',
                    OnPressed: () async {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

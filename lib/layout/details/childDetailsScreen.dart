import 'package:church/layout/details/tableCalendar.dart';
import 'package:church/shared/components/appBar.dart';
import 'package:church/shared/firebase/firebase_function.dart';
import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/child.dart';
import '../../shared/components/custom_ElevatedButton.dart';
import '../../shared/components/custom_Phone.dart';
import '../../shared/components/showCustomSnackbar.dart';
import '../../shared/components/text_form_field.dart';
import '../../shared/style/color_manager.dart';
import 'beleteDialog.dart';

class ChildDetailsScreen extends StatefulWidget {
  final ChildData childData;

  const ChildDetailsScreen({required this.childData});

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

  @override
  Widget build(BuildContext context) {
    final Widget betwwen =
        SizedBox(height: MediaQuery.of(context).size.height * 0.03);
    return Scaffold(
      appBar: AppbarCom(
        textAPP: "تفاصيل ",
        iconApp: Icons.delete_forever,
        onPressedApp: () async {
          bool? confirmDelete = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return DeleteDialog();
            },
          );

          if (confirmDelete == true) {
            await FirebaseService().deleteChildrenById(
              level: widget.childData.level,
              gender: widget.childData.gender,
              id: widget.childData.id,
            );
            Navigator.of(context).pop();
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 5, vertical: MediaQuery.of(context).size.height * 0.05),
        child: ListView(
          children: [
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
              textAlign: TextAlign.right,
              "الغياب",
              style: FontForm.TextStyle30bold.copyWith(
                  backgroundColor: ColorManager.colorWhit),
            ),
            TableCalendarExample(attendanceDates: widget.childData.att),

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
                    OnPressed: () async {
                      FirebaseService().editChildData(
                          id: widget.childData.id,
                          name: nameController.text,
                          bDay: selectedDate,
                          level: widget.childData.level,
                          phone: phoneController.text,
                          gender: widget.childData.gender,
                          notes: notesController.text);
                      Navigator.of(context).pop();
                      showCustomSnackbar(
                        context: context,
                        message: 'تم حفظ التعديلات بنجاح!',
                      );
                    },
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

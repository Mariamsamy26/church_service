import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:church/shared/firebase/firebase_function.dart';
import 'package:church/shared/style/color_manager.dart';
import 'package:flutter/material.dart';
import '../shared/components/custom_DropdownButtonFormField.dart';
import '../shared/components/custom_ElevatedButton.dart';
import '../shared/components/text_form_field.dart';
import '../shared/dataApp.dart';

class AddScreen extends StatefulWidget {
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DateTime selectedDate = DateTime.now();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bDayController = TextEditingController();
  var notesController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectedLevel;
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "assets/images/back.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      AppTextFormField(
                        controller: nameController,
                        hintText: "الاسم ",
                        validator: (text) {
                          if (text?.isEmpty ?? true) {
                            return "اكتب اسم المخدوم ";
                          }
                          return null;
                        },
                        backgroundColor: ColorManager.colorWhit,
                        label: 'الاسم',
                      ),
                      const SizedBox(height: 25),

                      AppTextFormField(
                        hintText: "رقم الهاتف",
                        label: "الهاتف",
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "أدخل رقم الهاتف";
                          } else if (value.length != 11) {
                            return "يجب أن يتكون رقم الهاتف من 11 رقم";
                          }
                          return null;
                        },
                        backgroundColor: ColorManager.colorWhit,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                      ),
                      const SizedBox(height: 25),

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
                              // Formatting the chosen date as 'dd/MM/yyyy'
                              String formattedDate = DateFormat('dd/MM/yyyy').format(chosenDate);
                              bDayController.text = formattedDate;  // Setting the formatted date to the text field
                              setState(() {}); // Update the UI after selecting the date
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
                        backgroundColor: ColorManager.colorWhit,
                        label: 'تاريخ الميلاد',
                        readOnly: true,
                      ),//BD
                      const SizedBox(height: 25),

                      CustomDropdownButtonFormField(
                        width: double.infinity,
                        selectedValue: selectedLevel,
                        items: DataApp.level,
                        labelText: 'المستوى',
                        onChanged: (String? value) {
                          setState(() {
                            selectedLevel = value;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "الرجاء اختيار المستوى";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      CustomDropdownButtonFormField(
                        width: double.infinity,
                        selectedValue: selectedGender,
                        items: DataApp.genter,
                        labelText: 'الجنس',
                        onChanged: (String? value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "الجنس";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      AppTextFormField(
                        controller: notesController,
                        hintText: "ملاحظات إضافية ",
                        validator: (text) {},
                        backgroundColor: ColorManager.colorWhit,
                        label: 'ملاحظات',
                      ),
                      const SizedBox(height: 25),

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
                                if (formKey.currentState!.validate()) {
                                  if (selectedLevel == null ||
                                      selectedGender == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'الرجاء اختيار المستوى والجنس')),
                                    );
                                    return;
                                  }

                                  DateTime parsedDate = DateFormat('dd/MM/yyyy')
                                      .parse(bDayController.text);

                                  String genderCode = selectedGender == "ولد" ? "B" : "G";
                                  int levelIndex = DataApp.level.indexOf(selectedLevel!);

                                  await FirebaseService().saveChildData(
                                    phone:phoneController.text,
                                    name: nameController.text,
                                    bDay: parsedDate,
                                    level: levelIndex + 1,
                                    gender: genderCode,
                                    notes: notesController.text,
                                  );

                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

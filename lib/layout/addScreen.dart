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
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.primaryColor,
                            width: 1.3,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        label: 'الاسم',
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
                              initialDate: selectedDate ?? DateTime.now(),
                            );
                            if (chosenDate != null) {
                              selectedDate = chosenDate;

                              String formattedDate =
                                  DateFormat('d / MM /yyyy').format(chosenDate);

                              bDayController.text = formattedDate;
                              setState(() {});
                            }
                          },
                          icon: Icon(Icons.calendar_month_sharp),
                        ),
                        hintText: "تاريخ الميلاد",
                        validator: (text) {
                          if (text?.isEmpty ?? true) {
                            return "اكتب تاريخ الميلاد";
                          }
                          return null;
                        },
                        backgroundColor: ColorManager.colorWhit,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.primaryColor,
                            width: 1.3,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        label: 'تاريخ الميلاد',
                        readOnly: true,
                      ),
                      const SizedBox(height: 25),

                      CustomDropdownButtonFormField(
                        width: double.infinity,
                        selectedValue: selectedLevel,
                        items: DataApp.level,
                        labelText: 'المستوى',
                        onChanged: (String? value) {
                          setState(() {
                            selectedLevel = value;
                            int selectedIndex = DataApp.level.indexOf(value!) + 1;
                            print("Selected index: $selectedIndex");
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
                            int selectedIndex = DataApp.genter.indexOf(value!) ;
                            print("Selected index: $selectedIndex");
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
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.primaryColor,
                            width: 1.3,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
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
                                    String genderCode = selectedGender == "ولد" ? "B" : "G";
                                    int levelIndex = DataApp.genter.indexOf(selectedGender!) ;

                                    // Await the result of saveChildData
                                    await FirebaseService().saveChildData(
                                      name: nameController.text,
                                      bDay: bDayController.text,
                                      level: levelIndex,
                                      gender: genderCode,
                                      notes: notesController.text,
                                    );

                                    // After the ID is set and saved, pop the context
                                    Navigator.pop(context);
                                  }
                                }
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

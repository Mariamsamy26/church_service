import 'dart:core';
import 'package:church/shared/firebase/firebase_function.dart';
import 'package:church/shared/style/color_manager.dart';
import 'package:flutter/material.dart';
import '../shared/components/Custom_ElevatedButton.dart';
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

  // Define variables to hold selected values for level and gender
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
            Container(
              color: Colors.white30,
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
                            onPressed: ()  async {
                                DateTime? chosenDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1-1-2000), // Start from the year 2000
                                  lastDate: DateTime(2024),
                                );
                                if (chosenDate != null) {
                                  selectedDate = chosenDate;
                                  setState(() {});
                                }
                              }
                            , icon: Icon(
                            Icons.calendar_month_sharp)),
                        hintText: "تاريخ الميلاد ",
                        validator: (text) {
                          if (text?.isEmpty ?? true) {
                            return "اكتب تاريخ الميلاد ";
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
                      ),
                      const SizedBox(height: 25),

                      DropdownButtonFormField<String>(
                        value: selectedLevel,
                        items: DataApp.level.map((String level) {
                          return DropdownMenuItem<String>(
                            value: level, // Use the level as the value
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedLevel = value;

                            // Find the index of the selected value in the DataApp.level list
                            int selectedIndex = DataApp.level.indexOf(value!) +
                                1; // Add 1 to the index

                            // Print the index to verify (you can use it as needed)
                            print("Selected index: $selectedIndex");
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'المستوى',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorManager.primaryColor,
                              width: 1.3,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          fillColor: ColorManager.colorWhit,
                          filled: true,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "الرجاء اختيار المستوى";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        items: DataApp.genter.map((gender) {
                          return DropdownMenuItem<String>(
                              value: gender, child: Text(gender));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'الجنس',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorManager.primaryColor,
                              width: 1.3,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          fillColor: ColorManager.colorWhit,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "الرجاء اختيار الجنس";
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
                              OnPressed: () {
                                if (formKey.currentState!.validate()) {
                                  String genderCode = selectedGender == "ولد"
                                      ? "B"
                                      : "G";

                                  // Use selectedIndex instead of parsing selectedLevel
                                  int levelIndex = DataApp.level.indexOf(
                                      selectedLevel!) + 1;

                                  FirebaseService().saveChildtData(
                                    name: nameController.text,
                                    bDay: bDayController.text,
                                    level: levelIndex,
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

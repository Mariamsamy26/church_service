import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:church/shared/firebase/firebase_function.dart';
import 'package:church/shared/style/color_manager.dart';
import 'package:flutter/material.dart';
import '../shared/components/customDatePicker.dart';
import '../shared/components/custom_DropdownButtonFormField.dart';
import '../shared/components/custom_ElevatedButton.dart';
import '../shared/components/showCustomSnackbar.dart';
import '../shared/components/text_form_field.dart';
import '../shared/dataApp.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DateTime? selectedDate;
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bDayController = TextEditingController();
  var notesController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedLevel;
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final Widget betwwen =
        SizedBox(height: MediaQuery.of(context).size.height * 0.025);
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
              padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      betwwen,
                      AppTextFormField(
                        controller: nameController,
                        hintText: "الاسم ",
                        validator: (text) =>
                            text?.isEmpty ?? true ? "اكتب اسم المخدوم " : null,
                        backgroundColor: ColorManager.colorWhit,
                        label: 'الاسم',
                      ),
                      betwwen,
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
                      betwwen,
                      CustomDatePicker(
                        onDateChanged: (DateTime date) {
                          setState(() {
                            selectedDate = date;
                            bDayController.text =
                                DateFormat('dd/MM/yyyy').format(date);
                          });
                        },
                      ),
                      betwwen,
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
                        validator: (String? value) =>
                            value == null || value.isEmpty
                                ? "الرجاء اختيار المستوى"
                                : null,
                      ),
                      betwwen,
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
                        validator: (String? value) =>
                            value == null || value.isEmpty
                                ? "الرجاء اختيار الجنس"
                                : null,
                      ),
                      betwwen,
                      AppTextFormField(
                        controller: notesController,
                        hintText: "ملاحظات إضافية ",
                        validator: (text) => null,
                        backgroundColor: ColorManager.colorWhit,
                        label: 'ملاحظات',
                      ),
                      betwwen,
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
                          betwwen,
                          Expanded(
                            flex: 1,
                            child: CustomElevatedButton(
                              colorBorder: ColorManager.primaryColor,
                              colorButton: ColorManager.primaryColor,
                              colorText: ColorManager.colorWhit,
                              text: 'حفظ',
                              OnPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  if (selectedDate == null) {
                                    showCustomSnackbar(
                                      context: context,
                                      message: 'الرجاء اختيار تاريخ الميلاد',
                                      backgroundColor: Colors.red,
                                    );
                                    return;
                                  }
                                  try {
                                    await FirebaseService().saveChildData(
                                      phone: phoneController.text,
                                      name: nameController.text,
                                      bDay: selectedDate!,
                                      level: DataApp.level
                                              .indexOf(selectedLevel!) +
                                          1,
                                      gender:
                                          selectedGender == "ولد" ? "B" : "G",
                                      notes: notesController.text,
                                    );
                                    Navigator.pop(context);
                                    showCustomSnackbar(
                                      context: context,
                                      message: 'تم حفظ المخدوم!',
                                      backgroundColor:
                                          ColorManager.primaryColor,
                                    );
                                  } catch (e) {
                                    showCustomSnackbar(
                                      context: context,
                                      message: 'خطأ في حفظ البيانات: $e',
                                      backgroundColor: Colors.red,
                                    );
                                  }
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

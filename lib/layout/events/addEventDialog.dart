import 'package:flutter/material.dart';
import '../../shared/components/customDatePicker.dart';
import '../../shared/firebase/firebase_function.dart';
import '../../shared/style/color_manager.dart';
import '../../shared/style/fontForm.dart';

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({Key? key}) : super(key: key);

  @override
  State<AddEventDialog> createState() => AddEventDialogState();

  static Future<bool?> show(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AddEventDialog(),
    );
  }
}

class AddEventDialogState extends State<AddEventDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      backgroundColor: ColorManager.scondeColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("إضافة نشاط جديد", style: FontForm.TextStyle20boldW),
            const SizedBox(height: 15),
            buildTextField(nameController, "اسم الرحلة", Icons.label),
            const SizedBox(height: 10),
            buildTextField(priceController, "السعر", Icons.attach_money,
                isNumber: true),
            const SizedBox(height: 10),
            buildTextField(locationController, "المكان", Icons.location_on),
            const SizedBox(height: 10),
            CustomDatePicker(
              onDateChanged: (DateTime date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 10),
            buildTextField(
                detailsController, "التفاصيل ", Icons.description,
                isMultiline: true),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorManager.primaryColor,
                    backgroundColor: Colors.white70,
                    side: const BorderSide(color: ColorManager.primaryColor),
                  ),
                  child: Text("إلغاء", style: FontForm.TextStyle20bold),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: Text("حفظ",
                      style: FontForm.TextStyle20bold.copyWith(
                          color: Colors.white70)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isNumber = false,
    bool isMultiline = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber
          ? TextInputType.number
          : (isMultiline ? TextInputType.multiline : TextInputType.text),
      maxLines: isMultiline ? 3 : 1,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  void saveEvent() async {
    String name = nameController.text.trim();
    String priceText = priceController.text.trim();
    String location = locationController.text.trim();
    String details = detailsController.text.trim();

    if (name.isEmpty ||
        priceText.isEmpty ||
        location.isEmpty ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("يجب ملء جميع الحقول الإلزامية واختيار التاريخ")),
      );
      return;
    }

    double? price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى إدخال سعر صالح")),
      );
      return;
    }

    await FirebaseService.addEvent(
      name: name,
      price: price,
      location: location,
      details: details,
      date: selectedDate!,
      children: [],
    );

    Navigator.pop(context, true);
  }
}

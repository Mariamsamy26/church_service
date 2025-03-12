import 'package:flutter/material.dart';
import '../../shared/components/customDatePicker.dart';
import '../../shared/firebase/firebase_function.dart';
import '../../shared/style/color_manager.dart';
import '../../shared/style/fontForm.dart';

class AddPaymentDialog extends StatefulWidget {
  final String childId;
  final String childNAME;
  final String childphone;
  final int level;
  final String eventId;

  const AddPaymentDialog({
    Key? key,
    required this.childId,
    required this.eventId,
    required this.childphone,
    required this.childNAME,
    required this.level,
  }) : super(key: key);

  @override
  State<AddPaymentDialog> createState() => AddPaymentDialogState();

  static Future<bool?> show(BuildContext context,
      {required String childId,
      required String eventId,
      required String childNAME,
      required String childPhone,
      required int level}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AddPaymentDialog(
          childId: childId,
          eventId: eventId,
          childphone: childPhone,
          childNAME: childNAME,
          level: level,
        );
      },
    );
  }
}

class AddPaymentDialogState extends State<AddPaymentDialog> {
  final TextEditingController namebasoonController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  DateTime selectedDate = DateTime.now();

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
            buildTextField(
                namebasoonController, "اسم الخادم", Icons.perm_contact_cal),
            const SizedBox(height: 10),
            buildTextField(
                priceController, "المبلغ المدفوع", Icons.attach_money,
                isNumber: true),
            const SizedBox(height: 10),
            CustomDatePicker(
              onDateChanged: (DateTime date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
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
                  onPressed: savePayment,
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
      TextEditingController controller, String hint, IconData icon,
      {bool isNumber = false, bool isMultiline = false}) {
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

  void savePayment() async {
    String priceText = priceController.text.trim();
    double? amountPaid = double.tryParse(priceText);

    if (priceText.isEmpty || amountPaid == null) {
      showError("يجب إدخال مبلغ صالح");
      return;
    }

    if (widget.eventId.isEmpty || widget.childId.isEmpty) {
      showError("حدث خطأ في البيانات المطلوبة");
      return;
    }

    try {
      double totalPrice =
          await FirebaseService.getPriceByEventId(widget.eventId);
      double totalPaid =
          await FirebaseService.getTotalPaid(widget.eventId, widget.childId);
      double remainingAmount = FirebaseService.getRemainingAmount(
        amountPaid: amountPaid,
        totalPaid: totalPaid,
        totalPrice: totalPrice,
      );

      if (remainingAmount < 0) {
        showError("في زياده ${remainingAmount.abs()} جنيه");
        return;
      }

      await FirebaseService.updateEventPayment(
        eventId: widget.eventId,
        childId: widget.childId,
        namebasoon: namebasoonController.text,
        amountPaid: amountPaid,
        paymentDate: selectedDate,
        remainingAmount: remainingAmount,
        childNAME: widget.childNAME,
        level: widget.level,
        childPhone: widget.childphone,
      );

      Navigator.pop(context, true);
    } catch (e) {
      showError("حدث خطأ أثناء حفظ الدفعة: $e");
      print("حدث خطأ أثناء حفظ الدفعة: $e");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

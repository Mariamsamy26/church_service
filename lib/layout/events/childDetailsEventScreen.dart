import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // لإجراء المكالمات
import '../../shared/components/appBar.dart';
import '../../shared/components/text_form_field.dart';
import '../../shared/style/color_manager.dart';
import '../../model/childEvent.dart';

class ChildDetailsEventScreen extends StatefulWidget {
  final ChildEvent childEvent;

  const ChildDetailsEventScreen({required this.childEvent});

  @override
  _ChildDetailsEventScreenState createState() =>
      _ChildDetailsEventScreenState();
}

class _ChildDetailsEventScreenState extends State<ChildDetailsEventScreen> {
  late TextEditingController levelController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    levelController =
        TextEditingController(text: widget.childEvent.level.toString());
    phoneController = TextEditingController(text: widget.childEvent.childphone);
  }

  @override
  void dispose() {
    levelController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // دالة لإجراء المكالمة
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'تعذر فتح تطبيق الهاتف';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCom(
        textAPP: widget.childEvent.childNAME,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: _buildDetailRow(
                  Icons.school, ":المرحلة", levelController.text),
            ),
            Padding(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: _buildDetailRow(
                  Icons.phone_android, ":رقم الهاتف", phoneController.text,
                  isPhone: true),
            ),
            SizedBox(height: 16),

            // Divider
            Divider(
              thickness: 1,
              height: 24,
              color: ColorManager.primaryColor.withAlpha(80),
            ),

            // Payment Details Title
            Center(
              child: Text(
                "تفاصيل الدفعات",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 16),

            // List of Installments
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.childEvent.installments.length,
              itemBuilder: (context, index) {
                final installment = widget.childEvent.installments[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${installment.namebasoon}:اسم الخادم ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.primaryColor,
                          ),
                        ),
                        SizedBox(height: 12),

                        // تفاصيل الدفعة
                        _buildDetailRow(Icons.attach_money, ":المبلغ المدفوع",
                            "${installment.amountPaid} جنيه"),
                        _buildDetailRow(
                            Icons.date_range,
                            ":تاريخ الدفع",
                            DateFormat('dd-MM-yyyy')
                                .format(installment.paymentDate)),
                        _buildDetailRow(Icons.money_off, ":المبلغ المتبقي",
                            "${installment.remainingAmount} جنيه"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value,
      {bool isPhone = false}) {
    return InkWell(
      onTap: isPhone ? () => _makePhoneCall(value) : null,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: isPhone ? ColorManager.primaryColor : Colors.grey[800],
                  fontSize: 19,
                  decoration: isPhone ? TextDecoration.underline : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(width: 4),
            Icon(icon, color: ColorManager.primaryColor, size: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentInstallment {
  final String namebasoon;
  final double amountPaid;
  final double remainingAmount;
  final DateTime paymentDate;

  PaymentInstallment({
    required this.namebasoon,
    required this.amountPaid,
    required this.paymentDate,
    required this.remainingAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      "namebasoon": namebasoon,
      "amountPaid": amountPaid,
      "paymentDate": paymentDate,
      "remainingAmount": remainingAmount,
    };
  }

  factory PaymentInstallment.fromJson(Map<String, dynamic> json) {
    return PaymentInstallment(
      namebasoon: json['namebasoon'],
      amountPaid: json['amountPaid'],
      paymentDate: (json['paymentDate'] as Timestamp).toDate(),
      remainingAmount: json['remainingAmount'],
    );
  }
}

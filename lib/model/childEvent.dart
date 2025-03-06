import 'PaymentInstallment.dart';

class ChildEvent {
  final String childId;
  final double totalPrice;
  final List<PaymentInstallment> installments;

  ChildEvent({
    required this.childId,
    required this.totalPrice,
    required this.installments,
  });

  Map<String, dynamic> toJson() {
    return {
      "childId": childId,
      "totalPrice": totalPrice,
      "installments": installments.map((e) => e.toJson()).toList(),
    };
  }

  factory ChildEvent.fromJson(Map<String, dynamic> json) {
    return ChildEvent(
      childId: json["childId"],
      totalPrice: json["totalPrice"].toDouble(),
      installments: (json["installments"] as List<dynamic>?)
              ?.map((e) => PaymentInstallment.fromJson(e))
              .toList() ??
          [],
    );
  }
}

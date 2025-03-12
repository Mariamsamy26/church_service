import 'PaymentInstallment.dart';

class ChildEvent {
  final String childId;
  final String childNAME;
  final String childphone;
  final int level;
  final double totalPrice;
  final List<PaymentInstallment> installments;

  ChildEvent({
    required this.childNAME,
    required this.childphone,
    required this.childId,
    required this.level,
    required this.totalPrice,
    required this.installments,
  });

  Map<String, dynamic> toJson() {
    return {
      "childId": childId,
      "childNAME": childNAME,
      "childphone": childphone,
      "level": level,
      "totalPrice": totalPrice,
      "installments": installments.map((e) => e.toJson()).toList(),
    };
  }

  factory ChildEvent.fromJson(Map<String, dynamic> json) {
    return ChildEvent(
      childId: json["childId"] ?? "",
      childNAME: json["childNAME"] ?? "غير معروف",
      childphone: json["childphone"] ?? "غير معروف",
      level: json["level"] ?? "غير محدد",
      totalPrice: json["totalPrice"]?.toDouble() ?? 0.0,
      installments: (json["installments"] as List<dynamic>? ?? [])
          .map((e) => PaymentInstallment.fromJson(e))
          .toList(),
    );
  }
}

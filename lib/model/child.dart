import 'package:cloud_firestore/cloud_firestore.dart';

class ChildData {
  String? id;
  String? name;
  DateTime? bDay;
  int level;
  String phone;
  String gender;
  String notes;
  String? imgUrl;
  List<DateTime> att;

  ChildData({
    this.id,
    required this.name,
    required this.bDay,
    required this.level,
    required this.gender,
    required this.notes,
    required this.imgUrl,
    required this.att,
    required this.phone,
  });

  // Constructor for initializing from JSON, handling different types for bDay and att
  ChildData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        bDay = json['bDay'] is Timestamp
            ? (json['bDay'] as Timestamp).toDate()
            : json['bDay'] is String
            ? DateTime.tryParse(json['bDay'])
            : null,
        level = json['level'] ?? 0,
        phone = json['phone'] ?? 0100000000,
        gender = json['gender'] ?? '',
        notes = json['notes'] ?? '',
        imgUrl = json['imgUrl'],
        att = (json['att'] as List<dynamic>?)
            ?.map((e) => e is Timestamp
            ? e.toDate()
            : e is String
            ? DateTime.tryParse(e) ?? DateTime.now()
            : DateTime.now())
            .toList() ??
            [];

  // Method to convert to JSON, formatting dates correctly
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "bDay": bDay != null ? Timestamp.fromDate(bDay!) : null,
      "level": level,
      "phone": phone,
      "gender": gender,
      "notes": notes,
      "imgUrl": imgUrl,
      "att": att.map((e) => Timestamp.fromDate(e)).toList(),
    };
  }
}

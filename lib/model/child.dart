class ChildData {
  String? id;
  String? name;
  String? bDay;
  int level;
  String gender;
  String notes;
  String? imgUrl;
  List<DateTime> att;

  ChildData({
    required this.id,
    required this.name,
    required this.bDay,
    required this.level,
    required this.gender,
    required this.notes,
    required this.imgUrl,
    required this.att,
  });

  ChildData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        bDay = json['bDay'],
        level = json['level'] ?? 0,
        gender = json['gender'] ?? '',
        notes = json['notes'] ?? '',
        imgUrl = json['imgUrl'], // تخزين رابط الصورة
        att = (json['att'] as List<dynamic>)
            .map((e) => DateTime.parse(e as String))
            .toList();

  // تحويل الكائن إلى JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "bDay": bDay,
      "level": level,
      "gender": gender,
      "notes": notes,
      "imgUrl": imgUrl, // تخزين رابط الصورة فقط
      "att": att.map((e) => e.toIso8601String()).toList(),
    };
  }
}

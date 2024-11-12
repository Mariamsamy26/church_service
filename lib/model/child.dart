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
        bDay = json['bDay'],  // if bDay is null
        level = json['level'] ?? 0,
        gender = json['gender'] ?? '',
        notes = json['notes'] ?? '',
        imgUrl = json['imgUrl'],
        att = (json['att'] as List<dynamic>)
            .map((e) => DateTime.parse(e as String))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "bDay": bDay, // Convert to ISO 8601 string if bDay is not null
      "level": level,
      "gender": gender,
      "notes": notes,
      "imgUrl": imgUrl,
      "att": att.map((e) => e.toIso8601String()).toList(),
    };
  }

  DateTime? getParsedBDay() {
    // If bDay is not null, parse it
    if (bDay != null) {
      // Assuming the date format is 'd / m / yyyy'
      String cleanedDateStr = bDay!.replaceAll(' / ', '-').replaceAll(' ', '');
      return DateTime.tryParse(cleanedDateStr);
    }
    return null;
  }
}

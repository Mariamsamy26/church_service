import 'package:cloud_firestore/cloud_firestore.dart';
import 'child.dart';

class EventModel {
  final String id;
  final String name;
  final double price;
  final String location;
  final String details;
  final DateTime date;
  final List<ChildData> children;

  EventModel({
    required this.id,
    required this.name,
    required this.price,
    required this.location,
    required this.details,
    required this.date,
    required this.children,
  });

  // تحويل من Map إلى كائن EventModel
  factory EventModel.fromMap(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      name: data["name"] ?? "",
      price: (data["price"] as num).toDouble(),
      location: data["location"] ?? "",
      details: data["details"] ?? "",
      date: data["date"] is Timestamp
          ? (data["date"] as Timestamp).toDate()
          : DateTime.tryParse(data["date"].toString()) ?? DateTime.now(),
      children: (data["child"] as List<dynamic>?)?.map((child) {
            return ChildData.fromJson(child as Map<String, dynamic>);
          }).toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "location": location,
      "details": details,
      "date": Timestamp.fromDate(date),
      "child": children.map((child) => child.toJson()).toList(),
    };
  }
}

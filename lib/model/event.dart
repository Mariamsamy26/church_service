import 'package:church/model/childEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String name;
  final double price;
  final String location;
  final String details;
  final DateTime date;
  final List<ChildEvent> children;

  EventModel({
    required this.id,
    required this.name,
    required this.price,
    required this.location,
    required this.details,
    required this.date,
    required this.children,
  });

  // من Map إلى EventModel
  factory EventModel.fromMap(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      name: data["name"] ?? "",
      price: (data["price"] as num?)?.toDouble() ?? 0.0,
      location: data["location"] ?? "",
      details: data["details"] ?? "",
      date: data["date"] is Timestamp
          ? (data["date"] as Timestamp).toDate()
          : DateTime.tryParse(data["date"].toString()) ?? DateTime.now(),
      children: (data["children"] is List)
          ? (data["children"] as List<dynamic>)
              .map((child) => ChildEvent.fromJson(child))
              .toList()
          : [],
    );
  }

  // من EventModel إلى Map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "location": location,
      "details": details,
      "date": Timestamp.fromDate(date),
      "children": children.map((child) => child.toJson()).toList(),
    };
  }
}

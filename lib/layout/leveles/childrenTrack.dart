import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/child.dart';

class ChildrenTrack extends StatelessWidget {
  final DateTime day;  // Ensure this is DateTime
  final Function(DateTime) onMonthChanged;
  final List<ChildData>? childrenData;

  const ChildrenTrack({
    super.key,
    required this.onMonthChanged,
    required this.childrenData,
    required this.day, // Ensure day is DateTime
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Attendance"),
      ),
      body: Column(
        children: [
          // Your widget content here
        ],
      ),
    );
  }
}

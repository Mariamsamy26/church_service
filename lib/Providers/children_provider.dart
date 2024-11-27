import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../model/child.dart';
import '../shared/firebase/firebase_function.dart';

class ChildrenProvider extends ChangeNotifier {
  final int level;
  final String gender;
  String selectedMonth = "كل الاشهر"; // Default to "All months"
  DateTime selectedDayTrack = DateTime.now(); // For tracking attendance by specific date

  ChildrenProvider({required this.level, required this.gender});

  // Function to get the stream based on the selected filter
  Stream<List<ChildData>> get childrenStream {
    if (selectedMonth == "كل الاشهر" || selectedMonth == '13') {
      // Get children based on level and gender for all months
      return FirebaseService().getChildrenByLevelAndGender(level, gender);
    } else if (selectedMonth == '14') {
      // Tracking attendance for a specific date
      return FirebaseService().trakingChildren(
        level: level,
        gender: gender,
        attendanceDate: selectedDayTrack,
        monthStr: _formatMonth(selectedDayTrack), // Pass the month in "MM/yyyy" format
      );
    } else {
      // Get children by birthday month (with selected month in "MM/yyyy" format)
      return FirebaseService().bDChildrenByLevelAndGender(
        level: level,
        gender: gender,
        monthStr: selectedMonth, // Directly use the formatted month string
      );
    }
  }

  // Function to update the selected month filter and notify listeners
  void updateMonthFilter(String? month) {
    selectedMonth = month ?? "كل الاشهر"; // Default to "All months"
    notifyListeners(); // Ensure to notify the UI
  }

  // Function to update the tracking date
  void updateTrackingDate(DateTime date) {
    selectedDayTrack = date;
    notifyListeners(); // Ensure to notify the UI
  }

  // Function to format the month as 'MM/yyyy'
  String _formatMonth(DateTime date) {
    return DateFormat('MM/yyyy').format(date); // Corrected format
  }
}

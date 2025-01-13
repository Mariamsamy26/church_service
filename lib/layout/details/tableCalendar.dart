import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../shared/style/color_manager.dart';
import '../../shared/style/fontForm.dart';

class TableCalendarExample extends StatelessWidget {
  final List<DateTime> attendanceDates; // List of attendance dates

  const TableCalendarExample({
    Key? key,
    required this.attendanceDates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2023, 11, 01),
      lastDay: DateTime.now(),
      focusedDay: DateTime.now(),
      selectedDayPredicate: (day) {
        bool isFriday = day.weekday == DateTime.friday;
        bool isInAttendance = attendanceDates.any(
          (attendanceDate) =>
              attendanceDate.year == day.year &&
              attendanceDate.month == day.month &&
              attendanceDate.day == day.day,
        );
        return isFriday || isInAttendance;
      },
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: ColorManager.redSoft, // Highlight Fridays with red by default
          shape: BoxShape.rectangle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      onDaySelected: (selectedDay, focusedDay) {
        // Handle day selection here if needed
      },
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, _) {
          Color color = ColorManager.redSoft; // Default for Fridays

          // Check if the date is in the attendance list
          bool isInAttendance = attendanceDates.any(
                (attendanceDate) =>
            attendanceDate.year == date.year &&
                attendanceDate.month == date.month &&
                attendanceDate.day == date.day,
          );

          // Apply green if the date is in the attendance list, else keep it red for Fridays
          if (isInAttendance) {
            color = ColorManager.greenSoft;
          } else if (date.weekday == DateTime.friday) {
            color = ColorManager.redSoft;
          } else {
            color = ColorManager.colorWhit; // Default background color
          }

          return Container(
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: color,
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: FontForm.TextStyle20bold.copyWith(
                  color: ColorManager.scondeColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

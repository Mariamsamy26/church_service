import 'package:church/shared/style/color_manager.dart';
import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/child.dart';
import '../../shared/components/custom_Card.dart';
import '../../shared/components/showCustomSnackbar.dart';
import '../../shared/firebase/firebase_function.dart';

class ChildrenAtt extends StatefulWidget {
  final ValueChanged<String?> onMonthChanged;
  final List<ChildData>? childrenData;

  const ChildrenAtt({
    super.key,
    required this.childrenData,
    required this.onMonthChanged,
  });

  @override
  _ChildrenAttState createState() => _ChildrenAttState();
}

class _ChildrenAttState extends State<ChildrenAtt> {
  String dayToday = DateFormat('dd/MM/yyyy').format(DateTime.now());
  late Map<String, bool> attendanceSelection;

  @override
  void initState() {
    super.initState();
    _initializeAttendanceSelection();
  }

  void _initializeAttendanceSelection() {
    attendanceSelection = {
      for (var child in widget.childrenData ?? [])
        child.id ?? "": child.att.any((entry) =>
            entry.year == DateTime.now().year &&
            entry.month == DateTime.now().month &&
            entry.day == DateTime.now().day)
    };
  }

  Future<void> _updateAttendance() async {
    try {
      for (var child in widget.childrenData!) {
        DateTime attendanceDate = DateFormat('dd/MM/yyyy').parse(dayToday);
        bool state = attendanceSelection[child.id ?? ""] ?? false;

        await FirebaseService().saveAttendance(
          childId: child.id,
          level: child.level,
          gender: child.gender,
          attendanceDate: attendanceDate,
          state: state,
        );

        setState(() {
          if (state) {
            child.att.add(attendanceDate);
          } else {
            child.att.removeWhere((date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day);
          }
        });
      }

      widget.onMonthChanged("كل الاشهر");

      showCustomSnackbar(
        context: context,
        message: 'تم تحديث الحضور بنجاح!',
        backgroundColor: ColorManager.greenSoft,
      );
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'حدث خطأ أثناء تحديث الحضور: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Text(
              "حضور يوم $dayToday",
              style: FontForm.TextStyle30bold,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _updateAttendance,
                  child: Text("تأكيد الحضور"),
                )
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.childrenData?.length,
              itemBuilder: (context, index) {
                var child = widget.childrenData?[index];
                bool isSelected = attendanceSelection[child?.id ?? ""] ?? false;

                return CustomCard(
                  profileImage: child?.imgUrl ?? "",
                  name: child?.name ?? "Unknown",
                  phone: child?.phone ?? "Unknown",
                  id: child?.id ?? "N/A",
                  icon: isSelected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_rounded,
                  iconFunction: () {
                    setState(() {
                      attendanceSelection[child?.id ?? ""] = !isSelected;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

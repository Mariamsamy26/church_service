import 'package:church/model/child.dart';
import 'package:church/shared/components/appBar.dart';
import 'package:church/shared/style/color_manager.dart';
import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/components/custom_Card.dart';
import '../../shared/components/showCustomSnackbar.dart';
import '../../shared/firebase/firebase_function.dart';

class ChildrenallAtt extends StatefulWidget {
  final String genter;
  final List<ChildData> childrenData;

  const ChildrenallAtt({
    super.key,
    required this.genter,
    required this.childrenData,
  });

  @override
  _ChildrenallAttState createState() => _ChildrenallAttState();
}

class _ChildrenallAttState extends State<ChildrenallAtt> {
  String dayToday = DateFormat('dd/MM/yyyy').format(DateTime.now());
  Map<String, bool> attendanceSelection = {};

  @override
  void initState() {
    super.initState();
    _initializeAttendanceSelection();
  }

  void _initializeAttendanceSelection() {
    for (var child in widget.childrenData) {
      attendanceSelection[child.id ?? ""] = child.att.any((entry) {
        return entry.year == DateTime.now().year &&
            entry.month == DateTime.now().month &&
            entry.day == DateTime.now().day;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCom(textAPP: "حضور", iconApp: Icons.add),
      body: ListView(
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
                    onPressed: () async {
                      try {
                        for (var child in widget.childrenData) {
                          DateTime attendanceDate =
                              DateFormat('dd/MM/yyyy').parse(dayToday);
                          bool state =
                              attendanceSelection[child.id ?? ""] ?? false;

                          await FirebaseService().saveAttendance(
                            childId: child.id,
                            level: child.level,
                            gender: child.gender,
                            attendanceDate: attendanceDate,
                            state: state,
                          );

                          if (state) {
                            child.att.add(attendanceDate);
                          } else {
                            child.att.removeWhere((date) =>
                                date.year == DateTime.now().year &&
                                date.month == DateTime.now().month &&
                                date.day == DateTime.now().day);
                          }
                        }
                        Navigator.pop(context);

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
                    },
                    child: const Text("تأكيد الحضور"),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.childrenData.length,
                itemBuilder: (context, index) {
                  var child = widget.childrenData[index];
                  bool isSelected =
                      attendanceSelection[child.id ?? ""] ?? false;

                  return CustomCard(
                    profileImage: child.imgUrl ?? "",
                    name: child.name ?? "Unknown",
                    phone: child.phone ?? "Unknown",
                    id: child.id ?? "N/A",
                    icon: isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank_rounded,
                    iconFunction: () {
                      setState(() {
                        attendanceSelection[child.id ?? ""] = !isSelected;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

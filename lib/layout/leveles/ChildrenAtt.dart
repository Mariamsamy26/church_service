import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/child.dart';
import '../../shared/components/custom_Card.dart';
import '../../shared/firebase/firebase_function.dart';

class ChildrenAtt extends StatefulWidget {
  final ValueChanged<String?> onMonthChanged;
  final List<ChildData>? childrenData;

  const ChildrenAtt({Key? key, required this.childrenData, required this.onMonthChanged}) : super(key: key);

  @override
  _ChildrenAttState createState() => _ChildrenAttState();
}

class _ChildrenAttState extends State<ChildrenAtt> {
  String dayToday = DateFormat('dd/MM/yyyy').format(DateTime.now());


  Map<String, bool> attendanceSelection = {};

  Future<void> _saveAttendance() async {
    final collection = FirebaseFirestore.instance.collection('children');

    for (var child in widget.childrenData!) {
      if (attendanceSelection[child.id ?? ""] == true) {
        child.att.add(DateTime.parse(dayToday));

        await collection.doc(child.id).update({
          'att': child.att.map((e) => Timestamp.fromDate(e)).toList(),
        }).catchError((e) {
          print("Error updating attendance: $e");
        });
      }
    }

    // Clear the selection after saving
    setState(() {
      attendanceSelection.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "حضور يوم $dayToday",
          style: FontForm.TextStyle20bold,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.childrenData?.length,
          itemBuilder: (context, index) {
            var child = widget.childrenData?[index];
            bool isSelected = attendanceSelection[child!.id ?? ""] ?? false;

            return CustomCard(
              profileImage: child.imgUrl.toString(),
              name: child.name!,
              phone: child.phone,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () async {

                for (var child in widget.childrenData!) {
                  if (attendanceSelection[child.id!] == true) {
                    DateTime attendanceDate = DateFormat('dd/MM/yyyy').parse(dayToday);
                    await FirebaseService().saveAttendance(
                      childId: child.id!,
                      level: child.level,
                      gender: child.gender,
                      attendanceDate: attendanceDate,
                    );
                  }
                }
                widget.onMonthChanged("0");
              },
              child: Text("تأكيد الحضور"),
            )

          ],
        ),
      ],
    );
  }
}

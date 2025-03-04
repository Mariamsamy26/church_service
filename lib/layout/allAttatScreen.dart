import 'package:church/model/child.dart';
import 'package:church/shared/components/appBar.dart';
import 'package:church/shared/style/color_manager.dart';
import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/components/custom_CustomCardListTile.dart';
import '../../shared/components/showCustomSnackbar.dart';
import '../../shared/firebase/firebase_function.dart';
import '../shared/components/customSearchDelegate.dart';

class ChildrenallAtt extends StatefulWidget {
  final String genter;
  final List<ChildData> childrenData;

  const ChildrenallAtt({
    super.key,
    required this.genter,
    required this.childrenData,
  });

  @override
  ChildrenallAttState createState() => ChildrenallAttState();
}

class ChildrenallAttState extends State<ChildrenallAtt> {
  String dayToday = DateFormat('dd/MM/yyyy').format(DateTime.now());
  Map<String, bool> attendanceSelection = {};
  final TextEditingController searchController = TextEditingController();
  late List<ChildData> filteredChildren;

  @override
  void initState() {
    super.initState();
    _initializeAttendanceSelection();
    filteredChildren = List.from(widget.childrenData);
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

  void _filterChildren(String query) {
    setState(() {
      if (query.isEmpty) {
        _resetSearch();
      } else {
        filteredChildren = widget.childrenData
            .where((child) =>
                child.name!.toLowerCase().contains(query.toLowerCase()) ||
                child.id!.contains(query))
            .toList();
      }
    });
  }

  void _resetSearch() {
    setState(() {
      filteredChildren = List.from(widget.childrenData);
    });
  }

  void _toggleAttendance(String childId) {
    setState(() {
      attendanceSelection[childId] = !(attendanceSelection[childId] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCom(
        textAPP: "حضور",
        iconApp: Icons.search,
        onPressedApp: () async {
          final result = await showSearch(
            context: context,
            delegate: CustomSearchDelegate(
              childrenData: widget.childrenData,
              onSearch: _filterChildren,
              toggleAttendance: _toggleAttendance,
              attendanceSelection: attendanceSelection,
            ),
          );
          if (result == null) _resetSearch();
        },
      ),
      body: ListView(
        children: [
          Text(
            textAlign: TextAlign.center,
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
                      bool state = attendanceSelection[child.id ?? ""] ?? false;

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
            itemCount: filteredChildren.length,
            itemBuilder: (context, index) {
              var child = filteredChildren[index];
              bool isSelected = attendanceSelection[child.id ?? ""] ?? false;

              return CustomCardListTile(
                profileImage: child.imgUrl ?? "",
                name: child.name ?? "Unknown",
                phone: child.phone ?? "Unknown",
                id: child.id ?? "N/A",
                icon: isSelected
                    ? Icons.check_box
                    : Icons.check_box_outline_blank_rounded,
                iconFunction: () {
                  _toggleAttendance(child.id ?? "");
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

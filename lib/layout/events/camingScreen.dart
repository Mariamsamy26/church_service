import 'dart:async';
import 'package:church/shared/firebase/firebase_function.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/event.dart';
import '../../shared/components/showCustomSnackbar.dart';
import '../../shared/style/color_manager.dart';
import '../../model/child.dart';

class CamingScreen extends StatefulWidget {
  final EventModel event;
  final Stream<List<ChildData>> allChildren;

  const CamingScreen({
    super.key,
    required this.allChildren,
    required this.event,
  });

  @override
  CamingScreenState createState() => CamingScreenState();
}

class CamingScreenState extends State<CamingScreen> {
  Map<String, bool> attendanceSelection = {};
  Map<String, TextEditingController> paymentControllers = {};
  StreamSubscription<List<ChildData>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.allChildren.listen((children) {
      setState(() {
        for (var child in children) {
          attendanceSelection.putIfAbsent(child.id ?? "", () => false);
          paymentControllers.putIfAbsent(
              child.id ?? "", () => TextEditingController());
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    for (var controller in paymentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleAttendance(String childId) {
    setState(() {
      attendanceSelection[childId] = !(attendanceSelection[childId] ?? false);
      if (!attendanceSelection[childId]!) {
        paymentControllers[childId]?.clear();
      }
    });
  }

  Future<void> _confirmAttendance(List<ChildData> childrenData) async {
    try {
      List<Map<String, dynamic>> selectedChildren = [];

      for (var child in childrenData) {
        bool isSelected = attendanceSelection[child.id ?? ""] ?? false;
        if (isSelected) {
          double amountPaid = double.tryParse(
              paymentControllers[child.id]?.text ?? "0") ?? 0;
          selectedChildren.add({
            "id": child.id,
            "name": child.name,
            "amountPaid": amountPaid,
          });
        }
      }

      await FirebaseService.addChildrenToTrip(
        DateFormat('dd-MM-yyyy').format(widget.event.date),
        selectedChildren,
      );

      showCustomSnackbar(
        context: context,
        message: 'تم تحديث الحضور والمدفوعات!',
        backgroundColor: ColorManager.greenSoft,
      );

      Navigator.pop(context);
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'حدث خطأ: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("حضور الرحلة")),
      body: StreamBuilder<List<ChildData>>(
        stream: widget.allChildren,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.error != null) {
            print("mmm $snapshot.error kkk");
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا يوجد أطفال مسجلين."));
          }

          final childrenData = snapshot.data!;

          return ListView(
            children: [
              Text(
                "رحلة يوم ${DateFormat('dd-MM-yyyy').format(
                    widget.event.date)}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: childrenData.length,
                itemBuilder: (context, index) {
                  var child = childrenData[index];
                  bool isSelected = attendanceSelection[child.id ?? ""] ??
                      false;

                  return ListTile(
                    leading: Icon(
                      isSelected ? Icons.check_box : Icons
                          .check_box_outline_blank_rounded,
                      color: isSelected ? Colors.green : Colors.grey,
                    ),
                    title: Text(child.name ?? "Unknown"),
                    subtitle: TextField(
                      controller: paymentControllers[child.id],
                      keyboardType: TextInputType.number,
                      enabled: isSelected,
                      decoration: const InputDecoration(
                        labelText: "المبلغ المدفوع",
                        prefixIcon: Icon(Icons.money),
                      ),
                    ),
                    onTap: () => _toggleAttendance(child.id ?? ""),
                  );
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _confirmAttendance(childrenData),
                  child: const Text("تأكيد الحضور"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

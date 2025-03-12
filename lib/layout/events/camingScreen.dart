import 'package:flutter/material.dart';
import '../../model/childEvent.dart';
import '../../model/event.dart';
import '../../shared/components/appBar.dart';
import '../../shared/components/customSearchDelegate.dart';
import '../../shared/components/custom_CustomCardListTile.dart';
import '../../shared/firebase/firebase_function.dart';
import 'addPaynentDialog.dart';

class CamingScreen extends StatefulWidget {
  final EventModel event;
  final List<ChildEvent> CamingChildrenStream;

  const CamingScreen({
    super.key,
    required this.event,
    required this.CamingChildrenStream,
  });

  @override
  CamingScreenState createState() => CamingScreenState();
}

class CamingScreenState extends State<CamingScreen> {
  final TextEditingController searchController = TextEditingController();
  List<ChildEvent> filteredChildren = [];
  Map<String, bool> selectionMap = {};
  double totalPrice = 0.0;
  Map<String, double> totalPaidMap = {};
  Map<String, double> remainingAmountMap = {};

  @override
  void initState() {
    super.initState();
    _initializeSelectionMap();
    _fetchTotalPriceAndPayments();
    setState(() {
      filteredChildren = List.from(widget.CamingChildrenStream);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _initializeSelectionMap() {
    for (var child in widget.event.children) {
      selectionMap[child.childId ?? ""] = true;
    }
  }

  Future<void> _fetchTotalPriceAndPayments() async {
    try {
      totalPrice = await FirebaseService.getPriceByEventId(widget.event.id);
      for (var child in widget.CamingChildrenStream) {
        double totalPaid = await FirebaseService.getTotalPaid(
            widget.event.id, child.childId ?? "");
        double remainingAmount = totalPrice - totalPaid;

        setState(() {
          totalPaidMap[child.childId ?? ""] = totalPaid;
          remainingAmountMap[child.childId ?? ""] = remainingAmount;
        });
      }
    } catch (e) {
      print("Error fetching payments: $e");
    }
  }

  void _filterChildren(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredChildren = List.from(widget.CamingChildrenStream);
      } else {
        filteredChildren = widget.CamingChildrenStream.where((child) {
          return (child.childNAME?.toLowerCase() ?? '')
                  .contains(query.toLowerCase()) ||
              (child.childId?.contains(query) ?? false);
        }).toList();
      }
    });
  }

  Future<void> _handleChildSelection(
      String childId, String childNAME, String childPhone, int level) async {
    if (widget.event.id.isNotEmpty && childId.isNotEmpty) {
      final result = await AddPaymentDialog.show(
        context,
        childNAME: childNAME,
        childPhone: childPhone,
        level: level,
        childId: childId,
        eventId: widget.event.id,
      );
      if (result == true) {
        await _fetchTotalPriceAndPayments();
        setState(() {
          selectionMap[childId] = !(selectionMap[childId] ?? false);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ في البيانات المطلوبة")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCom(
        textAPP: "الي جاي",
        iconApp: Icons.search,
        onPressedApp: () async {
          final result = await showSearch(
            context: context,
            delegate: CustomSearchDelegate<ChildEvent>(
              childrenData: widget.CamingChildrenStream,
              onSearch: (query) => _filterChildren(query),
              toggleAttendance: (childId) async {
                await _handleChildSelection(childId, "", "", 1);
              },
              attendanceSelection: selectionMap,
            ),
          );
          if (result == null) {
            setState(() {
              filteredChildren = List.from(widget.CamingChildrenStream);
            });
          }
        },
      ),
      body: filteredChildren.isEmpty
          ? const Center(child: Text('لا يوجد أطفال مسجلون.'))
          : ListView.builder(
              itemCount: filteredChildren.length,
              itemBuilder: (context, index) {
                var child = filteredChildren[index];
                double remainingAmount =
                    remainingAmountMap[child.childId ?? ""] ?? 0.0;

                return CustomCardListTile(
                  numCH: remainingAmount,
                  name: child.childNAME ?? "غير معروف",
                  phone: child.childphone ?? "غير معروف",
                  id: child.childId ?? "N/A",
                  icon: Icons.add_box_sharp,
                  iconFunction: () async {
                    await _handleChildSelection(
                      child.childId ?? "",
                      child.childNAME ?? "",
                      child.childphone ?? "",
                      child.level ?? 0,
                    );
                  },
                );
              },
            ),
    );
  }
}

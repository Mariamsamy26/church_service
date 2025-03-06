import 'package:church/model/child.dart';
import 'package:church/shared/components/appBar.dart';
import 'package:flutter/material.dart';
import '../../model/event.dart';
import '../../shared/components/customSearchDelegate.dart';
import '../../shared/components/custom_CustomCardListTile.dart';
import 'addPaynentDialog.dart';

class SelectedToCamingScreen extends StatefulWidget {
  final EventModel event;
  final Stream<List<ChildData>> allChildrenStream;

  const SelectedToCamingScreen({
    super.key,
    required this.event,
    required this.allChildrenStream,
  });

  @override
  SelectedToCamingScreenState createState() => SelectedToCamingScreenState();
}

class SelectedToCamingScreenState extends State<SelectedToCamingScreen> {
  final TextEditingController searchController = TextEditingController();
  List<ChildData> filteredChildren = [];
  Map<String, bool> selectionMap = {};

  @override
  void initState() {
    super.initState();
    _initializeSelectionMap();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _initializeSelectionMap() {
    for (var child in widget.event.children) {
      selectionMap[child.childId] = true;
    }
  }

  void _filterChildren(String query, List<ChildData> allChildren) {
    setState(() {
      if (query.isEmpty) {
        filteredChildren = List.from(allChildren);
      } else {
        filteredChildren = allChildren
            .where((child) =>
                child.name!.toLowerCase().contains(query.toLowerCase()) ||
                child.id!.contains(query))
            .toList();
      }
    });
  }

  void _toggleSelection(String childId) {
    setState(() {
      selectionMap[childId] = !(selectionMap[childId] ?? false);
    });
  }

  Future<void> _handleChildSelection(String childId) async {
    if (childId != null && widget.event.id != null) {
      final result = await AddPaymentDialog.show(
        context,
        childId: childId,
        eventId: widget.event.id,
      );
      if (result == true) {
        setState(() {
          _toggleSelection(childId);
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
        textAPP: "عيالنا",
        iconApp: Icons.search,
        onPressedApp: () async {
          final result = await showSearch(
            context: context,
            delegate: CustomSearchDelegate(
              childrenData: filteredChildren,
              onSearch: (query) => _filterChildren(query, filteredChildren),
              toggleAttendance: (childId) async {
                await _handleChildSelection(childId);
              },
              attendanceSelection: selectionMap,
            ),
          );

          if (result == null) {
            setState(() {
              filteredChildren = [];
            });
          }
        },
      ),
      body: StreamBuilder<List<ChildData>>(
        stream: widget.allChildrenStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا يوجد أطفال مسجلون.'));
          }

          final allChildren = snapshot.data!;
          if (filteredChildren.isEmpty || searchController.text.isEmpty) {
            filteredChildren = List.from(allChildren);
          }

          return ListView.builder(
            itemCount: filteredChildren.length,
            itemBuilder: (context, index) {
              var child = filteredChildren[index];
              bool isSelected = selectionMap[child.id ?? ""] ?? false;

              return CustomCardListTile(
                profileImage: child.imgUrl ?? "",
                name: child.name ?? "غير معروف",
                phone: child.phone ?? "غير معروف",
                id: child.id ?? "N/A",
                icon: isSelected
                    ? Icons.check_box
                    : Icons.check_box_outline_blank_rounded,
                iconFunction: () async {
                  await _handleChildSelection(child.id!);
                },
              );
            },
          );
        },
      ),
    );
  }
}

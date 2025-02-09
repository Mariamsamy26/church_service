import 'package:flutter/material.dart';

import '../../model/child.dart';
import 'custom_Card.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<ChildData> childrenData;
  final Function(String) onSearch;
  final Function(String) toggleAttendance;
  final Map<String, bool> attendanceSelection;

  CustomSearchDelegate({
    required this.childrenData,
    required this.onSearch,
    required this.toggleAttendance,
    required this.attendanceSelection,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        var filteredChildren = childrenData
            .where((child) =>
                child.name!.toLowerCase().contains(query.toLowerCase()) ||
                child.id!.contains(query))
            .toList();

        return ListView.builder(
          itemCount: filteredChildren.length,
          itemBuilder: (context, index) {
            var child = filteredChildren[index];
            bool isSelected = attendanceSelection[child.id ?? ""] ?? false;

            return CustomCard(
              profileImage: child.imgUrl ?? "",
              name: child.name ?? "Unknown",
              phone: child.phone ?? "Unknown",
              id: child.id ?? "N/A",
              icon: isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank_rounded,
              iconFunction: () {
                toggleAttendance(child.id ?? "");
                setState(() {});
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

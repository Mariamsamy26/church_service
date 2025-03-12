import 'package:flutter/material.dart';
import '../../model/child.dart';
import '../../model/childEvent.dart';
import 'custom_CustomCardListTile.dart';

class CustomSearchDelegate<T> extends SearchDelegate {
  final List<T> childrenData;
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
        var filteredChildren = childrenData.where((child) {
          if (child is ChildData) {
            return (child.name?.toLowerCase().contains(query.toLowerCase()) ??
                    false) ||
                (child.id?.contains(query) ?? false);
          } else if (child is ChildEvent) {
            return (child.childNAME
                        ?.toLowerCase()
                        .contains(query.toLowerCase()) ??
                    false) ||
                (child.childId?.contains(query) ?? false);
          }
          return false;
        }).toList();

        return ListView.builder(
          itemCount: filteredChildren.length,
          itemBuilder: (context, index) {
            var child = filteredChildren[index];
            bool isSelected = false;
            String? childId;
            String? name;
            String? phone;
            String? profileImage;

            if (child is ChildData) {
              childId = child.id;
              name = child.name;
              phone = child.phone;
              profileImage = child.imgUrl;
            } else if (child is ChildEvent) {
              childId = child.childId;
              name = child.childNAME;
              phone = child.childphone;
              profileImage = null; // ChildEvent may not have an image
            }

            isSelected = attendanceSelection[childId ?? ""] ?? false;

            return CustomCardListTile(
              profileImage: profileImage ?? "",
              name: name ?? "Unknown",
              phone: phone ?? "Unknown",
              id: childId ?? "N/A",
              icon: isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank_rounded,
              iconFunction: () {
                toggleAttendance(childId ?? "");
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:church/layout/leveles/ChildrenAtt.dart';
import 'package:church/layout/leveles/childrenTrack.dart';
import 'package:church/shared/style/fontForm.dart';
import 'package:church/shared/components/appBar.dart';
import '../../Providers/children_provider.dart';
import '../../model/child.dart';
import 'FiltersBar.dart';
import 'childrenFind.dart';
import 'error.dart'; // Import the provider

class LeverScreen extends StatelessWidget {
  final int level;
  final String textLevel;
  final String gender;

  const LeverScreen({
    super.key,
    required this.level,
    required this.textLevel,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChildrenProvider(level: level, gender: gender),
      child: Scaffold(
        appBar: AppbarCom(
          textAPP: textLevel,
          iconApp: gender == "B" ? Icons.boy_outlined : Icons.girl_outlined,
          onPressedApp: () {},
        ),
        body: Consumer<ChildrenProvider>(
          builder: (context, childrenProvider, _) {
            return ListView(
              children: [
                FiltersBar(
                  onMonthChanged: (month) {
                    // Pass month directly to childrenProvider
                    childrenProvider.updateMonthFilter(month);
                  },
                ),
                StreamBuilder<List<ChildData>>(
                  stream: childrenProvider.childrenStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return ErrorPart(onPressed: () {
                        // Add logic to handle retries if needed
                      });
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No children data available",
                          style: FontForm.TextStyle50bold,
                        ),
                      );
                    }

                    var childrenData = snapshot.data;

                    // Check the selected month and show appropriate widget
                    if (childrenProvider.selectedMonth == "13") {
                      return ChildrenAtt(
                        onMonthChanged: (month) {
                          childrenProvider.updateMonthFilter(month);
                        },
                        childrenData: childrenData,
                      );
                    }

                    if (childrenProvider.selectedMonth == "14") {

                      return ChildrenTrack(
                        onMonthChanged: (day) {
                          // Pass the DateTime object for the selected day
                          childrenProvider.updateMonthFilter(day as String?);  // Ensure `day` is DateTime here
                        },
                        childrenData: childrenData,
                        day: childrenProvider.selectedDayTrack,  // Pass DateTime here
                      );

                    }

                    // Default ChildrenFind display
                    return ChildrenFind(childrenData: childrenData);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

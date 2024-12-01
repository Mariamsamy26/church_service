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
            return Column(
              children: [
                FiltersBar(
                  onMonthChanged: (month) {
                    // تحديث الشهر في المزود
                    childrenProvider.updateMonthFilter(month);
                  },
                ),
                Expanded(
                  child: StreamBuilder<List<ChildData>>(
                    stream: childrenProvider.childrenStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
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
                          initialDay: childrenProvider.selectedDayTrack,
                          onDayChanged: (DateTime day) {
                            childrenProvider.updateTrackingDate(day);
                          },
                          childrenData: childrenData,
                        );
                      }

                      // العرض الافتراضي
                      return ChildrenFind(childrenData: childrenData);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

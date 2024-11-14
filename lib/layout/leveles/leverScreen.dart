import 'package:church/layout/leveles/ChildrenAtt.dart';
import 'package:flutter/material.dart';
import 'package:church/shared/style/fontForm.dart';

import '../../shared/components/appBar.dart';
import '../../shared/firebase/firebase_function.dart';
import 'FiltersBar.dart';
import 'childrenFind.dart';
import 'error.dart';

class LeverScreen extends StatefulWidget {
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
  State<LeverScreen> createState() => _LeverScreenState();
}

class _LeverScreenState extends State<LeverScreen> {
  String selectedMonths = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCom(
        textAPP: widget.textLevel,
        iconApp:
            widget.gender == "B" ? Icons.boy_outlined : Icons.girl_outlined,
        onPressedApp: () {},
      ),
      body: ListView(
        children: [
          FiltersBar(
            onMonthChanged: (month) {
              setState(() {
                selectedMonths = month ?? '0';
              });
            },
          ),
          StreamBuilder(
            stream: selectedMonths == '0' || selectedMonths == '13'
                ? FirebaseService()
                    .getChildrenByLevelAndGender(widget.level, widget.gender)
                : FirebaseService().bDChildrenByLevelAndGender(
                    level: widget.level,
                    gender: widget.gender,
                    monthStr: selectedMonths,
                  ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return ErrorPart(onPressed: () {
                  setState(() {});
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
              if (selectedMonths == "13") {
                return ChildrenAtt(
                    onMonthChanged: (month) {
                      setState(() {
                        selectedMonths = month ?? '0';
                      });
                    },
                    childrenData: childrenData);
              }

              return ChildrenFind(childrenData: childrenData);
            },
          ),
        ],
      ),
    );
  }
}

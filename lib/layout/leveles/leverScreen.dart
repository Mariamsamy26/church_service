import 'package:flutter/material.dart';
import 'package:church/shared/style/fontForm.dart';

import '../../shared/components/appBar.dart';
import '../../shared/components/custom_Card.dart';
import '../childDetailsScreen.dart';
import '../../shared/firebase/firebase_function.dart';
import 'FiltersBar.dart';

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
            stream: selectedMonths == '0'
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
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Something went wrong "),
                      ElevatedButton(
                        onPressed: () {
                          print("kkk$snapshot.hasError");
                          setState(() {});
                        },
                        child: Text("Try again"),
                      ),
                    ],
                  ),
                );
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
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: childrenData?.length,
                itemBuilder: (context, index) {
                  var child = childrenData?[index];
                  return CustomCard(
                      profileImage: child!.imgUrl.toString(),
                      name: child.name!,
                      phone: child.phone,
                      id: child.id ?? "N/A",
                      icon: Icons.info_rounded,
                      iconFunction: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChildDetailsScreen(childData: child)),
                        );
                      });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

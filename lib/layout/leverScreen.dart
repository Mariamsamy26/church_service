import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';

import '../shared/components/appBar.dart';
import '../shared/components/custom_DropdownButtonFormField.dart';
import '../shared/dataApp.dart';
import 'infoScreen.dart';
import '../shared/firebase/firebase_function.dart';
import 'leveles/FiltersBar.dart'; // إضافة استيراد FirebaseService

class LeverScreen extends StatefulWidget {
  final int level;
  final String textLevel;
  final String genter;

  LeverScreen({
    required this.level,
    required this.textLevel,
    required this.genter,
  });

  @override
  State<LeverScreen> createState() => _LeverScreenState();
}

class _LeverScreenState extends State<LeverScreen> {
  get selectedMonths => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCom(
        textAPP: widget.textLevel,
        iconApp:
        widget.genter == "B" ? Icons.boy_outlined : Icons.girl_outlined,
        onPressedApp: () {},
      ),
      body: StreamBuilder(
        stream: FirebaseService()
            .getChildrenByLevelAndGender(widget.level, widget.genter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Something went wrong"),
                  ElevatedButton(
                    onPressed: () {
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

          return Column(
            children: [
               FiltersBar(),
              Expanded(
                child: ListView.builder(
                  itemCount: childrenData?.length,
                  itemBuilder: (context, index) {
                    var child = childrenData?[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: widget.genter == 'G'
                              ? Image.asset(
                            'assets/images/profileG.png',
                            width: 70,
                            height: 70,
                          )
                              : Image.asset(
                            'assets/images/profileB.png',
                            width: 70,
                            height: 70,
                          ),
                          title: Text(
                            child!.name!, // استخدام الاسم من البيانات
                            style: FontForm.TextStyle30bold,
                          ),
                          subtitle: Text(
                            (child!.bDay!).toString(),
                            // استخدام تاريخ الميلاد من البيانات
                            style: FontForm.TextStyle20bold,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => InfoScreen(child.id ?? "22"), // إرسال ID الطفل
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.info_rounded,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
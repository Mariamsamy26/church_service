import 'package:church/layout/events/eventsScreen.dart';
import 'package:church/shared/dataApp.dart';
import 'package:flutter/material.dart';

import '../model/child.dart';
import '../shared/components/custem_showDialog.dart';
import '../shared/components/appBar.dart';
import '../shared/components/custom_ElevatedButton.dart';
import '../shared/firebase/firebase_function.dart';
import 'addScreen.dart';
import 'allAttatScreen.dart';
import 'leveles/leverScreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  static const String routeName = 'Home Screen';

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String selectedGender = '';

  Future<List<ChildData>> fetchChildrenData(String gender) async {
    final stream = await FirebaseService().getChildrenByGender(gender);
    return await stream.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCom(
        textAPP: 'خدمه ثانوي ',
        iconApp: Icons.add,
        onPressedApp: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddScreen()),
          );
        },
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/images/back.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          ListView(
            children: [
              for (int i = 0; i < 3; i++)
                CustomElevatedButton(
                  text: DataApp.level[i],
                  OnPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => CustomShowDialog(
                        title: 'gender . . .',
                        frisIcon: Icons.girl_outlined,
                        firstText: DataApp.genter[0],
                        onFirstPressed: () {
                          selectedGender = "G";
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LeverScreen(
                                gender: selectedGender,
                                textLevel: DataApp.level[i],
                                level: i + 1,
                              ),
                            ),
                          );
                        },
                        secIcon: Icons.boy_outlined,
                        secondText: DataApp.genter[1],
                        onSecondPressed: () {
                          selectedGender = "B";
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LeverScreen(
                                gender: selectedGender,
                                textLevel: DataApp.level[i],
                                level: i + 1,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomElevatedButton(
                    width: MediaQuery.of(context).size.width * 0.45,
                    text: " أنشطة",
                    OnPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EventsScreen()),
                      );
                    },
                  ), //رحلات
                  CustomElevatedButton(
                    width: MediaQuery.of(context).size.width * 0.45,
                    text: "الحضور",
                    OnPressed: () async {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => CustomShowDialog(
                          title: 'gender . . .',
                          frisIcon: Icons.girl_outlined,
                          firstText: DataApp.genter[0],
                          onFirstPressed: () async {
                            selectedGender = "G";
                            List<ChildData> children =
                                await fetchChildrenData(selectedGender);
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChildrenallAtt(
                                  genter: selectedGender,
                                  childrenData: children,
                                ),
                              ),
                            );
                          },
                          secIcon: Icons.boy_outlined,
                          secondText: DataApp.genter[1],
                          onSecondPressed: () async {
                            selectedGender = "B";
                            List<ChildData> children =
                                await fetchChildrenData(selectedGender);
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChildrenallAtt(
                                  genter: selectedGender,
                                  childrenData: children,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ), //حضور
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

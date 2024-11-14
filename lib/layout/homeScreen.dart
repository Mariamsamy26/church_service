import 'package:church/shared/dataApp.dart';
import 'package:flutter/material.dart';

import '../shared/components/custem_showDialog.dart';
import '../shared/components/appBar.dart';
import '../shared/components/custom_ElevatedButton.dart';
import 'addScreen.dart';
import 'leveles/leverScreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  static const String routeName = 'Home Screen';

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String selectedGender = '';
  String levelGender = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarCom(
          textAPP: 'المراحل',
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
                  CustomElevatedButton(text:DataApp.level[i], OnPressed: ()async {
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
                                level: i+1,
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
                                level: i+1,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },),

              ],
            ),
          ],
        ));
  }
}

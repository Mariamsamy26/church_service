import 'package:church/shared/dataApp.dart';
import 'package:flutter/material.dart';

import '../shared/components/Custem_showDialog.dart';
import '../shared/components/appBar.dart';
import '../shared/components/categary.dart';
import 'addScreen.dart';
import 'leverScreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);
  static const String routeName = 'Home Screen';

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String selectedGender = '';

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
            Container(
              color: Colors.white30,
            ),
            Column(
              children: [
                for (int i = 0; i < 3; i++)
                  CustomIconBottom(
                    text: DataApp.level[i],
                    OnPressed: () async {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => CustomShowDialog(
                          title: 'gender . . .',
                          firstText: DataApp.genter[0],
                          secondText: DataApp.genter[1],
                          frisIcon: Icons.girl_outlined,
                          secIcon: Icons.boy_outlined,
                          onFirstPressed: () {selectedGender="G";},
                          onSecondPressed: () {selectedGender="B";},
                        ),
                      );

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LeverScreen(
                              textLevel: DataApp.level[i],
                              level: i + 1,
                              genter: selectedGender,
                            ),
                          ),
                        );
                      },

                    width: 300,
                    heightIcon: 150,
                    widthIcon: 150,
                    height: 150,
                    iconPath: '',
                  ),
              ],
            ),
          ],
        ));
  }
}

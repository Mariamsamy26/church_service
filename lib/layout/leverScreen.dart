import 'package:church/shared/style/color_manager.dart';
import 'package:church/shared/style/fontForm.dart';
import 'package:flutter/material.dart';

import '../shared/components/appBar.dart';
import 'infoScreen.dart';

class LeverScreen extends StatelessWidget {
  final int level;
  final String textLevel;
  final String genter;

  LeverScreen({
    required this.level,
    required this.textLevel,
    required this.genter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCom(
        textAPP: textLevel,
        iconApp:
        genter=="B"?Icons.boy_outlined:Icons.girl_outlined,
        onPressedApp: () {},
      ),

      body: ListView(
        children: [
          OverflowBar(
            children: [],
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: genter == 'G'
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
                  'mariam samy',
                  style: FontForm.TextStyle30bold,
                ),
                subtitle: Text(
                  "26-8-2002",
                  style: FontForm.TextStyle20bold,
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InfoScreen(genter //ID FROM PROV
                              ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.info_rounded,
                      size: 30,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

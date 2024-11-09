import 'package:flutter/material.dart';

import 'color_manager.dart';


class MyThemedata {
  static ThemeData litetheme = ThemeData(
    //scaffoldBackgroundColor: ColorManager.colorWhit,

    primaryColor: ColorManager.primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0.0,
    ),


    bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),

      )

  );

    static ThemeData darktheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    );

  }
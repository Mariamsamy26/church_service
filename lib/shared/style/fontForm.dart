import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_manager.dart';

class FontForm {
  static TextStyle TextStyle50bold = GoogleFonts.amiri(
    fontWeight: FontWeight.w400,
    fontSize: 50,
    color: ColorManager.scondeColor, // Replace with your actual color
  );
  static TextStyle TextStyle40bold = GoogleFonts.amiri(
    fontWeight: FontWeight.w400,
    fontSize: 40,
    color: ColorManager.scondeColor, // Replace with your actual color
  );
  static TextStyle TextStyle30bold = GoogleFonts.acme(
    fontWeight: FontWeight.w400,
    fontSize: 30,
    color: ColorManager.scondeColor, // Replace with your actual color
  );
  static TextStyle TextStyle20bold = GoogleFonts.acme(
    fontSize: 20,
    color: ColorManager.scondeColor, // Replace with your actual color
  );


}




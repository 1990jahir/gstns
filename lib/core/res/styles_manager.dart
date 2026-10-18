import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

TextStyle getRegularStyle({double fontSize = FontManager.s14, required Color color}) {
  return _getTextStyle(fontSize, FontWeight.w400, color);
}

TextStyle getMediumStyle({double fontSize = FontManager.s14, required Color color}) {
  return _getTextStyle(fontSize, FontWeight.w500, color);
}

TextStyle getSemiBoldStyle({double fontSize = FontManager.s14, required Color color}) {
  return _getTextStyle(fontSize, FontWeight.w600, color);
}

TextStyle getBoldStyle({double fontSize = FontManager.s14, required Color color}) {
  return _getTextStyle(fontSize, FontWeight.w700, color);
}

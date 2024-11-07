import 'package:flutter/material.dart';

class FontSelection extends ChangeNotifier {
  // List of available font families
  final List<String> _availableFonts = ['Regular', 'Cursive'];

  // Default font family
  String _selectedFont = 'Regular';

  // Get the current font family
  String get selectedFont => _selectedFont;

  // Get the list of available fonts
  List<String> get availableFonts => _availableFonts;

  // Set a new font family and notify listeners
  void setFontFamily(String fontFamily) {
    _selectedFont = fontFamily;
    notifyListeners();
  }

  // Get TextStyle with the selected font family
  TextStyle getTextStyle({
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: _selectedFont,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}

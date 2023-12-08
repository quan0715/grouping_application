import 'package:flutter/material.dart';
import 'package:grouping_project/core/theme/theme_entity.dart';

class ThemeManager with ChangeNotifier {
  // 這是 ViewModel
  // brightness 用來切換主題是Model
  AppTheme theme = AppTheme();
  Brightness get brightness => theme.brightness;
  IconData get icon => theme.themeIcon;
  Widget get coverLogo => theme.coverLogo;
  Color get colorSchemeSeed => theme.colorSchemeSeed;

  Widget get logo => coverLogo;
  void toggleTheme() {
    theme.toggleBrightness();
    notifyListeners();
  }
  void updateColorSchemeSeed(Color color) {
    theme.m3ColorSchemeSeed = color;
    notifyListeners();
  }
}

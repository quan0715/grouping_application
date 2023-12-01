import 'package:flutter/material.dart';

abstract class WithThemePrimaryColor {
  // final Color themePrimaryColor;
  Color get getThemePrimaryColor;
}

// TODO: check it this is ok
abstract class WithThemeSettingColor {
  Color get getTitleColor;
  Color get getTextBoxFillingColor;
  Color get getBackGroundColor;
}

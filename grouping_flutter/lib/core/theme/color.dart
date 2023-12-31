import 'package:flutter/material.dart';

class AppColor{
  static Color correct = const Color(0xFF4CAF50);
  static Color incorrect = Colors.red.shade400;
  
  static Color primary(BuildContext context) => Theme.of(context).colorScheme.primary; 
  static Color secondary(BuildContext context) => Theme.of(context).colorScheme.secondary;
  static Color tertiary(BuildContext context) => Theme.of(context).colorScheme.tertiary;
  static Color background(BuildContext context) => Theme.of(context).colorScheme.background;
  static Color primaryContainer(BuildContext context) => Theme.of(context).colorScheme.primaryContainer;
  static Color secondaryContainer(BuildContext context) => Theme.of(context).colorScheme.secondaryContainer;
  static Color tertiaryContainer(BuildContext context) => Theme.of(context).colorScheme.tertiaryContainer;
  static Color surface(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color error(BuildContext context) => Theme.of(context).colorScheme.error;
  static Color onPrimary(BuildContext context) => Theme.of(context).colorScheme.onPrimary;
  static Color onSecondary(BuildContext context) => Theme.of(context).colorScheme.onSecondary;
  static Color onTertiary(BuildContext context) => Theme.of(context).colorScheme.onTertiary;
  static Color onBackground(BuildContext context) => Theme.of(context).colorScheme.onBackground;
  static Color onSurface(BuildContext context) => Theme.of(context).colorScheme.onSurface;
  static Color onError(BuildContext context) => Theme.of(context).colorScheme.onError;
  static Color surfaceVariant(BuildContext context) => Theme.of(context).colorScheme.surfaceVariant;
  static Color onSurfaceVariant(BuildContext context) => Theme.of(context).colorScheme.onSurfaceVariant;
  static Color onPrimaryContainer(BuildContext context) => Theme.of(context).colorScheme.onPrimaryContainer;
  static Color onSecondaryContainer(BuildContext context) => Theme.of(context).colorScheme.onSecondaryContainer;
  static Color onTertiaryContainer(BuildContext context) => Theme.of(context).colorScheme.onTertiaryContainer;
  static Color brightness(BuildContext context) => Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.white : Colors.black;
  static ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
  

  // status color
  static Color completeColor = const Color(0xFF11AE3D);
  static Color inProgressColor = const Color(0xFF1C448D);
  static Color nonStartColor = const Color(0xFF656565);
  static Color pendingColor = const Color(0xFFC300E3);

  // log color
  static Color logSuccess = Colors.green;
  static Color logError = Colors.red;
  static Color logWarning = Colors.orange;
  static Color logInfo = Colors.blue;
  static Color logOthers = Colors.grey;

  // space color
  static Color mainSpaceColor = const Color(0xFF7D5800);
  static Color spaceColor1 = const Color(0xFF006874);
  static Color spaceColor2 = const Color(0xFF206FCC);
  static Color spaceColor3 = const Color(0xFFBF0707);
  static Color spaceColor4 = const Color(0xFFBF5F07);
  static Color spaceColor5 = const Color(0xFF4C4A4A);
  // colorScheme
  static Color onSurfaceColor = const Color(0xFF1E1E1E);
  static Color surfaceColor = const Color(0xFFE5E5E5);

  static getWorkspaceColorByIndex(int themeColor) {
    return switch(themeColor){
      1 => spaceColor1,
      2 => spaceColor2,
      3 => spaceColor3,
      4 => spaceColor4,
      5 => spaceColor5,
      _ => mainSpaceColor,
    };
  }

  static List<Color> spaceColors = [
    mainSpaceColor,
    spaceColor1,
    spaceColor2,
    spaceColor3,
    spaceColor4,
    spaceColor5,
  ];
}
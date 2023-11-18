import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppTheme{
  Brightness brightness = Brightness.light;
  IconData themeIcon = Icons.wb_sunny;
  Color colorSchemeSeed = Colors.amber;
  Widget coverLogo = SvgPicture.asset(
    "assets/images/logo_light.svg",
    semanticsLabel: 'Grouping Logo',
  );
  void toggleBrightness(){
    themeIcon = brightness == Brightness.light
        ? Icons.nightlight_round
        : Icons.wb_sunny;
    coverLogo = brightness == Brightness.light
        ? logoDark
        : logoLight;
    brightness =
        brightness == Brightness.light ? Brightness.dark : Brightness.light;
  }

  Widget logoLight = SvgPicture.asset(
    "assets/images/logo_light.svg",
    semanticsLabel: 'Grouping Logo',
  );

  Widget logoDark = SvgPicture.asset(
    "assets/images/logo_dark.svg",
    semanticsLabel: 'Grouping Logo',
  );



  set m3ColorSchemeSeed(Color color) {
    colorSchemeSeed = color;
  }
}

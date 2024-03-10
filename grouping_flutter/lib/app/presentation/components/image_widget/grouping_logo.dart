import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/theme_provider.dart';
// import 'package:grouping_project/VM/view_model_lib.dart';
import 'package:provider/provider.dart';

class GroupingLogo extends StatelessWidget {
  const GroupingLogo({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return themeManager.coverLogo;
      },
    );
  }
}

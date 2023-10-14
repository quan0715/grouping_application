import 'package:flutter/material.dart';
import 'package:grouping_project/View/theme/theme_manager.dart';
import 'package:grouping_project/config/assets.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme.dart';

class CoverView extends StatefulWidget {
  const CoverView({Key? key}) : super(key: key);

  @override
  State<CoverView> createState() => _CoverViewState();
}

class _CoverViewState extends State<CoverView> with TickerProviderStateMixin{

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
    controller.forward();
    // controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // build 3 second loading screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeManager>(
        builder: (context, themeManager, child) => BackGroundContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: themeManager.logo),
              const SizedBox(height: 100,),
              SizedBox(
                width: 250,
                child: LinearProgressIndicator(
                  value: controller.value,
                  minHeight: 5,
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}

class BackGroundContainer extends StatelessWidget {
  final Widget? child;
  const BackGroundContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: AppColor.surface(context),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            colorFilter: ColorFilter.mode(
                AppColor.surface(context).withOpacity(0.95), BlendMode.screen),
            image: const AssetImage(Assets.coverImagePath),
            fit: BoxFit.values[4]),
      ),
      child: child ?? const SizedBox.expand(),
    );
  }
}
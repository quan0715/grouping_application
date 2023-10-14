import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/auth/components/auth_layout.dart';
import 'package:grouping_project/View/components/app_elevated_button.dart';
import 'package:grouping_project/View/components/title_with_content.dart';
import 'package:grouping_project/View/theme/color.dart';
import 'package:grouping_project/View/theme/padding.dart';
import 'package:grouping_project/ViewModel/auth/sign_in_view_model.dart';
import 'package:grouping_project/config/assets.dart';
import 'package:provider/provider.dart';

class WelcomeView extends AuthLayoutInterface {
  const WelcomeView({Key? key}) : super(key: key);
  Widget getWelcomeAsset() => Image.asset(Assets.welcomeImagePath ,fit: BoxFit.values[4]);
  void goToLoginPage(BuildContext context) => Navigator.pushNamed(context, '/login');
  
  @override
  Widget getBuildLoginFrame(){
    return Consumer<RegisterViewModel>(
      builder: (context, signInManager, child) => Container(
          color: AppColor.surface(context),
          width: formWidth,
          child: Center(
              child: AppPadding.large(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleWithContent(
                    title: "張百寬, 您好\n歡迎加入 GROUPING！", 
                    content: "趕快加入或創立新的工作小組吧。"
                ),
                const Divider(thickness: 2),
                AppButton(
                  buttonType: AppButtonType.hightLight,
                  onPressed: () => goToLoginPage(context),
                  label: '前往工作區',
                ),
              ],
            ),
          )),
      ),
    );
  }

  @override
  Widget getInfoDisplayFrame(){
    return Consumer<RegisterViewModel>(
      builder: (context, signInManager, child) => Container(
        color: AppColor.surfaceVariant(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [getWelcomeAsset()],)
      ),
    );
  }  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: 
      (context) => RegisterViewModel(),
      child: super.build(context),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/auth/components/action_text_button.dart';
import 'package:grouping_project/View/app/auth/components/auth_layout.dart';
import 'package:grouping_project/View/app/auth/components/auth_text_form_field.dart';
import 'package:grouping_project/View/app/auth/pages/welcome_message_page_view.dart';
import 'package:grouping_project/View/components/app_elevated_button.dart';
import 'package:grouping_project/View/components/title_with_content.dart';
import 'package:grouping_project/View/theme/color.dart';
import 'package:grouping_project/View/theme/padding.dart';
import 'package:grouping_project/ViewModel/auth/sign_in_view_model.dart';
import 'package:provider/provider.dart';


class RegisterViewPage extends AuthLayoutInterface{
  RegisterViewPage({super.key});

  final textFormKey = GlobalKey<FormState>();

  Widget getSignUpAsset(){
    return Image.asset('assets/images/login.png', fit: BoxFit.values[4]);
  }

  void moveToLogin(BuildContext context) {
    debugPrint("前往登入畫面");
    Navigator.pushNamed(context, '/login');
  }

  void moveToWelcomePage(BuildContext context) {
    debugPrint("前往歡迎頁面");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WelcomeView()));
  }


  Widget _getInputForm(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, signInManager, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Form(
          key: textFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: AuthTextFormField(
                  hintText: "請輸入帳號名稱",
                  labelText: "輸入帳號名稱",
                  prefixIcon: const Icon(Icons.account_circle),
                  validator: signInManager.userNameValidator,
                  onChanged: (value) => signInManager.onUserNameChange(value!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: AuthTextFormField(
                  hintText: "請輸入常用信箱",
                  labelText: "輸入信箱",
                  prefixIcon: const Icon(Icons.email),
                  validator: signInManager.userNameValidator,
                  onChanged: (value) => signInManager.onEmailChange(value!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ProtectedTextFormField(
                  hintText: "請輸入密碼",
                  labelText: "你的密碼",
                  prefixIcon: const Icon(Icons.password),
                  validator: signInManager.passwordConfirmValidator,
                  onChanged: (value) => signInManager.onPasswordChange(value!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ProtectedTextFormField(
                  hintText: "確認密碼",
                  labelText: "再次密碼",
                  prefixIcon: const Icon(Icons.password),
                  validator: signInManager.passwordConfirmValidator,
                  onChanged: (value) => signInManager.onPasswordConfirmChange(value!),
                ),
              ),
              AppButton(
                buttonType: AppButtonType.hightLight,
                onPressed: () {
                  if (textFormKey.currentState!.validate()) {
                    signInManager.register();
                    debugPrint("註冊成功");
                    moveToWelcomePage(context);
                    // TODO: fix registwer flow 
                  }
                },
                label: '註冊',
              ),
              ActionTextButton(
                onPressed: () => moveToLogin(context),
                questionText: "已經有帳號了？",
                actionText: "點我登入",

              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget getBuildLoginFrame(){
    return Consumer<RegisterViewModel>(
      builder: (context, loginManager,child) => Container(
        color: AppColor.surface(context),
        width: formWidth,
        child: Center(
            child: AppPadding.large(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleWithContent(
                  title: "註冊 SignUp", content: "加入Grouping，註冊新的Grouping 帳號"),
              const Divider(thickness: 2),
              _getInputForm(context),
            ],
          ),
        )),
      ),
    );
  }

  @override
  Widget getInfoDisplayFrame(){
    return Consumer<RegisterViewModel>(
      builder: (context, value, child) => Container(
        color: AppColor.surfaceVariant(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [getSignUpAsset()],)
      ),
    );
  }  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<RegisterViewModel>(
      create: (context) => RegisterViewModel(),
      builder: (context, child) => super.build(context),
    ); 
  }

}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/auth/presentation/view_models/register_view_model.dart';
import 'package:grouping_project/auth/presentation/views/components/action_text_button.dart';
import 'package:grouping_project/auth/presentation/views/components/auth_layout.dart';
import 'package:grouping_project/auth/presentation/views/components/auth_text_form_field.dart';
import 'package:grouping_project/core/config/assets.dart';
import 'package:grouping_project/app/presentation/components/buttons/app_elevated_button.dart';
import 'package:grouping_project/app/presentation/components/data_display/app_log_message_card.dart';
import 'package:grouping_project/app/presentation/components/data_display/title_with_content.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/core/theme/padding.dart';
import 'package:provider/provider.dart';


class RegisterViewPage extends AuthLayoutInterface{
  RegisterViewPage({super.key});

  final textFormKey = GlobalKey<FormState>();

  Widget getRegisterAsset(){
    return Image.asset(Assets.loginImagePath, fit: BoxFit.values[4]);
  }

  void moveToLogin(BuildContext context) {
    debugPrint("前往登入畫面");
    context.go('/login');
    // Navigator.pushNamed(context, '/login');
  }

  void moveToUserPage(BuildContext context, int userId) {
    debugPrint("前往歡迎頁面");
    context.go('/user/$userId');
  }


  Widget _getInputForm(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, registerManager, child) => Padding(
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
                  validator: registerManager.userNameValidator,
                  onChanged: (value) => registerManager.onUserNameChange(value!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: AuthTextFormField(
                  hintText: "請輸入常用信箱",
                  labelText: "輸入信箱",
                  prefixIcon: const Icon(Icons.email),
                  validator: registerManager.userNameValidator,
                  onChanged: (value) => registerManager.onEmailChange(value!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ProtectedTextFormField(
                  hintText: "請輸入密碼",
                  labelText: "你的密碼",
                  prefixIcon: const Icon(Icons.password),
                  validator: registerManager.passwordConfirmValidator,
                  onChanged: (value) => registerManager.onPasswordChange(value!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ProtectedTextFormField(
                  obscureText: true,
                  hintText: "確認密碼",
                  labelText: "再次密碼",
                  prefixIcon: const Icon(Icons.password),
                  validator: registerManager.passwordConfirmValidator,
                  onChanged: (value) => registerManager.onPasswordConfirmChange(value!),
                ),
              ),
              AppButton(
                buttonType: AppButtonType.hightLight,
                onPressed: () async {
                  if (textFormKey.currentState!.validate()) {
                    await registerManager.register();
                    if(registerManager.userAccessToken.isNotEmpty){
                      debugPrint("註冊成功");
                      await Future.delayed(const Duration(seconds: 2), () => debugPrint("註冊成功，即將跳轉頁面"));
                      if(context.mounted){
                        moveToUserPage(context, registerManager.userId);
                      }
                    }
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
      builder: (context, registerManager,child) => Container(
        color: AppColor.surface(context),
        width: formWidth,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Center(
                child: AppPadding.medium(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleWithContent(
                      title: "註冊 Register", content: "加入Grouping，註冊新的Grouping 帳號"),
                  const Divider(thickness: 2),
                  _getInputForm(context),
                ],
              ),
            )),
            Align(
              alignment: const Alignment(0, -0.9),
              child: MessagesList(messageService: registerManager.messageService),
            )
          ],
        ),
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
          children: [
            getRegisterAsset()
          ],)
      ),
    );
  }  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterViewModel>(
      create: (context) => RegisterViewModel()..init(),
      builder: (context, child) => super.build(context),
    ); 
  }

}
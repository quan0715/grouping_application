import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/auth/components/action_text_button.dart';
import 'package:grouping_project/View/app/auth/components/auth_layout.dart';
import 'package:grouping_project/View/app/auth/components/auth_text_form_field.dart';
import 'package:grouping_project/View/app/auth/pages/welcome_message_page_view.dart';
import 'package:grouping_project/View/shared/components/app_elevated_button.dart';
import 'package:grouping_project/View/shared/components/components.dart';
import 'package:grouping_project/View/shared/components/state.dart';
import 'package:grouping_project/View/shared/components/title_with_content.dart';
import 'package:grouping_project/View/theme/color.dart';
import 'package:grouping_project/View/theme/padding.dart';
import 'package:grouping_project/ViewModel/auth/register_view_model.dart';
import 'package:grouping_project/ViewModel/message_service.dart';
import 'package:grouping_project/model/workspace/message_model.dart';
import 'package:provider/provider.dart';


class RegisterViewPage extends AuthLayoutInterface{
  RegisterViewPage({super.key});

  final MessageService messageService = MessageService();

  final textFormKey = GlobalKey<FormState>();

  Widget getRegisterAsset(){
    return Image.asset('assets/images/login.png', fit: BoxFit.values[4]);
  }

  void moveToLogin(BuildContext context) {
    debugPrint("前往登入畫面");
    Navigator.pushNamed(context, '/login');
  }

  void moveToWelcomePage(BuildContext context, RegisterViewModel signInManager) {
    debugPrint("前往歡迎頁面");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<RegisterViewModel>.value(
            value: signInManager,
            child: const WelcomeView())));
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
                onPressed: () async {
                  if (textFormKey.currentState!.validate()) {
                    await signInManager.register();
                    
                    if(signInManager.registerState == RegisterState.success){
                      debugPrint("註冊成功");
                      messageService.addMessage(MessageData.success(title: "註冊成功", message: "註冊成功，即將跳轉頁面"));
                      await Future.delayed(const Duration(seconds: 2), () => debugPrint("註冊成功，即將跳轉頁面"));
                      if(context.mounted){
                        moveToWelcomePage(context, signInManager);
                      }
                    }
                    else{
                      messageService.addMessage(MessageData.error(title: "註冊失敗", message: "伺服器錯誤請稍候再試"));
                      debugPrint("註冊失敗");
                    }
                    // TODO: fix register flow 
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
      builder: (context, loginManager,child) => Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            color: AppColor.surface(context),
            width: formWidth,
            child: Center(
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
          ),
          Align(
            alignment: Alignment.topCenter,
            child: MessagesList(messageService: messageService),
          ),
        ],
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
            // MessagesList(messageService: messageService),
            getRegisterAsset()
          ],)
      ),
    );
  }  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterViewModel>(
      create: (context) => RegisterViewModel(),
      builder: (context, child) => super.build(context),
    ); 
  }

}
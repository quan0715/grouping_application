import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grouping_project/View/app/auth/components/action_text_button.dart';
import 'package:grouping_project/View/app/auth/components/auth_layout.dart';
import 'package:grouping_project/View/app/auth/components/auth_text_form_field.dart';
import 'package:grouping_project/View/app/auth/components/third_party_login_button.dart';
import 'package:grouping_project/View/components/app_elevated_button.dart';
import 'package:grouping_project/View/components/title_with_content.dart';
import 'package:grouping_project/View/theme/theme.dart';
import 'package:grouping_project/View/theme/theme_manager.dart';
import 'package:grouping_project/ViewModel/auth/login_view_model.dart';
import 'package:grouping_project/config/assets.dart';
import 'package:grouping_project/service/auth/github_auth.dart';
import 'package:grouping_project/service/auth/google_auth.dart';
import 'package:grouping_project/service/auth/line_auth.dart';
import 'package:provider/provider.dart';

class WebLoginViewPage extends AuthLayoutInterface {
  WebLoginViewPage({Key? key}) : super(key: key);

  final LoginViewModel loginManager = LoginViewModel();

  final textFormKey = GlobalKey<FormState>();

  Widget get groupingIcon => Consumer<ThemeManager>(
      builder: (context, themeManager, child) => themeManager.logo);

  void moveToRegisterPage(BuildContext context) {
    debugPrint("前往註冊畫面");
    Navigator.pushNamed(context, '/register');
  }

  void moveToHome(BuildContext context) {
    debugPrint("前往主畫面");
    Navigator.pushNamed(context, '/');
  }

  Widget _getInputForm() {
    return Consumer<LoginViewModel>(
      builder: (context, loginManager, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Form(
          key: textFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: AuthTextFormField(
                  hintText: "請輸入帳號",
                  labelText: "你的帳號",
                  prefixIcon: const Icon(Icons.account_circle),
                  validator: loginManager.emailValidator,
                  onChanged: (value) => loginManager.updateEmail(value!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ProtectedTextFormField(
                  hintText: "請輸入密碼",
                  labelText: "你的密碼",
                  prefixIcon: const Icon(Icons.password),
                  validator: loginManager.passwordValidator,
                  onChanged: (value) => loginManager.updatePassword(value!),
                ),
              ),
              AppButton(
                buttonType: AppButtonType.hightLight,
                onPressed: () {
                  if (textFormKey.currentState!.validate()) {
                    loginManager.onFormPasswordLogin();
                    moveToHome(context);
                  }
                },
                label: '登入',
              ),
              ActionTextButton(
                onPressed: () => moveToRegisterPage(context),
                questionText: "沒有帳號密碼嗎？",
                actionText: "點我註冊",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getThirdPartyLabel(BuildContext context) {
    Widget divider = const Expanded(child: Divider(thickness: 2));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        divider,
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "第三方登入",
            textAlign: TextAlign.center,
            style: AppText.labelLarge(context).copyWith(
              color: AppColor.onSurface(context).withOpacity(0.5),
              // fontWeight: FontWeight.bold
            ),
          ),
        )),
        divider
      ],
    );
  }

  Widget _getThirdPartyLoginList(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ThirdPartyLoginButton(
            primaryColor: Colors.blue,
            icon: Image.asset(Assets.googleIconPath, fit: BoxFit.cover),
            onPressed: () async {
              GoogleAuth googleAuth = GoogleAuth();
              await googleAuth.initializeOauthPlatform();
              await googleAuth.informParameters();
              if(context.mounted){
                await googleAuth.showWindowAndListen(context);
              }
              if (!kIsWeb) {
                googleAuth.handleCodeAndGetProfile();
              }
            }),
        ThirdPartyLoginButton(
            primaryColor: Colors.purple,
            icon: Image.asset(Assets.gitHubIconPath, fit: BoxFit.cover),
            onPressed: () async {
              GitHubAuth gitHubAuth = GitHubAuth();
              await gitHubAuth.initializeOauthPlatform();
              await gitHubAuth.informParameters();
              if(context.mounted){
                await gitHubAuth.showWindowAndListen(context);
              }
              if (!kIsWeb) {
                gitHubAuth.handleCodeAndGetProfile();
              }
            }),
        ThirdPartyLoginButton(
            primaryColor: Colors.green,
            icon: Image.asset(Assets.lineIconPath, fit: BoxFit.cover),
            onPressed: () async {
              LineAuth lineAuth = LineAuth();
              await lineAuth.initializeOauthPlatform();
              await lineAuth.informParameters();
              if(context.mounted){
                await lineAuth.showWindowAndListen(context);
              }
              
              if (!kIsWeb) {
                lineAuth.handleCodeAndGetProfile();
              }
            }),
      ],
    );
  }

  @override
  Widget getBuildLoginFrame() {
    return Consumer<LoginViewModel>(
      builder: (context, loginManager, child) => Container(
        color: AppColor.surface(context),
        width: formWidth,
        child: Center(
            child: AppPadding.medium(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleWithContent(
                  title: "登入 Login", content: "利用Email 登入或第三方登入"),
              const Divider(thickness: 2),
              _getInputForm(),
              _getThirdPartyLabel(context),
              _getThirdPartyLoginList(context)
            ],
          ),
        )),
      ),
    );
  }

  @override
  Widget getInfoDisplayFrame() {
    return Consumer<LoginViewModel>(
      builder: (context, value, child) => Container(
          color: AppColor.surfaceVariant(context),
          child: Column(
            children: [Expanded(child: groupingIcon)],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Uri.base.queryParametersAll.containsKey('code')) {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      storage
          .write(key: 'code', value: Uri.base.queryParameters['code'])
          .then((value) async {
        debugPrint((await storage.readAll()).toString());
        if (Uri.base.queryParametersAll.containsKey('scope')) {
          GoogleAuth googleAuth = GoogleAuth();
          await googleAuth.initializeOauthPlatform();
          await googleAuth.handleCodeAndGetProfile();
        } else if (Uri.base.queryParametersAll.containsKey('state')) {
          LineAuth lineAuth = LineAuth();
          await lineAuth.initializeOauthPlatform();
          await lineAuth.handleCodeAndGetProfile();
        } else {
          GitHubAuth gitHubAuth = GitHubAuth();
          await gitHubAuth.initializeOauthPlatform();
          await gitHubAuth.handleCodeAndGetProfile();
        }
      });
    }
    return ChangeNotifierProvider<LoginViewModel>.value(
      value: loginManager,
      child: super.build(context),
    );
  }
}

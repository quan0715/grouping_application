import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/auth/components/action_text_button.dart';
import 'package:grouping_project/View/app/auth/components/auth_layout.dart';
import 'package:grouping_project/View/app/auth/components/auth_text_form_field.dart';
import 'package:grouping_project/View/app/auth/components/third_party_login_button.dart';
import 'package:grouping_project/View/shared/components/app_elevated_button.dart';
import 'package:grouping_project/View/shared/components/state.dart';
import 'package:grouping_project/View/shared/components/title_with_content.dart';
import 'package:grouping_project/View/theme/theme.dart';
import 'package:grouping_project/View/theme/theme_manager.dart';
import 'package:grouping_project/ViewModel/auth/login_view_model.dart';
import 'package:grouping_project/config/assets.dart';
import 'package:grouping_project/service/auth/auth_helpers.dart';
import 'package:provider/provider.dart';

import 'package:webview_flutter/webview_flutter.dart';
import "package:universal_html/html.dart" as html;

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
    Navigator.pushNamed(context, '/workspace');
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
                  // obscureText: true,
                  hintText: "請輸入密碼",
                  labelText: "你的密碼",
                  prefixIcon: const Icon(Icons.password),
                  validator: loginManager.passwordValidator,
                  onChanged: (value) => loginManager.updatePassword(value!),
                ),
              ),
              AppButton(
                buttonType: AppButtonType.hightLight,
                onPressed: () async {
                  if (textFormKey.currentState!.validate()) {
                    await loginManager.onFormPasswordLogin();
                    if (context.mounted &&
                        loginManager.loginState == LoginState.loginSuccess) {
                      moveToHome(context);
                    }
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
            await loginManager
                .onThirdPartyLogin(AuthProvider.google)
                .whenComplete(() {
              showWindowAndListen(context, loginManager);
            });
          },
        ),
        ThirdPartyLoginButton(
          primaryColor: Colors.purple,
          icon: Image.asset(Assets.gitHubIconPath, fit: BoxFit.cover),
          onPressed: () async {
            await loginManager
                .onThirdPartyLogin(AuthProvider.github)
                .whenComplete(() {
              showWindowAndListen(context, loginManager);
            });
          },
        ),
        ThirdPartyLoginButton(
          primaryColor: Colors.green,
          icon: Image.asset(Assets.lineIconPath, fit: BoxFit.cover),
          onPressed: () async {
            await loginManager
                .onThirdPartyLogin(AuthProvider.line)
                .whenComplete(() {
              showWindowAndListen(context, loginManager);
            });
          },
        ),
      ],
    );
  }

  showWindowAndListen(BuildContext context, LoginViewModel loginVM) {
    if (kIsWeb) {
      // oAuthService.grant.close();
      html.window
          .open(loginVM.attemptedOauth.authorizationUrl.toString(), "_self");
    } else {
      WebViewController controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onWebResourceError: (WebResourceError error) {
              // TODO: Do some error handling
              debugPrint(
                  "===============================> onWebResourceError:");
              debugPrint(error.errorType.toString());
              debugPrint(error.errorCode.toString());
              debugPrint(error.description);
            },
            onUrlChange: (change) async {
              if (change.url!.contains("code")) {
                await loginManager
                    .addCodeToStorage(
                        code: Uri.dataFromString(change.url!)
                            .queryParameters['code']!)
                    .then((value) => Navigator.of(context).pop());
              }
            },
          ),
        )
        ..loadRequest(loginVM.attemptedOauth.authorizationUrl);

      // authWidgetNotifier.value = WebViewWidget(controller: controller);
      // oAuthService.grant.close();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return WebViewWidget(controller: controller);
          },
        ),
      );
    }
    loginVM.isLoading = false;
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
    return ChangeNotifierProvider<LoginViewModel>.value(
      value: loginManager..isURLContainCode(Uri.base),
      child: super.build(context),
    );
  }
}

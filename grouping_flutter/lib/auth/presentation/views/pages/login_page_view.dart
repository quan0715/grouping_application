import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/app/presentation/providers/token_manager.dart';
import 'package:universal_html/html.dart' as html;

import 'package:grouping_project/auth/presentation/view_models/login_view_model.dart';
import 'package:grouping_project/auth/presentation/views/components/action_text_button.dart';
import 'package:grouping_project/auth/presentation/views/components/auth_layout.dart';
import 'package:grouping_project/auth/presentation/views/components/auth_text_form_field.dart';
import 'package:grouping_project/auth/presentation/views/components/third_party_login_button.dart';
import 'package:grouping_project/auth/utils/auth_provider_enum.dart';
import 'package:grouping_project/core/config/assets.dart';
import 'package:grouping_project/app/presentation/components/buttons/app_elevated_button.dart';
import 'package:grouping_project/app/presentation/components/components.dart';
import 'package:grouping_project/app/presentation/components/data_display/title_with_content.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/core/theme/padding.dart';
import 'package:grouping_project/core/theme/text.dart';
import 'package:grouping_project/app/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebLoginViewPage extends AuthLayoutInterface {
  WebLoginViewPage({Key? key}) : super(key: key);

  final LoginViewModel loginManager = LoginViewModel();

  final textFormKey = GlobalKey<FormState>();

  Widget get groupingIcon => Consumer<ThemeManager>(
      builder: (context, themeManager, child) => themeManager.logo);

  void moveToRegisterPage(BuildContext context) {
    debugPrint("前往註冊畫面");
    GoRouter.of(context).go('/register');
  }

  void moveToHome(BuildContext context) async {
    debugPrint("前往主畫面");
    await Provider.of<TokenManager>(context, listen: false).updateToken();
    // GoRouter.of(context).go('/user/$userId');
  }

  Future onPasswordLogin(
      BuildContext context, LoginViewModel loginManager) async {
    if (textFormKey.currentState!.validate()) {
      await loginManager.onPasswordLogin();
      if (loginManager.userAccessToken.isNotEmpty) {
        debugPrint("登入成功, 前往主畫面, token: ${loginManager.userAccessToken}");
        if (context.mounted) {
          moveToHome(context);
        }
      }
    }
  }

  Future onThridPartyLogin(BuildContext context, LoginViewModel loginManager,
      AuthProvider provider) async {
    if (textFormKey.currentState!.validate()) {
      await loginManager.onThirdPartyLogin(provider);
    }
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
                  hintText: "請輸入註冊信箱",
                  labelText: "你的信箱",
                  prefixIcon: const Icon(Icons.email),
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
                onPressed: () async =>
                    await onPasswordLogin(context, loginManager),
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
          onPressed: () async => await loginManager
              .onThirdPartyLogin(AuthProvider.google)
              .whenComplete(() {
            showWindowAndListen(context, loginManager);
          }),
        ),
        ThirdPartyLoginButton(
          primaryColor: Colors.purple,
          icon: Image.asset(Assets.gitHubIconPath, fit: BoxFit.cover),
          onPressed: () async => await loginManager
              .onThirdPartyLogin(AuthProvider.github)
              .whenComplete(() {
            showWindowAndListen(context, loginManager);
          }),
        ),
        ThirdPartyLoginButton(
          primaryColor: Colors.green,
          icon: Image.asset(Assets.lineIconPath, fit: BoxFit.cover),
          onPressed: () async => await loginManager
              .onThirdPartyLogin(AuthProvider.line)
              .whenComplete(() {
            showWindowAndListen(context, loginManager);
          }),
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
                    .isURLContainCode(Uri.parse(change.url!))
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
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Center(
                child: AppPadding.medium(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MessagesList(messageService: loginManager.messageService),
                  const TitleWithContent(
                      title: "登入 Login", content: "利用Email 登入或第三方登入"),
                  const Divider(thickness: 2),
                  _getInputForm(),
                  _getThirdPartyLabel(context),
                  _getThirdPartyLoginList(context)
                ],
              ),
            )),
            Align(
              alignment: const Alignment(0, -0.9),
              child: MessagesList(messageService: loginManager.messageService),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget getInfoDisplayFrame() {
    return Consumer<LoginViewModel>(
      builder: (context, value, child) => Container(
          color: Colors.white,
          child: Column(
            children: [Expanded(child: groupingIcon)],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>.value(
      value: loginManager
        ..isURLContainCode(Uri.base).whenComplete(() {
          if (loginManager.userAccessToken.isNotEmpty) moveToHome(context);
        })
        ..init(),
      child: super.build(context),
    );
  }
}

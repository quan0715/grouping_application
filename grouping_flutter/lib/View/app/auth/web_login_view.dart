// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:html' as html;

// import 'package:grouping_project/View/app/auth/auth_view.dart';
// import 'package:grouping_project/View/theme/color.dart';
// import 'package:grouping_project/View/theme/padding.dart';
// import 'package:grouping_project/View/theme/text.dart';
// import 'package:grouping_project/View/theme/theme_manager.dart';
// import 'package:grouping_project/ViewModel/auth/login_view_model.dart';
// import 'package:grouping_project/service/auth/auth_service.dart';
// import 'package:grouping_project/service/auth/github_auth.dart';
// import 'package:grouping_project/service/auth/google_auth.dart';
// import 'package:grouping_project/service/auth/line_auth.dart';
// import 'package:provider/provider.dart';

// class WebLoginView extends StatefulWidget {
//   const WebLoginView({Key? key}) : super(key: key);

//   @override
//   State<WebLoginView> createState() => _WebLoginViewState();
// }

// class _WebLoginViewState extends State<WebLoginView> {
//   final String googleIconPath = "assets/icons/authIcon/google.png";
//   final String gitHubIconPath = "assets/icons/authIcon/github.png";
//   final String lineIconPath = "assets/icons/authIcon/line.png";

//   final LoginViewModel loginManager = LoginViewModel();

//   final textFormKey = GlobalKey<FormState>();

//   bool isPasswordVisible = true;

//   Widget getInputForm() {
//     return Consumer<LoginViewModel>(
//       builder: (context, loginManager, child) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         child: Form(
//           key: textFormKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5.0),
//                 child: TextFormField(
//                   decoration: const InputDecoration(
//                       hintText: "請輸入帳號",
//                       label: Text("輸入帳號"),
//                       prefixIcon: Icon(Icons.account_circle),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                           gapPadding: 10)),
//                   validator: loginManager.emailValidator,
//                   onChanged: (value) => loginManager.updateEmail(value),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5.0),
//                 child: TextFormField(
//                   obscureText: isPasswordVisible,
//                   decoration: InputDecoration(
//                       hintText: "請輸入密碼",
//                       suffixIcon: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             isPasswordVisible = !isPasswordVisible;
//                           });
//                         },
//                         icon: isPasswordVisible
//                             ? const Icon(Icons.visibility_off)
//                             : const Icon(Icons.visibility),
//                       ),
//                       prefixIcon: const Icon(Icons.password),
//                       label: const Text("輸入密碼"),
//                       border: const OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                           gapPadding: 10)),
//                   validator: loginManager.passwordValidator,
//                   onChanged: (value) => loginManager.updatePassword(value),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: ElevatedButton(
//                     onPressed: () {
//                       if (textFormKey.currentState!.validate()) {
//                         loginManager.onFormPasswordLogin();
//                         debugPrint("登入成功");
//                       }
//                     },
//                     style: buttonStyle,
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                             child: Text(
//                           "登入",
//                           textAlign: TextAlign.center,
//                         )),
//                       ],
//                     )),
//               ),
//               TextButton(
//                   onPressed: () {
//                     debugPrint("前往註冊畫面");
//                     Navigator.pushNamed(context, '/signIn');
//                   },
//                   child: Text(
//                     "沒有帳號密碼嗎？ 點我註冊",
//                     style: TextStyle(color: AppColor.secondary(context)),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget thirdPartyLabel() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Expanded(child: Divider(thickness: 2)),
//         Expanded(
//             child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Text(
//             "第三方登入",
//             textAlign: TextAlign.center,
//             style: AppText.labelLarge(context).copyWith(
//               color: AppColor.onSurface(context).withOpacity(0.5),
//               // fontWeight: FontWeight.bold
//             ),
//           ),
//         )),
//         const Expanded(child: Divider(thickness: 2)),
//       ],
//     );
//   }

//   Widget thirdPartyLoginList() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         thirdPartyLoginButton(
//             color: Colors.blue,
//             iconPath: googleIconPath,
//             onPressed: () async {
//               GoogleAuth googleAuth = GoogleAuth();
//               await googleAuth.initializeOauthPlatform();
//               await googleAuth.showWindowAndListen(context);
//               googleAuth.handleCodeAndGetProfile();
//             }),
//         thirdPartyLoginButton(
//             color: Colors.purple,
//             iconPath: gitHubIconPath,
//             onPressed: () async {
//               GitHubAuth gitHubAuth = GitHubAuth();
//               await gitHubAuth.initializeOauthPlatform();
//               await gitHubAuth.showWindowAndListen(context);
//               gitHubAuth.handleCodeAndGetProfile();
//             }),
//         thirdPartyLoginButton(
//             color: Colors.green,
//             iconPath: lineIconPath,
//             onPressed: () async {
//               LineAuth googleAuth = LineAuth();
//               await googleAuth.initializeOauthPlatform();
//               await googleAuth.showWindowAndListen(context);
//               googleAuth.handleCodeAndGetProfile();
//             }),
//       ],
//     );
//   }

//   Widget thirdPartyLoginButton(
//       {required Color color,
//       required String iconPath,
//       required VoidCallback onPressed}) {
//     return SizedBox(
//       width: 52,
//       child: AspectRatio(
//         aspectRatio: 1,
//         child: ElevatedButton(
//             onPressed: onPressed,
//             style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.all(4.0),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     side: BorderSide(color: color.withOpacity(0.3), width: 2))),
//             child: SizedBox.square(
//                 dimension: 28,
//                 child: Image.asset(iconPath, fit: BoxFit.cover))),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget loginFrame = Center(
//         child: AppPadding.large(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const TitleWithContent(
//               title: "登入 Login", content: "利用Email 登入或第三方登入"),
//           const Divider(thickness: 2),
//           getInputForm(),
//           thirdPartyLabel(),
//           thirdPartyLoginList()
//         ],
//       ),
//     ));
//     if (Uri.base.queryParameters.containsKey('code')) {
//       const storage = FlutterSecureStorage();

//       storage
//           .write(
//               key: 'auth-token-to-exchange',
//               value: Uri.base.queryParameters['code'])
//           .whenComplete(() => html.window.close());
//     }
//     return ChangeNotifierProvider.value(
//       value: loginManager,
//       child: Scaffold(
//         body: BackGroundContainer(
//           child: LayoutBuilder(
//               builder: (BuildContext context, BoxConstraints constraints) {
//             if (constraints.maxWidth > 650) {
//               return AuthViewFrame(
//                   child: Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: Center(
//                         child: Consumer<ThemeManager>(
//                       builder: (context, themeManager, child) =>
//                           themeManager.coverLogo,
//                     )),
//                   ),
//                   Expanded(
//                     flex: 4,
//                     child: loginFrame,
//                   ),
//                 ],
//               ));
//             } else {
//               return Container(
//                   color: AppColor.surface(context).withOpacity(0.5),
//                   child: loginFrame);
//             }
//           }),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:grouping_project/app/presentation/providers/token_manager.dart';
// import 'package:provider/provider.dart';

// class AppView extends StatelessWidget{
//   const AppView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TokenManager>(
//       builder: (context, loginManager, child) {
//         loginManager.checkLoginState();
//         if(loginManager.isInvalid){
//           debugPrint('loginManager.isInvalid');
//           context.go('/login');
//         }
//         else{
//           context.go('/user/${loginManager.tokenModel!.userId.toString()}');
//         }
//         return const Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//     // return const WorkspaceView();
//   }
// }
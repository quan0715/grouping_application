import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/auth/auth_view.dart';
import 'package:grouping_project/View/app/workspace/workspace_view.dart';

class AppView extends StatelessWidget{
  const AppView({Key? key}) : super(key: key);
  // TODO: check login state
  final bool isLogin = false;
  
  @override
  Widget build(BuildContext context) {
    if(isLogin){
      return const WorkspaceView();
    }
    else{
      return const AuthView();
    }
    // return const WorkspaceView();
  }
}
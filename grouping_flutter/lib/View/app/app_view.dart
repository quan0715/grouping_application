import 'package:flutter/material.dart';
import 'package:grouping_project/View/app/auth/auth_view.dart';

class AppView extends StatelessWidget{
  const AppView({Key? key}) : super(key: key);
  // TODO: check login state
  final bool isLogin = false;
  
  @override
  Widget build(BuildContext context) {
    if(isLogin){
      return const Scaffold(
        body: Text('Dashboard Page'),
      );
    }
    else{
      return const AuthView();
    }
  }
}
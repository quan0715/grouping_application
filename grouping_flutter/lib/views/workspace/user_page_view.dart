import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/components/grouping_app_bar.dart';


class UserPageView extends StatelessWidget {
  const UserPageView({super.key});
  

  Widget _buildBody(){
    return const Scaffold(
      appBar: GroupingAppBar(),
      body: Center(
        child: Text('User Page'),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) => _buildBody();

}
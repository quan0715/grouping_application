import 'package:flutter/material.dart';
import 'package:grouping_project/dashboard/domain/entities/user_profile_entity.dart';
import 'package:grouping_project/dashboard/presentation/views/components/mobile_app_bar.dart';
import 'package:grouping_project/dashboard/presentation/view_models/user_page_view_model.dart';
import 'package:grouping_project/dashboard/presentation/views/components/mobile_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';


class UserPageView extends StatelessWidget {
  const UserPageView({super.key});

  final themePrimaryColor = const Color(0xFF7D5800);
  // final themePrimaryColor = const Color(0xFF006874);
  
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => UserPageViewModel(),
    child: _buildBody()
  );

  Widget _buildBody(){
    return Consumer<UserPageViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        appBar: MobileAppBar(
          themePrimaryColor: themePrimaryColor,
          profile: UserProfileEntity(
            accountName: "Quan",
            profilePicPath: "",
          )
        ),
        body: const Center(
          child: Text('User Page'),
        ),
        bottomNavigationBar: MobileBottomNavigationBar(
          currentIndex: viewModel.currentPageIndex,
          themePrimaryColor: themePrimaryColor,
          // themePrimaryColor: const Color(0xFF006874),
          onTap: (index) => viewModel.updateCurrentIndex(index),
        )
      ),
    );
  }
}
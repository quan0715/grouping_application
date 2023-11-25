import 'package:flutter/material.dart';
import 'package:grouping_project/core/shared/color_widget_interface.dart';
import 'package:grouping_project/dashboard/domain/entities/space_profile_entity.dart';
import 'package:grouping_project/dashboard/presentation/views/components/color_card_widget.dart';
import 'package:grouping_project/dashboard/presentation/views/components/profile_avatar.dart';

class DrawerNavigationCard extends StatelessWidget implements WithThemePrimaryColor{
  // TODO: will be change at future
  // it should be SpaceNavigateEntity 
  final SpaceProfileEntity profile;
  final bool isSelected;
  
  const DrawerNavigationCard({
    super.key,
    required this.profile,
    this.isSelected = false,
  });

  final EdgeInsets _padding = const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 5,
  );

  @override
  Color get getThemePrimaryColor => profile.spaceColor;

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context){
    return InkWell(
      onTap: (){
        debugPrint("unimplemented yet, move to ${profile.spaceName} page");
      },
      child: ColorCardWidget(
        padding: _padding,
        color: getThemePrimaryColor,
        withALLBorder: true,
        child: Row(
          children: [
            ProfileAvatar(
              themePrimaryColor: getThemePrimaryColor,
              label: profile.spaceName,
            ),
            const SizedBox(width: 10,),
            Text(
              profile.spaceName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
            ),
            const Spacer(),
            showSelectedWidget,
          ],
        ),
      ),
    );
  }

  Widget get showSelectedWidget => 
    isSelected ? Icon(Icons.check, color: getThemePrimaryColor,) : const SizedBox.shrink();
}
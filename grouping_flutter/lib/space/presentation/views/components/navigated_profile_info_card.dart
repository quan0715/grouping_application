import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grouping_project/space/presentation/views/components/color_card_widget.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';

class NavigatedProfileInfoCardButton extends StatelessWidget{
  final bool isSelected;
  final Color primaryColor;
  final String? profileImageURL;
  final String profileName;
  final String routerPath;

  const NavigatedProfileInfoCardButton({
    super.key,
    required this.primaryColor,
    required this.profileName,
    required this.routerPath,
    this.profileImageURL,
    this.isSelected = false,
  });

  final EdgeInsets _padding = const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 5,
  );


  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context){
    return InkWell(
      onTap: (){
        GoRouter.of(context).go(routerPath);
      },
      child: ColorCardWidget(
        padding: _padding,
        color: primaryColor,
        withALLBorder: true,
        child: Row(
          children: [
            ProfileAvatar(
              themePrimaryColor: primaryColor,
              label: profileName,
              avatar: profileImageURL != null && profileImageURL!.isNotEmpty 
                ? Image.network(profileImageURL!) : null,
              avatarSize: 35,
            ),
            const Gap(5),
            Text(
              profileName,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold
              )
            ),
            const Spacer(),
            showSelectedWidget,
          ],
        ),
      ),
    );
  }

  Widget get showSelectedWidget => 
    isSelected ? Icon(Icons.check, color: primaryColor,) : const SizedBox.shrink();
}
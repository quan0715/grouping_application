import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
// import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';

class MemberWidget extends StatelessWidget {

  final Member profile;
  final bool isLeader;
  final Color themePrimaryColor;
  
  const MemberWidget({
    super.key,
    required this.profile,
    required this.themePrimaryColor,
    this.isLeader = false,
  });

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(
          avatarSize: 48,
          themePrimaryColor: themePrimaryColor,
          label: profile.userName,
          imageUrl: profile.photo?.imageUri ?? "",
        ),
        const Gap(10,),
        Text(
          profile.userName,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.bold
          )
        ),
        const Spacer(),
        showSelectedLeader,
      ],
    );
  }

  Widget get showSelectedLeader => Text(isLeader ? 'Group Leader' : 'member', style: const TextStyle(color: Colors.black54),);
}
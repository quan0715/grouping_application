import 'package:flutter/material.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/space/presentation/views/components/profile_avatar.dart';

class UserProfileChip extends StatelessWidget {
  
  final Member member;
  final VoidCallback? onPressed;
  final Color color;

  const UserProfileChip({
    Key? key,
    required this.member,
    this.color = Colors.black,
    this.onPressed, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      avatar: ProfileAvatar.circular(
        themePrimaryColor: color, 
        label: member.userName, 
        // avatarSize: 48,
        imageUrl: member.photo?.imageUri ?? '',
      ),
      onPressed: (){}, 
      label: Text(member.userName),
    );
  }
}
import 'package:flutter/material.dart';

class SpaceProfileEntity{
  final String spaceName;
  final String spacePhotoPicPath;
  final Color spaceColor;

  SpaceProfileEntity({
    required this.spaceName,
    required this.spacePhotoPicPath,
    required this.spaceColor,
  });

  @override
  bool operator==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SpaceProfileEntity &&
      other.spaceName == spaceName &&
      other.spacePhotoPicPath == spacePhotoPicPath &&
      other.spaceColor == spaceColor;
  }

  @override
  int get hashCode => spaceName.hashCode ^ spacePhotoPicPath.hashCode ^ spaceColor.hashCode;
}


class GroupSpaceProfileEntity extends SpaceProfileEntity{
  GroupSpaceProfileEntity({required super.spaceName, required super.spacePhotoPicPath, required super.spaceColor});
}

class UserSpaceProfileEntity extends SpaceProfileEntity{
  UserSpaceProfileEntity({required super.spaceName, required super.spacePhotoPicPath, required super.spaceColor});
}
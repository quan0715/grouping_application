import 'package:flutter/material.dart';
import 'package:grouping_project/dashboard/domain/entities/space_profile_entity.dart';

class UserPageViewModel extends ChangeNotifier{
  int currentPageIndex = 0;


  SpaceProfileEntity get selectedProfile => userProfiles.first;

  List<SpaceProfileEntity> get userProfiles => [
    UserSpaceProfileEntity(spaceName: "張百寬 的個人儀表板", spacePhotoPicPath: "",spaceColor: const Color(0xFF7D5800)),
  ];

  List<SpaceProfileEntity> get workspaceProfiles => [
    GroupSpaceProfileEntity(spaceName: "張百寬 的 workspace", spacePhotoPicPath: "", spaceColor: const Color(0xFFBF5F07)),
    GroupSpaceProfileEntity(spaceName: "Grouping 專題小組", spacePhotoPicPath: "", spaceColor: const Color(0xFF006874)),
    GroupSpaceProfileEntity(spaceName: "SEP Group", spacePhotoPicPath: "", spaceColor: const Color(0xFF206FCC)),
  ];

  void updateCurrentIndex(int index){
    currentPageIndex = index;
    notifyListeners();
  }

  Future<void> init() async{
    debugPrint("UserPageViewModel init");
  }
}
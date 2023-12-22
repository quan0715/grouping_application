import 'package:flutter/widgets.dart';
import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/presentation/provider/group_data_provider.dart';
import 'package:grouping_project/space/presentation/provider/user_data_provider.dart';

class SpaceViewModel extends ChangeNotifier {

  final messageService = MessageService();
  UserDataProvider? userDataProvider;
  GroupDataProvider? workspaceDataProvider;

  
  bool _isLoading = true;

  bool get isLoading => _isLoading 
    || (workspaceDataProvider?.isLoading ?? false)
    || (userDataProvider?.isLoading ?? false);
  
  UserEntity? get currentUser => userDataProvider!.currentUser;

  Color get userColor => AppColor.mainSpaceColor;

  String get rootPath
    => workspaceDataProvider == null ? 'user' : 'workspace';

  Color get spaceColor => (workspaceDataProvider?.color ?? userColor);

  Future<void> init() async {
    debugPrint("UserPageViewModel init");
    _isLoading = true;
    notifyListeners();
    if(userDataProvider!=null){
      await userDataProvider!.init();
    }
    if(workspaceDataProvider!=null){
      await workspaceDataProvider!.init();
    }
    _isLoading = false;
    notifyListeners();
  }

  void updateUser(UserDataProvider userProvider) {
    debugPrint("UserViewModel update userData");
    userDataProvider = userProvider;
    notifyListeners();
  }

  void updateGroup(GroupDataProvider workspaceProvider) {
    debugPrint("UserViewModel update workspaceData");
    workspaceDataProvider = workspaceProvider;
    notifyListeners();
  }

}

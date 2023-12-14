import 'package:flutter/material.dart';
import 'package:grouping_project/app/presentation/providers/message_service.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/user_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/user_remote_data_source.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/repositories/user_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/setting_entity.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/usecases/setting_usecases/update_setting_usercase.dart';
import 'package:grouping_project/space/domain/usecases/update_current_user.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';

class SettingPageViewModel extends ChangeNotifier {
  SettingPageViewModel({this.dashboardColor = Colors.white});

  // This is prepared for future update of color changes
  // UserSpaceViewModel _viewModel = UserSpaceViewModel();
  UserDataProvider? userDataProvider;
  MessageService messageService = MessageService();
  // UserEntity? currentUser;
  bool isNightView = false;
  bool isAddingNewTag = false;
  int indexOfEditingTag = -1;

  Color dashboardColor;

  String firstEditedFiled = "";
  String secondEditedFiled = "";

  UserEntity get currentUser => userDataProvider!.currentUser!;

  UserTagModel getTagByIndex(int index){
    return userTags[index];
  }

  List<UserTagModel> get userTags => currentUser.tags;

  bool get isValidToAddNewTag => userTags.length + 1 <= 4;
  
  bool get isEditingExistingTag => (indexOfEditingTag != -1); 

  bool tagIsEdited(int index){
    // int index = currentUser.tags.indexOf(tag);
    return index != -1 && (index == indexOfEditingTag);
  }
  


  void onEditPressed(int index) {
    firstEditedFiled = userTags[index].title;
    secondEditedFiled = userTags[index].content;
    // isAddingNewTag = true;
    indexOfEditingTag = index;
    // debugPrint(firstEditedFiled);
    // debugPrint(secondEditedFiled);

    notifyListeners();
  }

  void cancelTagAdding() {
    isAddingNewTag = false;
    notifyListeners();
  }
  
  void cancelTagEditing() {
    indexOfEditingTag = -1;
    notifyListeners();
  }

  Future<void> onNightViewToggled(bool value) async {
    isNightView = value;
    UpdateSettingUseCase updateSettingUseCase = UpdateSettingUseCase(
        UserRepositoryImpl(
            remoteDataSource:
                UserRemoteDataSourceImpl(token: userDataProvider!.tokenModel.token),
            localDataSource: UserLocalDataSourceImpl()));

    final failureOrNull = await updateSettingUseCase(SettingEntity(
        isNightView: isNightView, dashboardColor: dashboardColor));

    failureOrNull.fold(
        (failure) => MessageService().addMessage(MessageData.error(message: failure.toString())),
        (void _r) {
      //TODO: change day view/ night view
    });

    notifyListeners();
  }

  Future<void> onColorSelected(Color color) async {
    dashboardColor = color;
    UpdateSettingUseCase updateSettingUseCase = UpdateSettingUseCase(
        UserRepositoryImpl(
            remoteDataSource:
                UserRemoteDataSourceImpl(token: userDataProvider!.tokenModel.token),
            localDataSource: UserLocalDataSourceImpl()));

    final failureOrNull = await updateSettingUseCase(SettingEntity(
        isNightView: isNightView, dashboardColor: dashboardColor));

    failureOrNull.fold(
        (failure) => messageService.addMessage(MessageData.error(message: failure.toString())),
        (void _r) {
      //TODO: change the background color
    });

    notifyListeners();
  }

  Future<void> onTagAddButtonPressed() async {
    isAddingNewTag = !isAddingNewTag;
    notifyListeners();
  }

  Future<void> onTagAddDone(String title, String content) async {
    debugPrint("add tag $title : $content");
    currentUser.tags.add(UserTagModel(title: title, content: content));

    isAddingNewTag = false;
    indexOfEditingTag = -1;

    UpdateUserUseCase updateUserUseCase = UpdateUserUseCase(UserRepositoryImpl(
        remoteDataSource:
            UserRemoteDataSourceImpl(token: userDataProvider!.tokenModel.token),
        localDataSource: UserLocalDataSourceImpl()));

    final failureOrUser = await updateUserUseCase(currentUser);

    failureOrUser.fold(
        (failure) => messageService.addMessage(MessageData.error(message: failure.toString())),
        (user) {
      debugPrint("Tag added to database");
    });

    notifyListeners();
  }

  Future<void> onTagDelete(int index) async {
    
    userTags.removeAt(index);
    indexOfEditingTag = -1;
    await updateUser(currentUser);
    notifyListeners();
  }

  set setFirstEditedFiled(String value) {
    firstEditedFiled = value;
    notifyListeners();
  }

  set setSecondEditedFiled(String value) {
    secondEditedFiled = value;
    notifyListeners();
  }

  Future<void> createNewTag() async {
    debugPrint("add tag $firstEditedFiled : $secondEditedFiled");
    isAddingNewTag = false;
    userTags.add(
      UserTagModel(title: firstEditedFiled, content: secondEditedFiled)
    );
    await updateUser(currentUser);
    notifyListeners();
  }

  Future<void> updateUserTag() async {
    debugPrint("add tag $firstEditedFiled : $secondEditedFiled");
    userTags[indexOfEditingTag] = UserTagModel(title: firstEditedFiled, content: secondEditedFiled);
    indexOfEditingTag = -1;
    await updateUser(currentUser);
    notifyListeners();
    
  }

  Future<void> updateUser(UserEntity userEntity) async{
    UpdateUserUseCase updateUserUseCase = UpdateUserUseCase(UserRepositoryImpl(
        remoteDataSource:UserRemoteDataSourceImpl(token:  userDataProvider!.tokenModel.token),
        localDataSource: UserLocalDataSourceImpl()));
    debugPrint(currentUser.toString());
    final failureOrUser = await updateUserUseCase(userEntity);

    failureOrUser.fold(
      (failure) => messageService
          .addMessage(MessageData.error(message: failure.toString())),
      (user) {
        debugPrint("Tag edited");
      }
    );
  }

  void update(UserDataProvider userDataProvider) {
    this.userDataProvider = userDataProvider;
    notifyListeners();
  }

  init() {
    firstEditedFiled = "";
    secondEditedFiled = "";
    isAddingNewTag = false;
    indexOfEditingTag = -1;
  }
}

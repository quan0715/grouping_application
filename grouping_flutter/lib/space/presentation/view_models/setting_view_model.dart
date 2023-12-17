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
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';
import 'package:image_picker/image_picker.dart';



class SettingPageViewModel extends ChangeNotifier {

  // user data for render this page
  // it will be auto update since it comes from proxyProvider
  UserDataProvider? userDataProvider;

  UserEntity get currentUser => userDataProvider!.currentUser!;

  List<UserTagEntity> get userTags => userDataProvider!.currentUser!.tags;

  UserTagEntity getTagByIndex(int index) => userTags[index];

  bool get isValidToAddNewTag 
    => userDataProvider!.currentUser!.tags.length + 1 <= 4;
  
  MessageService messageService = MessageService();
  
  UpdateSettingUseCase? updateSettingUseCase;
  
  int currentSectionIndex = 0;

  SettingEntity settingEntity = SettingEntity(isNightView: false, dashboardColor: Colors.white,);
  
  bool isAddingNewTag = false;
  bool isLoading = false;
  int indexOfEditingTag = -1;
  
  // Uint8List? tempAvatarData;

  
  
  void onSectionChange(int index) {
    // when user tap on navigationRail, change current section index by destination index
    currentSectionIndex = index;
    notifyListeners();
  }

  bool tagIsEdited(int index){
    // only one tag can be edited at a time
    return index != -1 && (index == indexOfEditingTag);
  }

  void clearFormState(){
    // clear either you are adding new tag or editing tag
    isAddingNewTag = false;
    indexOfEditingTag = -1;
    notifyListeners();
  }
  
  void onTagEdited(int index) {
    indexOfEditingTag = index;
    isAddingNewTag = false;
    notifyListeners();
  }


  Future<void> onNightViewToggled(bool value) async {

    final failureOrNull = await updateSettingUseCase!(settingEntity);

    failureOrNull.fold(
        (failure) => MessageService().addMessage(MessageData.error(message: failure.toString())),
        (void r) => debugPrint("night view changed, unimplemented"));

    notifyListeners();
  }

  Future<void> onColorSelected(Color color) async {
    // dashboardColor = color;
    final failureOrNull = await updateSettingUseCase!(settingEntity);

    failureOrNull.fold(
      (failure) => messageService.addMessage(MessageData.error(message: failure.toString())),
      (void r) => debugPrint("color changed, unimplemented")
    );
    
    notifyListeners();
  }

  Future<void> onTagAddButtonPressed() async {
    isAddingNewTag = !isAddingNewTag;
    notifyListeners();
  }

  Future<void> deleteUserTagByIndex(int index) async {
    // debugPrint("delete tag $index");
    userDataProvider!.currentUser!.tags.removeAt(index);
    await userDataProvider!.updateUser();
    clearFormState();
    // debugPrint("delete tag $tag done");
    notifyListeners();
  }

  Future<void> updateExistingTag(UserTagEntity tag, int index) async {
    // debugPrint("update tag $tag");
    userTags[index] = tag;
    await userDataProvider!.updateUser();
    indexOfEditingTag = -1;
    notifyListeners();
  }

  Future<void> createNewTag(UserTagEntity tag) async {
    // debugPrint("add tag $tag");
    if(userTags.length < 4){
      userTags.add(tag);
      await userDataProvider!.updateUser();
    } 
    isAddingNewTag = false;
    notifyListeners();
  }

  Future<void> updateUser(UserEntity userEntity) async{
    isLoading = true;
    notifyListeners();
    await userDataProvider!.updateUser();
    isLoading = false;
    notifyListeners();
  }

  void update(UserDataProvider userDataProvider) {
    this.userDataProvider = userDataProvider;
    updateSettingUseCase = UpdateSettingUseCase(
      UserRepositoryImpl(
          remoteDataSource:UserRemoteDataSourceImpl(token: userDataProvider.tokenModel.token),
          localDataSource: UserLocalDataSourceImpl()
      )
    );
    notifyListeners();
  }

  init() {
    isAddingNewTag = false;
  }

  void uploadAvatar(XFile file) async {
    debugPrint("upload avatar");
    debugPrint(file.path);
    // currentUser.photo!.data = file.path;
    var testRemote = UserRemoteDataSourceImpl(token: userDataProvider!.tokenModel.token);
    await testRemote.updateUserProfileImage(account: UserModel.fromEntity(currentUser),image: file);
    
    await updateUser(currentUser);
    // updateAvatar(await file.readAsBytes());
  }
  
  set userName(String value) {
    currentUser.name = value;
    notifyListeners();
  }

  set introduction(String value) {
    currentUser.introduction = value;
    notifyListeners();
  }

  void updateCurrentUserTag(UserTagEntity tag, int index) {
    userTags[index] = tag;
    notifyListeners();
  }
}

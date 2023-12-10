import 'package:flutter/material.dart';
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
  SettingPageViewModel(
      {required this.currentUser, this.dashboardColor = Colors.white});

  // This is prepared for future update of color changes
  late final UserPageViewModel _viewModel;
  UserEntity? currentUser;
  bool isNightView = false;
  bool onTagChanging = false;
  int? indexOfChangingTag;
  Color dashboardColor;

  String firstEditedFiled = "";
  String secondEditedFiled = "";

  void onEditPressed(int index) {
    firstEditedFiled = currentUser!.tags[index].title;
    secondEditedFiled = currentUser!.tags[index].content;

    onTagChanging = true;
    indexOfChangingTag = index;
    notifyListeners();
  }

  Future<void> onNightViewToggled(bool value) async {
    isNightView = value;
    UpdateSettingUseCase updateSettingUseCase = UpdateSettingUseCase(
        UserRepositoryImpl(
            remoteDataSource:
                UserRemoteDataSourceImpl(token: _viewModel.tokenModel.token),
            localDataSource: UserLocalDataSourceImpl()));

    final failureOrNull = await updateSettingUseCase(SettingEntity(
        isNightView: isNightView, dashboardColor: dashboardColor));

    failureOrNull.fold(
        (failure) => _viewModel.messageService
            .addMessage(MessageData.error(message: failure.toString())),
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
                UserRemoteDataSourceImpl(token: _viewModel.tokenModel.token),
            localDataSource: UserLocalDataSourceImpl()));

    final failureOrNull = await updateSettingUseCase(SettingEntity(
        isNightView: isNightView, dashboardColor: dashboardColor));

    failureOrNull.fold(
        (failure) => _viewModel.messageService
            .addMessage(MessageData.error(message: failure.toString())),
        (void _r) {
      //TODO: change the background color
    });

    notifyListeners();
  }

  Future<void> onTagAddPressed() async {
    onTagChanging = true;
    indexOfChangingTag = currentUser!.tags.length;
    notifyListeners();
  }

  Future<void> onTagAddDone(String title, String content) async {
    currentUser!.tags.add(UserTagModel(title: title, content: content));

    onTagChanging = false;
    indexOfChangingTag = null;

    UpdateUserUseCase updateUserUseCase = UpdateUserUseCase(UserRepositoryImpl(
        remoteDataSource:
            UserRemoteDataSourceImpl(token: _viewModel.tokenModel.token),
        localDataSource: UserLocalDataSourceImpl()));

    final failureOrUser = await updateUserUseCase(currentUser!);

    failureOrUser.fold(
        (failure) => _viewModel.messageService
            .addMessage(MessageData.error(message: failure.toString())),
        (user) {
      debugPrint("Tag added to database");
    });

    notifyListeners();
  }

  Future<void> onTagDelete(int index) async {
    currentUser!.tags.removeAt(index);
    onTagChanging = false;
    indexOfChangingTag = null;
    UpdateUserUseCase updateUserUseCase = UpdateUserUseCase(UserRepositoryImpl(
        remoteDataSource:
            UserRemoteDataSourceImpl(token: _viewModel.tokenModel.token),
        localDataSource: UserLocalDataSourceImpl()));

    final failureOrUser = await updateUserUseCase(currentUser!);

    failureOrUser.fold(
        (failure) => _viewModel.messageService
            .addMessage(MessageData.error(message: failure.toString())),
        (user) {
      debugPrint("Tag deleted");
    });

    notifyListeners();
  }

  void onEditingCancel() {
    onTagChanging = false;
    indexOfChangingTag = null;
    notifyListeners();
  }

  Future<void> onEditingDone() async {
    if (indexOfChangingTag != currentUser!.tags.length) {
      currentUser!.tags[indexOfChangingTag!] =
          UserTagModel(title: firstEditedFiled, content: secondEditedFiled);
    } else {
      currentUser!.tags.add(
          UserTagModel(title: firstEditedFiled, content: secondEditedFiled));
    }

    onTagChanging = false;
    indexOfChangingTag = null;

    UpdateUserUseCase updateUserUseCase = UpdateUserUseCase(UserRepositoryImpl(
        remoteDataSource:
            UserRemoteDataSourceImpl(token: _viewModel.tokenModel.token),
        localDataSource: UserLocalDataSourceImpl()));

    final failureOrUser = await updateUserUseCase(currentUser!);

    failureOrUser.fold(
        (failure) => _viewModel.messageService
            .addMessage(MessageData.error(message: failure.toString())),
        (user) {
      debugPrint("Tag edited");
    });

    notifyListeners();
  }

  void init(UserPageViewModel model) {
    _viewModel = model;
    currentUser = model.currentUser;
    notifyListeners();
  }
}
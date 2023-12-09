import 'package:flutter/material.dart';
import 'package:grouping_project/core/shared/message_entity.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/user_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/user_remote_data_source.dart';
import 'package:grouping_project/space/data/repositories/user_repository_impl.dart';
import 'package:grouping_project/space/domain/entities/setting_entity.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/usecases/setting_usecases/update_setting_usercase.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';

//TODO: make the setting VM
class SettingPageViewModel extends ChangeNotifier {
  SettingPageViewModel(
      {required this.currentUser,
      required String token,
      this.dashboardColor = Colors.white})
      : _token = token;

  late final UserPageViewModel _viewModel;
  String _token;
  UserEntity? currentUser;
  bool isNightView = false;
  Color dashboardColor;

  Future<void> onNightViewToggled(bool value) async {
    isNightView = value;
    UpdateSettingUseCase updateSettingUseCase = UpdateSettingUseCase(
        UserRepositoryImpl(
            remoteDataSource: UserRemoteDataSourceImpl(token: _token),
            localDataSource: UserLocalDataSourceImpl()));

    final failureOrNull = await updateSettingUseCase(SettingEntity(
        isNightView: isNightView, dashboardColor: dashboardColor));

    failureOrNull.fold(
        (failure) => _viewModel.messageService
            .addMessage(MessageData.error(message: failure.toString())),
        (void _r) {});

    notifyListeners();
  }

  void init(UserPageViewModel model) {
    _viewModel = model;
    currentUser = model.currentUser;
    notifyListeners();
  }
}

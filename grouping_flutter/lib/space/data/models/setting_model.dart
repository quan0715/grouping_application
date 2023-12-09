import 'package:grouping_project/space/domain/entities/setting_entity.dart';

class SettingModel {
  final bool _isNightView;
  final int _dashBoardColorInt;

  bool get isNightView => _isNightView;
  int get dashboardColorInt => _dashBoardColorInt;

  SettingModel({required bool isNightView, required int dashboardColorInt})
      : _isNightView = isNightView,
        _dashBoardColorInt = dashboardColorInt;

  factory SettingModel.fromEntity(SettingEntity entity) => SettingModel(
      isNightView: entity.isNightView,
      dashboardColorInt: entity.dashboardColor.value);
}

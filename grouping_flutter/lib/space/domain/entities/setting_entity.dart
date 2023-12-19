import 'package:flutter/cupertino.dart';
import 'package:grouping_project/space/data/models/setting_model.dart';

class SettingEntity {
  final bool _isNightView;
  final Color _dashboardColor;

  bool get isNightView => _isNightView;
  Color get dashboardColor => _dashboardColor;

  SettingEntity({required bool isNightView, required Color dashboardColor})
      : _isNightView = isNightView,
        _dashboardColor = dashboardColor;

  factory SettingEntity.fromModel(SettingModel model) => SettingEntity(
      isNightView: model.isNightView,
      dashboardColor: Color(model.dashboardColorInt));
}

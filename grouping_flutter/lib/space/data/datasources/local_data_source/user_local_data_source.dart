import 'package:grouping_project/core/shared/app_shared_data.dart';
import 'package:grouping_project/space/data/models/setting_model.dart';

abstract class UserLocalDataSource {
  Future<void>? cacheSetting(SettingModel settingModel);
  Future<SettingModel> getCacheSetting();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  @override
  Future<void>? cacheSetting(SettingModel settingModel) async {
    final sharedPreferences = AppSharedData.instance;

    await sharedPreferences.setValue(
        "Bool", 'isNightView', settingModel.isNightView);
    await sharedPreferences.setValue(
        "Int", "dashboardColorInt", settingModel.dashboardColorInt);
  }

  @override
  Future<SettingModel> getCacheSetting() async {
    final sharedPreferences = AppSharedData.instance;
    final isNightView =
        (await sharedPreferences.getAllWithPrefix(''))['isNightView'] ?? false;
    final dashboardColorInt =
        (await sharedPreferences.getAllWithPrefix(''))['dashboardColorInt'] ??
            4286404608;
    return SettingModel(
        isNightView: isNightView as bool,
        dashboardColorInt: dashboardColorInt as int);
  }
}

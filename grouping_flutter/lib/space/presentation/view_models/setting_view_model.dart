import 'package:flutter/foundation.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';

//TODO: make the setting VM
class SettingViewModel extends ChangeNotifier {
  final UserEntity currentUser;

  SettingViewModel({required this.currentUser});
}


import 'package:flutter/material.dart';

class ActivityFrameViewModel<T> extends ChangeNotifier {
  ActivityFrameViewModel({
    required this.activity,
  });

  final T activity;

  void init() {
    notifyListeners();
  }

}
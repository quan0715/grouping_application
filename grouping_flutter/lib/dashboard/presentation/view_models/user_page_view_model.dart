import 'package:flutter/material.dart';

class UserPageViewModel extends ChangeNotifier{
  int currentPageIndex = 0;

  void updateCurrentIndex(int index){
    currentPageIndex = index;
    notifyListeners();
  }

  Future<void> init() async{
    debugPrint("UserPageViewModel init");
  }
}
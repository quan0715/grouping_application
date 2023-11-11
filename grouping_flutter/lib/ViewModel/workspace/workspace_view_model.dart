import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grouping_project/ViewModel/message_service.dart';
import 'package:grouping_project/model/workspace/message_model.dart';

class WorkspaceViewModel extends ChangeNotifier{
  final MessageService _messageService = MessageService();
  MessageService get messageService => _messageService;

  @override
  void dispose() {
    _messageService.dispose();
    super.dispose();
  }

  void onPress() {
    // for testing purpose
    // it will be remove in next version
    final messages = [
      MessageData.success(),
      MessageData.error(),
      MessageData.warning(),
    ];
    final index =  Random().nextInt(messages.length);
    _messageService.addMessage(messages[index]); 
  }
}
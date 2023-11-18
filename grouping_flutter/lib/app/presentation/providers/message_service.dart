import 'dart:async';

import 'package:grouping_project/core/message_model.dart';

class MessageService {
  final StreamController<List<MessageData>> _messageController = StreamController<List<MessageData>>.broadcast();
  Stream<List<MessageData>> get messageStream => _messageController.stream;
  int autoClearDuration = 10;

  final List<MessageData> _messages = [];
  List<MessageData> get messages => _messages;

  void addMessage(MessageData message, {bool autoClear = true}) {
    _messages.add(message);
    _messageController.add(_messages);
    if (autoClear) {
      Timer(Duration(seconds: autoClearDuration), () {
      clearMessage(message);
    });
    }
  }

  void clearMessages() {
    _messages.clear();
    _messageController.add(_messages);
  }

  void dispose() {
    _messageController.close();
  }
  
  void clearMessage(MessageData target) {
    _messages.remove(target);
    _messageController.add(_messages);
  }
}
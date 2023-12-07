import 'package:flutter/widgets.dart';

import '../../domains/entity/message_entity.dart';

class ThreadViewModel extends ChangeNotifier {
  String _threadTitle = "新MMIS Bot";
  String get threadTitle => _threadTitle;
  set threadTitle(String value) {
    _threadTitle = value;
    notifyListeners();
  }

  String _inputText = "";
  String get inputText => _inputText;
  set inputText(String value) {
    _inputText = value;
    notifyListeners();
  }
  bool get canSendMessage => _inputText.isNotEmpty;

  final List<MessageEntity> _messages = [
  ];

  List<MessageEntity> get messages => _messages;

  void addMessage(String message) {
    _messages.add(MessageEntity(
      messageText: message,
      messageSender: MessageSender.user,
    ));
    _messages.add(MessageEntity(
      messageText: "學你講話 $message",
      messageSender: MessageSender.bot,
    ));
    _inputText = "";
    notifyListeners();
  }
}
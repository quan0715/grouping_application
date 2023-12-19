import 'package:flutter/widgets.dart';
import 'package:grouping_project/threads/data/repo/get_text_completions_repo_impl.dart';
import 'package:grouping_project/threads/domains/usecases/get_gpt_response.dart';

import '../../domains/entity/message_entity.dart';

class ThreadViewModel extends ChangeNotifier {
  
  String _inputText = "";
  final List<MessageEntity> _messages = [];
  String _replyMode = "一般模式";
  bool _isWaiting = false;

  String get inputText => _inputText;
  bool get canSendMessage => _inputText.isNotEmpty;
  bool get isWaiting => _isWaiting;
  String get replyMode => _replyMode;
  List<MessageEntity> get messages => _messages;

  set replyMode(String value) {
    _replyMode = value;
    notifyListeners();
  }

  set isWaiting(bool value) {
    // debugPrint("ThreadViewModel isWaiting $value");
    _isWaiting = value;
    notifyListeners();
  }

  set inputText(String value) {
    _inputText = value;
    notifyListeners();
  }


  void addMessage(String message) async {
    _messages.add(MessageEntity(
      messageText: message,
      messageSender: MessageSender.user,
    ));
    _inputText = "";
    

    var botResponse = await getBotReply(message);

    _messages.add(botResponse);
    
    notifyListeners();
  }

  Future<MessageEntity> getBotReply(String message) async {
    String response = "";
    isWaiting = true; 
      if(replyMode == "AI模式"){
        GetGptResponseUseCase getGptResponseUseCase = GetGptResponseUseCase(
        GptTextCompletionsRepoImpl()
      );
      // var response = "學你講話 $message";
      response = await getGptResponseUseCase(message);
    }else{
      response = "我是學人精 $message";
    }
    // await Future.delayed(const Duration(seconds: 3));
    
    isWaiting = false;

    return MessageEntity(
      messageText: response,
      messageSender: MessageSender.bot,
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grouping_project/threads/domains/repo/gpt_text_completions_repo.dart';
import 'package:http/http.dart' as http;
class GptTextCompletionsRepoImpl implements GptTextCompletionsRepo {

  String openAiApiKey = "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";

  @override
  Future<String> getGptTextCompletions({required String message}) async {
    var headers = {
      "Authorization": "Bearer $openAiApiKey" ,
      "Content-Type" : "application/json" 
    };
    var body = {
      "model": "gpt-3.5-turbo",
      "messages": [{"role": "user", "content": message}],
      "temperature": 0.7,
    };
    try{
      var response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: headers,
        body: jsonEncode(body),
        // encoding: const Utf8Codec()
      );
      // decode response with utf 8 codec
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint(jsonData.toString());

      return jsonData["choices"][0]["message"]["content"];
    }
    catch(e){
      debugPrint(e.toString());
    }
    return "Error";
  }
}
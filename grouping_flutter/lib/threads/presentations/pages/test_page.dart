import 'package:flutter/material.dart';
import 'package:grouping_project/threads/presentations/widgets/chat_thread_body.dart';

class TestTreadPage extends StatelessWidget {

  const TestTreadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Thread'),
      ),
      body: const Center(
        child: ChatThreadBody(
          threadTitle: "Test Bot",
        ),
      )
    );
  }
}
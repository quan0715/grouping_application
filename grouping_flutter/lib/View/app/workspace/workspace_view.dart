import 'package:flutter/material.dart';

class WorkspaceView extends StatelessWidget {
  const WorkspaceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('工作區')),
      body: const Center(
        child: Text('工作區'),
      ),
    );
  }
}
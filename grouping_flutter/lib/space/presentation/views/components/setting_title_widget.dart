import 'package:flutter/material.dart';

class SettingTitle extends StatelessWidget {
  final String title;
  final String content;

  const SettingTitle({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Text(content,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold))
        ]),
      ],
    );
  }
}

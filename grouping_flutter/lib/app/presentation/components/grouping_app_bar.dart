import 'package:flutter/material.dart';

class GroupingAppBar extends StatelessWidget implements PreferredSizeWidget{
  const GroupingAppBar({super.key});
  

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Grouping'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/user/1'),
          icon: const Icon(Icons.account_circle),
        ),
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
import 'package:flutter/material.dart';

class MobileBottomNavigationBar extends StatelessWidget {
  final Color themePrimaryColor;
  const MobileBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.themePrimaryColor,
    required this.onTap,
  }) : super(key: key);

  final int currentIndex;
  final Function(int) onTap;

  Widget getSelectedIcon(IconData icon) => Icon(
      icon,
      color: Colors.white,
  );

  Widget getUnselectedIcon(IconData icon) => Icon(
    icon,
    color: themePrimaryColor,
  );

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) => TextStyle(color: themePrimaryColor, fontWeight: FontWeight.bold)
        )
      ),
      child: NavigationBar(
        onDestinationSelected: onTap,
        indicatorColor: themePrimaryColor,
        selectedIndex: currentIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: getSelectedIcon(Icons.dashboard),
            icon: getUnselectedIcon(Icons.dashboard_outlined),
            label: '儀錶板'
          ),
          NavigationDestination(
            selectedIcon: getSelectedIcon(Icons.event),
            icon: getUnselectedIcon(Icons.event_outlined),
            label: '活動'
          ),
          NavigationDestination(
            selectedIcon: getSelectedIcon(Icons.message),
            icon: getUnselectedIcon(Icons.message_outlined),
            label: '訊息'
          ),
          NavigationDestination(
            selectedIcon: getSelectedIcon(Icons.settings),
            icon: getUnselectedIcon(Icons.settings_outlined),
            label: '設定'
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final List<Widget> actions;

  const HeaderBar({
    super.key,
    required this.title,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size(15, 56);
}

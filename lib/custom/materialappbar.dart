import 'package:flutter/material.dart';

class MaterialAppBar extends StatelessWidget {
  const MaterialAppBar({
    Key? key,
    required this.title,
    required this.actions,
  }) : super(key: key);

  final Widget title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: actions,
    );
  }
}

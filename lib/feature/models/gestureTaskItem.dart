import 'package:flutter/cupertino.dart';

class GestureTaskItem {
  final String title;
  final IconData icon;
  final Widget screen;
  bool completed;

  GestureTaskItem({
    required this.title,
    required this.icon,
    required this.screen,
    this.completed = false,
  });
}

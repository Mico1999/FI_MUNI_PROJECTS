import 'package:flutter/material.dart';

class BottomNavigationItem {
  final String label;
  final Icon icon;
  final Widget child;

  const BottomNavigationItem({
    required this.label,
    required this.icon,
    required this.child,
  });
}

import 'package:flutter/material.dart';

class DrawerItem {
  void Function() onTap;
  final String? title;
  final Icon icon;
  DrawerItem({required this.onTap, required this.icon, required this.title});
}

import 'package:flutter/material.dart';

class Activity {
  final DateTime time;
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const Activity({
    required this.time,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
  });
}

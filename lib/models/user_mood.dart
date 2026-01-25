import 'package:flutter/material.dart';

enum EmotionCategory { 
  peaceful, 
  messyMiddle, 
  overwhelmed, 
  searching, 
  grounded, 
  resilient 
}

class UserMood {
  final double systemLoad; // 0.0 to 1.0 (Stress)
  final double batteryLevel; // 0.0 to 1.0 (Energy)
  final double bandwidth; // 0.0 to 1.0 (Social/Focus capacity)
  final String? journalEntry;
  final DateTime timestamp;

  UserMood({
    this.systemLoad = 0.5,
    this.batteryLevel = 0.5,
    this.bandwidth = 0.5,
    this.journalEntry,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

final List<Map<String, dynamic>> systemStates = [
  {'label': 'NOMINAL', 'category': EmotionCategory.peaceful, 'icon': Icons.check_circle_outline},
  {'label': 'UNSTABLE', 'category': EmotionCategory.messyMiddle, 'icon': Icons.warning_amber_rounded},
  {'label': 'CRITICAL', 'category': EmotionCategory.overwhelmed, 'icon': Icons.error_outline},
  {'label': 'REBOOTING', 'category': EmotionCategory.searching, 'icon': Icons.restart_alt_rounded},
];

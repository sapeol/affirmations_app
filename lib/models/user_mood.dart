import 'package:flutter/material.dart';

enum EmotionCategory { 
  peaceful, 
  messyMiddle, // Progress with anxiety
  overwhelmed, 
  searching, 
  grounded, 
  resilient 
}

class UserMood {
  final EmotionCategory category;
  final String label;
  final String? journalEntry;
  final String? voiceNotePath;
  final DateTime timestamp;

  UserMood({
    required this.category,
    required this.label,
    this.journalEntry,
    this.voiceNotePath,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

// Fixed: Removed const from list that uses non-const IconData
final List<Map<String, dynamic>> emotionWheel = [
  {'label': 'Calm', 'category': EmotionCategory.peaceful, 'icon': Icons.self_improvement},
  {'label': 'Anxious-Progress', 'category': EmotionCategory.messyMiddle, 'icon': Icons.trending_up_rounded},
  {'label': 'Overwhelmed', 'category': EmotionCategory.overwhelmed, 'icon': Icons.waves_rounded},
  {'label': 'Searching', 'category': EmotionCategory.searching, 'icon': Icons.explore_outlined},
  {'label': 'Grounded', 'category': EmotionCategory.grounded, 'icon': Icons.park_rounded},
  {'label': 'Resilient', 'category': EmotionCategory.resilient, 'icon': Icons.shield_moon_outlined},
];
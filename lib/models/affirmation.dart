import 'user_preferences.dart';

class Affirmation {
  final String text;
  final String author;
  final bool isCustom;
  final AppFocus? focus;
  final SpiritualLeaning? leaning;
  final UserContext? context;
  final AffirmationTone? tone;

  Affirmation({
    required this.text, 
    this.author = "Unknown",
    this.isCustom = false,
    this.focus,
    this.leaning,
    this.context,
    this.tone,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'author': author,
    'isCustom': isCustom,
    'focus': focus?.name,
    'leaning': leaning?.name,
    'context': context?.name,
    'tone': tone?.name,
  };

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    return Affirmation(
      text: json['text'] as String? ?? "Unknown",
      author: json['author'] as String? ?? "Unknown",
      isCustom: json['isCustom'] is bool ? json['isCustom'] as bool : false,
      focus: json['focus'] != null ? AppFocus.values.byName(json['focus']) : null,
      leaning: json['leaning'] != null ? SpiritualLeaning.values.byName(json['leaning']) : null,
      context: json['context'] != null ? UserContext.values.byName(json['context']) : null,
      tone: json['tone'] != null ? AffirmationTone.values.byName(json['tone']) : null,
    );
  }
}

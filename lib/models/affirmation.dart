import 'user_preferences.dart';

class Affirmation {
  final String text;
  final String author;
  final bool isCustom;
  final DopePersona? persona;
  final DopeTone? tone;

  Affirmation({
    required this.text, 
    this.author = "Dopermations",
    this.isCustom = false,
    this.persona,
    this.tone,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'author': author,
    'isCustom': isCustom,
    'persona': persona?.name,
    'tone': tone?.name,
  };

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    return Affirmation(
      text: json['text'] as String? ?? "dope content loading",
      author: json['author'] as String? ?? "Dopermations",
      isCustom: json['isCustom'] is bool ? json['isCustom'] as bool : false,
      persona: json['persona'] != null ? DopePersona.values.byName(json['persona']) : null,
      tone: json['tone'] != null ? DopeTone.values.byName(json['tone']) : null,
    );
  }
}
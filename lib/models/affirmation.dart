import 'user_preferences.dart';

class Affirmation {
  final Map<DopeLanguage, String> localizedText;
  final String author;
  final bool isCustom;
  final DopePersona? persona;
  final DopeTone? tone;

  Affirmation({
    required String text, // Backward compatibility for initial data entry
    Map<DopeLanguage, String>? localizedText,
    this.author = "Dopermations",
    this.isCustom = false,
    this.persona,
    this.tone,
  }) : localizedText = localizedText ?? {DopeLanguage.en: text};

  String getText(DopeLanguage lang) {
    return localizedText[lang] ?? localizedText[DopeLanguage.en] ?? "Content unavailable";
  }

  Map<String, dynamic> toJson() => {
    'text': localizedText[DopeLanguage.en], // Store en as primary for custom ones
    'localizedText': localizedText.map((key, value) => MapEntry(key.name, value)),
    'author': author,
    'isCustom': isCustom,
    'persona': persona?.name,
    'tone': tone?.name,
  };

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    Map<DopeLanguage, String>? loc;
    if (json['localizedText'] != null) {
      loc = (json['localizedText'] as Map).map((key, value) => 
        MapEntry(DopeLanguage.values.byName(key), value as String));
    }
    
    return Affirmation(
      text: json['text'] as String? ?? "",
      localizedText: loc,
      author: json['author'] as String? ?? "Dopermations",
      isCustom: json['isCustom'] is bool ? json['isCustom'] as bool : false,
      persona: json['persona'] != null ? DopePersona.values.byName(json['persona']) : null,
      tone: json['tone'] != null ? DopeTone.values.byName(json['tone']) : null,
    );
  }
}

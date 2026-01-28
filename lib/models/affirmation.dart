import 'dart:convert';
import 'package:isar/isar.dart';
import 'user_preferences.dart';

part 'affirmation.g.dart';

@collection
class Affirmation {
  Id id = Isar.autoIncrement;

  @Index()
  final String author;
  
  final bool isCustom;
  
  @enumerated
  final DopePersona persona;

  // Isar needs properties to match constructor parameters
  final String localizedTextJson;

  @ignore
  Map<DopeLanguage, String> get localizedText {
    final Map<String, dynamic> decoded = jsonDecode(localizedTextJson);
    return decoded.map((key, value) => MapEntry(
      DopeLanguage.values.byName(key),
      value as String,
    ));
  }

  Affirmation({
    required this.localizedTextJson,
    this.author = "Delusions",
    this.isCustom = false,
    this.persona = DopePersona.general,
  });

  // Factory-like constructor for manual creation
  factory Affirmation.create({
    required String text,
    Map<DopeLanguage, String>? localizedText,
    String author = "Delusions",
    bool isCustom = false,
    DopePersona persona = DopePersona.general,
  }) {
    final map = localizedText ?? {DopeLanguage.en: text};
    return Affirmation(
      localizedTextJson: jsonEncode(map.map((key, value) => MapEntry(key.name, value))),
      author: author,
      isCustom: isCustom,
      persona: persona,
    );
  }

  String getText(DopeLanguage lang) {
    final map = localizedText;
    return map[lang] ?? map[DopeLanguage.en] ?? "Content unavailable";
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'localizedText': localizedText.map((key, value) => MapEntry(key.name, value)),
    'author': author,
    'isCustom': isCustom,
    'persona': persona.name,
  };

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    Map<DopeLanguage, String>? loc;
    if (json['localizedText'] != null) {
      loc = (json['localizedText'] as Map).map((key, value) => 
        MapEntry(DopeLanguage.values.byName(key), value as String));
    }
    
    final map = loc ?? {DopeLanguage.en: json['text'] as String? ?? ""};
    final aff = Affirmation(
      localizedTextJson: jsonEncode(map.map((key, value) => MapEntry(key.name, value))),
      author: json['author'] as String? ?? "Delusions",
      isCustom: json['isCustom'] is bool ? json['isCustom'] as bool : false,
      persona: json['persona'] != null ? DopePersona.values.byName(json['persona']) : DopePersona.general,
    );
    if (json['id'] != null) aff.id = json['id'] as int;
    return aff;
  }
}
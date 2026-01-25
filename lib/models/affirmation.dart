class Affirmation {
  final String text;
  final String author;
  final bool isCustom;

  Affirmation({
    required this.text, 
    this.author = "Unknown",
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'author': author,
    'isCustom': isCustom,
  };

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    return Affirmation(
      text: json['text'] as String? ?? "Unknown",
      author: json['author'] as String? ?? "Unknown",
      isCustom: json['isCustom'] is bool ? json['isCustom'] as bool : false,
    );
  }
}

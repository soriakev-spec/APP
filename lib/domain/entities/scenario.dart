enum ScenarioSection {
  phrases,
  questions,
  answers,
  comments,
  emotions,
  emergency,
  social,
}

class ScenarioPhrase {
  final String id;
  final String text;
  final ScenarioSection section;
  final bool isCustom;
  final String? profileId;

  const ScenarioPhrase({
    required this.id,
    required this.text,
    required this.section,
    required this.isCustom,
    this.profileId,
  });

  ScenarioPhrase copyWith({
    String? id,
    String? text,
    ScenarioSection? section,
    bool? isCustom,
    String? profileId,
  }) {
    return ScenarioPhrase(
      id: id ?? this.id,
      text: text ?? this.text,
      section: section ?? this.section,
      isCustom: isCustom ?? this.isCustom,
      profileId: profileId ?? this.profileId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScenarioPhrase &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ScenarioPhrase(id: $id, text: $text, section: $section)';
}

class Scenario {
  final String id;
  final String title;
  final String? imagePath;
  final String category;
  final List<ScenarioPhrase> phrases;

  const Scenario({
    required this.id,
    required this.title,
    this.imagePath,
    required this.category,
    required this.phrases,
  });

  Scenario copyWith({
    String? id,
    String? title,
    String? imagePath,
    String? category,
    List<ScenarioPhrase>? phrases,
  }) {
    return Scenario(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      phrases: phrases ?? this.phrases,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Scenario && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Scenario(id: $id, title: $title, category: $category, phrases: ${phrases.length})';
}

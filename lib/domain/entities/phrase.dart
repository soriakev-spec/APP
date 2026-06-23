enum AgeGroup {
  early,
  child,
  teen,
  adult,
}

enum PhraseLevel {
  oneWord,
  twoWords,
  phrase,
}

class Phrase {
  final String id;
  final String text;
  final String context; // Casa / Escuela / Doctor / etc.
  final String? subcategory;
  final AgeGroup ageGroup;
  final PhraseLevel level;
  final bool isFavorite;
  final int usageCount;
  final String? profileId; // nullable = global phrase
  final bool isCustom;
  final String? folderId;

  const Phrase({
    required this.id,
    required this.text,
    required this.context,
    this.subcategory,
    required this.ageGroup,
    required this.level,
    required this.isFavorite,
    required this.usageCount,
    this.profileId,
    required this.isCustom,
    this.folderId,
  });

  Phrase copyWith({
    String? id,
    String? text,
    String? context,
    String? subcategory,
    AgeGroup? ageGroup,
    PhraseLevel? level,
    bool? isFavorite,
    int? usageCount,
    String? profileId,
    bool? isCustom,
    String? folderId,
  }) {
    return Phrase(
      id: id ?? this.id,
      text: text ?? this.text,
      context: context ?? this.context,
      subcategory: subcategory ?? this.subcategory,
      ageGroup: ageGroup ?? this.ageGroup,
      level: level ?? this.level,
      isFavorite: isFavorite ?? this.isFavorite,
      usageCount: usageCount ?? this.usageCount,
      profileId: profileId ?? this.profileId,
      isCustom: isCustom ?? this.isCustom,
      folderId: folderId ?? this.folderId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Phrase && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Phrase(id: $id, text: $text, context: $context, ageGroup: $ageGroup)';
}

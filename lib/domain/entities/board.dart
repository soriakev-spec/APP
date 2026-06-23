enum VocabularyType {
  coreFirst,
  aphasia,
  als,
  blank,
  custom,
}

enum ExportFormat {
  obf,
  pdf,
  image,
  hablaJson,
}

class Board {
  final String id;
  final String name;
  final String? description;
  final String? profileId; // nullable = shared board
  final String? parentId;  // nullable = root board
  final bool isActive;
  final VocabularyType vocabularyType;
  final int buttonCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ExportFormat exportFormat;

  const Board({
    required this.id,
    required this.name,
    this.description,
    this.profileId,
    this.parentId,
    required this.isActive,
    required this.vocabularyType,
    required this.buttonCount,
    required this.createdAt,
    required this.updatedAt,
    required this.exportFormat,
  });

  Board copyWith({
    String? id,
    String? name,
    String? description,
    String? profileId,
    String? parentId,
    bool? isActive,
    VocabularyType? vocabularyType,
    int? buttonCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    ExportFormat? exportFormat,
  }) {
    return Board(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      profileId: profileId ?? this.profileId,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      vocabularyType: vocabularyType ?? this.vocabularyType,
      buttonCount: buttonCount ?? this.buttonCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      exportFormat: exportFormat ?? this.exportFormat,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Board && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Board(id: $id, name: $name, profileId: $profileId, isActive: $isActive)';
}

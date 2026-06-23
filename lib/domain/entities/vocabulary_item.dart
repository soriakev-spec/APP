import '../../core/theme/fitzgerald.dart';

export '../../core/theme/fitzgerald.dart' show FitzgeraldCategory;

enum SkinTone { light, mediumLight, medium, mediumDark, dark, defaultTone }

enum HairColor { black, brown, blonde, red, gray, white, defaultColor }

enum GrammarRole {
  noun, verb, adjective, adverb, pronoun, preposition,
  conjunction, interjection, article, other
}

class VocabularyItem {
  final String id;
  final String label;
  final String? message;
  final String? symbolPath;
  final String category;
  final String? subcategory;
  final FitzgeraldCategory fitzgeraldCategory;
  final SkinTone skinTone;
  final HairColor hairColor;
  final GrammarRole grammarRole;
  final String? linkedBoardId;
  final bool isCore;
  final int sortOrder;
  final int usageCount;
  final bool isFavorite;
  final String? profileId;

  const VocabularyItem({
    required this.id,
    required this.label,
    this.message,
    this.symbolPath,
    required this.category,
    this.subcategory,
    required this.fitzgeraldCategory,
    this.skinTone = SkinTone.defaultTone,
    this.hairColor = HairColor.defaultColor,
    this.grammarRole = GrammarRole.other,
    this.linkedBoardId,
    required this.isCore,
    required this.sortOrder,
    this.usageCount = 0,
    this.isFavorite = false,
    this.profileId,
  });

  VocabularyItem copyWith({
    String? id,
    String? label,
    String? message,
    String? symbolPath,
    String? category,
    String? subcategory,
    FitzgeraldCategory? fitzgeraldCategory,
    SkinTone? skinTone,
    HairColor? hairColor,
    GrammarRole? grammarRole,
    String? linkedBoardId,
    bool? isCore,
    int? sortOrder,
    int? usageCount,
    bool? isFavorite,
    String? profileId,
  }) {
    return VocabularyItem(
      id: id ?? this.id,
      label: label ?? this.label,
      message: message ?? this.message,
      symbolPath: symbolPath ?? this.symbolPath,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      fitzgeraldCategory: fitzgeraldCategory ?? this.fitzgeraldCategory,
      skinTone: skinTone ?? this.skinTone,
      hairColor: hairColor ?? this.hairColor,
      grammarRole: grammarRole ?? this.grammarRole,
      linkedBoardId: linkedBoardId ?? this.linkedBoardId,
      isCore: isCore ?? this.isCore,
      sortOrder: sortOrder ?? this.sortOrder,
      usageCount: usageCount ?? this.usageCount,
      isFavorite: isFavorite ?? this.isFavorite,
      profileId: profileId ?? this.profileId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabularyItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'VocabularyItem(id: $id, label: $label, category: $category, isCore: $isCore)';
}

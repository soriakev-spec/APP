// Board and vocabulary state providers for Habla AAC.
// Manages boards (tableros) and vocabulary items per profile.

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:habla/state/providers/profile_provider.dart';

// ---------------------------------------------------------------------------
// BoardEntity
// ---------------------------------------------------------------------------

class BoardEntity {
  final String id;
  final String name;
  final String? description;
  final String? profileId; // null = shared board
  final bool isActive;
  final String vocabularyType; // core_first, aphasia, als, blank, custom
  final int buttonCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BoardEntity({
    required this.id,
    required this.name,
    this.description,
    this.profileId,
    required this.isActive,
    required this.vocabularyType,
    required this.buttonCount,
    required this.createdAt,
    required this.updatedAt,
  });

  BoardEntity copyWith({
    String? id,
    String? name,
    Object? description = _boardSentinel,
    Object? profileId = _boardSentinel,
    bool? isActive,
    String? vocabularyType,
    int? buttonCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BoardEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description == _boardSentinel
          ? this.description
          : description as String?,
      profileId: profileId == _boardSentinel
          ? this.profileId
          : profileId as String?,
      isActive: isActive ?? this.isActive,
      vocabularyType: vocabularyType ?? this.vocabularyType,
      buttonCount: buttonCount ?? this.buttonCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profileId': profileId,
        'isActive': isActive,
        'vocabularyType': vocabularyType,
        'buttonCount': buttonCount,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory BoardEntity.fromJson(Map<String, dynamic> json) => BoardEntity(
        id: json['id'] as String,
        name: json['name'] as String,
        profileId: json['profileId'] as String?,
        isActive: json['isActive'] as bool,
        vocabularyType: json['vocabularyType'] as String,
        buttonCount: json['buttonCount'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'BoardEntity(id: $id, name: $name, profileId: $profileId, isActive: $isActive)';
}

const Object _boardSentinel = Object();

// ---------------------------------------------------------------------------
// VocabularyItemEntity
// ---------------------------------------------------------------------------

class VocabularyItemEntity {
  final String id;
  final String label;
  final String message;
  final String? symbolPath;
  final String category;
  final String? subcategory;

  /// Fitzgerald key color category:
  /// people, verbs, descriptors, nouns, social, function, navigation
  final String fitzgerald;
  final bool isCore;
  final int sortOrder;
  final int usageCount;
  final bool isFavorite;
  final String? profileId;
  final String? boardId;

  const VocabularyItemEntity({
    required this.id,
    required this.label,
    required this.message,
    this.symbolPath,
    required this.category,
    this.subcategory,
    required this.fitzgerald,
    required this.isCore,
    required this.sortOrder,
    required this.usageCount,
    required this.isFavorite,
    this.profileId,
    this.boardId,
  });

  VocabularyItemEntity copyWith({
    String? id,
    String? label,
    String? message,
    Object? symbolPath = _vocabSentinel,
    String? category,
    Object? subcategory = _vocabSentinel,
    String? fitzgerald,
    bool? isCore,
    int? sortOrder,
    int? usageCount,
    bool? isFavorite,
    Object? profileId = _vocabSentinel,
    Object? boardId = _vocabSentinel,
  }) {
    return VocabularyItemEntity(
      id: id ?? this.id,
      label: label ?? this.label,
      message: message ?? this.message,
      symbolPath: symbolPath == _vocabSentinel
          ? this.symbolPath
          : symbolPath as String?,
      category: category ?? this.category,
      subcategory: subcategory == _vocabSentinel
          ? this.subcategory
          : subcategory as String?,
      fitzgerald: fitzgerald ?? this.fitzgerald,
      isCore: isCore ?? this.isCore,
      sortOrder: sortOrder ?? this.sortOrder,
      usageCount: usageCount ?? this.usageCount,
      isFavorite: isFavorite ?? this.isFavorite,
      profileId: profileId == _vocabSentinel
          ? this.profileId
          : profileId as String?,
      boardId: boardId == _vocabSentinel ? this.boardId : boardId as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'message': message,
        'symbolPath': symbolPath,
        'category': category,
        'subcategory': subcategory,
        'fitzgerald': fitzgerald,
        'isCore': isCore,
        'sortOrder': sortOrder,
        'usageCount': usageCount,
        'isFavorite': isFavorite,
        'profileId': profileId,
        'boardId': boardId,
      };

  factory VocabularyItemEntity.fromJson(Map<String, dynamic> json) =>
      VocabularyItemEntity(
        id: json['id'] as String,
        label: json['label'] as String,
        message: json['message'] as String? ?? json['label'] as String,
        symbolPath: json['symbolPath'] as String?,
        category: json['category'] as String,
        subcategory: json['subcategory'] as String?,
        fitzgerald: json['fitzgerald'] as String? ?? 'nouns',
        isCore: json['isCore'] as bool? ?? false,
        sortOrder: json['sortOrder'] as int? ?? 0,
        usageCount: json['usageCount'] as int? ?? 0,
        isFavorite: json['isFavorite'] as bool? ?? false,
        profileId: json['profileId'] as String?,
        boardId: json['boardId'] as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabularyItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'VocabularyItemEntity(id: $id, label: $label, category: $category)';
}

const Object _vocabSentinel = Object();

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// The board currently active for the selected profile.
final activeBoardForProfileProvider = Provider<BoardEntity?>((ref) {
  final profileId = ref.watch(currentProfileIdProvider);
  final boards = ref.watch(boardsForCurrentProfileProvider);
  if (boards.isEmpty) return null;
  try {
    return boards.firstWhere(
      (b) => b.isActive && b.profileId == profileId,
    );
  } catch (_) {
    return boards.first;
  }
});

/// All boards belonging to the currently selected profile.
final boardsForCurrentProfileProvider =
    StateNotifierProvider<BoardsNotifier, List<BoardEntity>>((ref) {
  final profileId = ref.watch(currentProfileIdProvider);
  return BoardsNotifier(profileId: profileId);
});

/// Vocabulary items for the currently active board.
final vocabularyForActiveBoardProvider =
    StateNotifierProvider<VocabularyNotifier, List<VocabularyItemEntity>>((ref) {
  final board = ref.watch(activeBoardForProfileProvider);
  return VocabularyNotifier(board: board);
});

// ---------------------------------------------------------------------------
// BoardsNotifier
// ---------------------------------------------------------------------------

class BoardsNotifier extends StateNotifier<List<BoardEntity>> {
  final String? profileId;

  BoardsNotifier({required this.profileId}) : super(_seed(profileId));

  static List<BoardEntity> _seed(String? profileId) {
    if (profileId == null) return [];
    final now = DateTime.now();
    return [
      BoardEntity(
        id: const Uuid().v4(),
        name: 'Tablero Principal',
        profileId: profileId,
        isActive: true,
        vocabularyType: 'core_first',
        buttonCount: 15,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  Future<void> create(BoardEntity board) async {
    state = [...state, board];
  }

  Future<void> update(BoardEntity board) async {
    state = state.map((b) => b.id == board.id ? board : b).toList();
  }

  Future<void> delete(String id) async {
    state = state.where((b) => b.id != id).toList();
  }

  Future<void> duplicate(String id) async {
    final source = state.firstWhere((b) => b.id == id);
    final now = DateTime.now();
    final copy = source.copyWith(
      id: const Uuid().v4(),
      name: '${source.name} (copia)',
      isActive: false,
      createdAt: now,
      updatedAt: now,
    );
    state = [...state, copy];
  }

  Future<void> activate(String id) async {
    state = state
        .map((b) => b.copyWith(
              isActive: b.id == id,
              updatedAt: DateTime.now(),
            ))
        .toList();
  }

  Future<void> importFromJson(String jsonString) async {
    final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
    final imported = list
        .map((e) => BoardEntity.fromJson(e as Map<String, dynamic>))
        .toList();
    state = [...state, ...imported];
  }

  Future<String> exportToJson() async {
    return jsonEncode(state.map((b) => b.toJson()).toList());
  }
}

// ---------------------------------------------------------------------------
// VocabularyNotifier
// ---------------------------------------------------------------------------

class VocabularyNotifier extends StateNotifier<List<VocabularyItemEntity>> {
  final BoardEntity? board;

  VocabularyNotifier({required this.board}) : super([]);

  Future<void> add(VocabularyItemEntity item) async {
    state = [...state, item];
  }

  Future<void> update(VocabularyItemEntity item) async {
    state = state.map((v) => v.id == item.id ? item : v).toList();
  }

  Future<void> remove(String id) async {
    state = state.where((v) => v.id != id).toList();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final list = [...state];
    final item = list.removeAt(oldIndex);
    final adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    list.insert(adjustedIndex, item);
    // Reassign sortOrder values.
    state = list
        .asMap()
        .entries
        .map((e) => e.value.copyWith(sortOrder: e.key))
        .toList();
  }

  Future<void> toggleFavorite(String id) async {
    state = state
        .map((v) => v.id == id ? v.copyWith(isFavorite: !v.isFavorite) : v)
        .toList();
  }

  Future<void> incrementUsage(String id) async {
    state = state
        .map((v) =>
            v.id == id ? v.copyWith(usageCount: v.usageCount + 1) : v)
        .toList();
  }

  List<VocabularyItemEntity> search(String query) {
    if (query.isEmpty) return state;
    final lower = query.toLowerCase();
    return state
        .where((v) =>
            v.label.toLowerCase().contains(lower) ||
            v.message.toLowerCase().contains(lower) ||
            v.category.toLowerCase().contains(lower))
        .toList();
  }
}

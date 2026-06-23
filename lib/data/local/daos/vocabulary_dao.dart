import 'package:drift/drift.dart';

import '../app_database.dart';
import '../../../domain/entities/vocabulary_item.dart' as entity;

part 'vocabulary_dao.g.dart';

@DriftAccessor(tables: [VocabularyTable])
class VocabularyDao extends DatabaseAccessor<AppDatabase>
    with _$VocabularyDaoMixin {
  VocabularyDao(super.db);

  // ---------------------------------------------------------------------------
  // Mappers
  // ---------------------------------------------------------------------------

  entity.VocabularyItem _rowToEntity(VocabularyTableData row) {
    return entity.VocabularyItem(
      id: row.id,
      label: row.label,
      message: row.message,
      symbolPath: row.symbolPath,
      category: row.category,
      subcategory: row.subcategory,
      fitzgeraldCategory: entity.FitzgeraldCategory.values.firstWhere(
        (e) => e.name == row.fitzgeraldCategory,
        orElse: () => entity.FitzgeraldCategory.nouns,
      ),
      skinTone: entity.SkinTone.values.firstWhere(
        (e) => e.name == row.skinTone,
        orElse: () => entity.SkinTone.defaultTone,
      ),
      hairColor: entity.HairColor.values.firstWhere(
        (e) => e.name == row.hairColor,
        orElse: () => entity.HairColor.defaultColor,
      ),
      grammarRole: entity.GrammarRole.values.firstWhere(
        (e) => e.name == row.grammarRole,
        orElse: () => entity.GrammarRole.other,
      ),
      linkedBoardId: row.linkedBoardId,
      isCore: row.isCore,
      sortOrder: row.sortOrder,
      usageCount: row.usageCount,
      isFavorite: row.isFavorite,
      profileId: row.profileId,
    );
  }

  VocabularyTableCompanion _entityToCompanion(entity.VocabularyItem v) {
    return VocabularyTableCompanion(
      id: Value(v.id),
      label: Value(v.label),
      message: Value(v.message),
      symbolPath: Value(v.symbolPath),
      category: Value(v.category),
      subcategory: Value(v.subcategory),
      fitzgeraldCategory: Value(v.fitzgeraldCategory.name),
      skinTone: Value(v.skinTone.name),
      hairColor: Value(v.hairColor.name),
      grammarRole: Value(v.grammarRole.name),
      linkedBoardId: Value(v.linkedBoardId),
      isCore: Value(v.isCore),
      sortOrder: Value(v.sortOrder),
      usageCount: Value(v.usageCount),
      isFavorite: Value(v.isFavorite),
      profileId: Value(v.profileId),
    );
  }

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Watches all vocabulary items linked to [boardId], ordered by sortOrder.
  Stream<List<entity.VocabularyItem>> watchVocabularyForBoard(String boardId) {
    return (select(vocabularyTable)
          ..where((t) => t.linkedBoardId.equals(boardId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.sortOrder),
            (t) => OrderingTerm(expression: t.label),
          ]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Returns all vocabulary items for [profileId] (profile-specific + global).
  Future<List<entity.VocabularyItem>> getVocabularyForProfile(
    String profileId,
  ) async {
    final rows = await (select(vocabularyTable)
          ..where(
            (t) => t.profileId.equals(profileId) | t.profileId.isNull(),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
    return rows.map(_rowToEntity).toList();
  }

  /// Inserts a new vocabulary item.
  Future<void> insertVocabularyItem(entity.VocabularyItem item) async {
    await into(vocabularyTable).insert(_entityToCompanion(item));
  }

  /// Replaces an existing vocabulary item.
  Future<void> updateVocabularyItem(entity.VocabularyItem item) async {
    await (update(vocabularyTable)..where((t) => t.id.equals(item.id)))
        .write(_entityToCompanion(item));
  }

  /// Deletes a vocabulary item by UUID.
  Future<void> deleteVocabularyItem(String id) async {
    await (delete(vocabularyTable)..where((t) => t.id.equals(id))).go();
  }

  /// Full-text search across label and message fields for [profileId].
  Future<List<entity.VocabularyItem>> searchVocabulary(
    String query,
    String profileId,
  ) async {
    final pattern = '%${query.toLowerCase()}%';
    final rows = await (select(vocabularyTable)
          ..where(
            (t) =>
                (t.profileId.equals(profileId) | t.profileId.isNull()) &
                (t.label.lower().like(pattern) |
                    t.message.lower().like(pattern)),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.label)]))
        .get();
    return rows.map(_rowToEntity).toList();
  }

  /// Returns the [limit] most used items for [profileId].
  Future<List<entity.VocabularyItem>> getMostUsed(
    String profileId,
    int limit,
  ) async {
    final rows = await (select(vocabularyTable)
          ..where(
            (t) => t.profileId.equals(profileId) | t.profileId.isNull(),
          )
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.usageCount, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .get();
    return rows.map(_rowToEntity).toList();
  }

  /// Toggles the isFavorite flag for the item with [id].
  Future<void> toggleFavorite(String id) async {
    final item = await (select(vocabularyTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (item == null) return;
    await (update(vocabularyTable)..where((t) => t.id.equals(id)))
        .write(VocabularyTableCompanion(isFavorite: Value(!item.isFavorite)));
  }

  /// Increments usageCount by 1 for the item with [id].
  Future<void> incrementUsage(String id) async {
    await customUpdate(
      'UPDATE vocabulary SET usage_count = usage_count + 1 WHERE id = ?',
      variables: [Variable.withString(id)],
      updates: {vocabularyTable},
    );
  }
}

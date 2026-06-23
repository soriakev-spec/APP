import 'package:drift/drift.dart';

import '../app_database.dart';
import '../../../domain/entities/phrase.dart' as entity;

part 'phrase_dao.g.dart';

@DriftAccessor(tables: [PhrasesTable])
class PhraseDao extends DatabaseAccessor<AppDatabase> with _$PhraseDaoMixin {
  PhraseDao(super.db);

  // ---------------------------------------------------------------------------
  // Mappers
  // ---------------------------------------------------------------------------

  // Drift generates field names from the Dart getter name, not from .named().
  // So row.phraseText maps to the SQL column 'text', and
  // row.phraseContext maps to SQL column 'context'.
  entity.Phrase _rowToEntity(PhrasesTableData row) {
    return entity.Phrase(
      id: row.id,
      text: row.phraseText,
      context: row.phraseContext,
      subcategory: row.subcategory,
      ageGroup: entity.AgeGroup.values.firstWhere(
        (e) => e.name == row.ageGroup,
        orElse: () => entity.AgeGroup.child,
      ),
      level: entity.PhraseLevel.values.firstWhere(
        (e) => e.name == row.level,
        orElse: () => entity.PhraseLevel.phrase,
      ),
      isFavorite: row.isFavorite,
      usageCount: row.usageCount,
      profileId: row.profileId,
      isCustom: row.isCustom,
      folderId: row.folderId,
    );
  }

  PhrasesTableCompanion _entityToCompanion(entity.Phrase p) {
    return PhrasesTableCompanion(
      id: Value(p.id),
      phraseText: Value(p.text),
      phraseContext: Value(p.context),
      subcategory: Value(p.subcategory),
      ageGroup: Value(p.ageGroup.name),
      level: Value(p.level.name),
      isFavorite: Value(p.isFavorite),
      usageCount: Value(p.usageCount),
      profileId: Value(p.profileId),
      isCustom: Value(p.isCustom),
      folderId: Value(p.folderId),
    );
  }

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Watches all phrases for [profileId] (including global phrases).
  Stream<List<entity.Phrase>> watchPhrasesForProfile(String profileId) {
    return (select(phrasesTable)
          ..where(
            (t) => t.profileId.equals(profileId) | t.profileId.isNull(),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.phraseContext)]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Returns all phrases for [profileId] as a one-shot future.
  Future<List<entity.Phrase>> getPhrasesForProfile(String profileId) async {
    final rows = await (select(phrasesTable)
          ..where(
            (t) => t.profileId.equals(profileId) | t.profileId.isNull(),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.phraseContext)]))
        .get();
    return rows.map(_rowToEntity).toList();
  }

  /// Returns a phrase by UUID, or null if not found.
  Future<entity.Phrase?> getPhraseById(String id) async {
    final row = await (select(phrasesTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _rowToEntity(row);
  }

  /// Inserts a new phrase.
  Future<void> insertPhrase(entity.Phrase phrase) async {
    await into(phrasesTable).insert(_entityToCompanion(phrase));
  }

  /// Replaces an existing phrase row.
  Future<void> updatePhrase(entity.Phrase phrase) async {
    await (update(phrasesTable)..where((t) => t.id.equals(phrase.id)))
        .write(_entityToCompanion(phrase));
  }

  /// Deletes a phrase by UUID.
  Future<void> deletePhrase(String id) async {
    await (delete(phrasesTable)..where((t) => t.id.equals(id))).go();
  }

  /// Searches phrase text for [query], scoped to [profileId] + global.
  Future<List<entity.Phrase>> searchPhrases(
    String query,
    String profileId,
  ) async {
    final pattern = '%${query.toLowerCase()}%';
    final rows = await (select(phrasesTable)
          ..where(
            (t) =>
                (t.profileId.equals(profileId) | t.profileId.isNull()) &
                t.phraseText.lower().like(pattern),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.phraseText)]))
        .get();
    return rows.map(_rowToEntity).toList();
  }

  /// Returns all favorite phrases for [profileId].
  Future<List<entity.Phrase>> getFavorites(String profileId) async {
    final rows = await (select(phrasesTable)
          ..where(
            (t) =>
                (t.profileId.equals(profileId) | t.profileId.isNull()) &
                t.isFavorite.equals(true),
          )
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.usageCount,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();
    return rows.map(_rowToEntity).toList();
  }

  /// Returns the [limit] most-used phrases for [profileId].
  Future<List<entity.Phrase>> getMostUsed(
    String profileId,
    int limit,
  ) async {
    final rows = await (select(phrasesTable)
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

  /// Toggles the isFavorite flag for the phrase with [id].
  Future<void> toggleFavorite(String id) async {
    final row = await (select(phrasesTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;
    await (update(phrasesTable)..where((t) => t.id.equals(id)))
        .write(PhrasesTableCompanion(isFavorite: Value(!row.isFavorite)));
  }

  /// Increments usageCount by 1 for the phrase with [id].
  Future<void> incrementUsage(String id) async {
    await customUpdate(
      'UPDATE phrases SET usage_count = usage_count + 1 WHERE id = ?',
      variables: [Variable.withString(id)],
      updates: {phrasesTable},
    );
  }

  /// Returns all phrases belonging to [context] for [profileId].
  Future<List<entity.Phrase>> getPhrasesByContext(
    String context,
    String profileId,
  ) async {
    final rows = await (select(phrasesTable)
          ..where(
            (t) =>
                (t.profileId.equals(profileId) | t.profileId.isNull()) &
                t.phraseContext.equals(context),
          )
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.usageCount, mode: OrderingMode.desc),
          ]))
        .get();
    return rows.map(_rowToEntity).toList();
  }
}

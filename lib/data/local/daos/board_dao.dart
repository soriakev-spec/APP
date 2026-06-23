import 'package:drift/drift.dart';

import '../app_database.dart';
import '../../../domain/entities/board.dart' as entity;

part 'board_dao.g.dart';

@DriftAccessor(tables: [BoardsTable])
class BoardDao extends DatabaseAccessor<AppDatabase> with _$BoardDaoMixin {
  BoardDao(super.db);

  // ---------------------------------------------------------------------------
  // Mappers
  // ---------------------------------------------------------------------------

  entity.Board _rowToEntity(BoardsTableData row) {
    return entity.Board(
      id: row.id,
      name: row.name,
      description: row.description,
      profileId: row.profileId,
      parentId: row.parentId,
      isActive: row.isActive,
      vocabularyType: entity.VocabularyType.values.firstWhere(
        (e) => e.name == row.vocabularyType,
        orElse: () => entity.VocabularyType.coreFirst,
      ),
      buttonCount: row.buttonCount,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      exportFormat: entity.ExportFormat.values.firstWhere(
        (e) => e.name == row.exportFormat,
        orElse: () => entity.ExportFormat.hablaJson,
      ),
    );
  }

  BoardsTableCompanion _entityToCompanion(entity.Board b) {
    return BoardsTableCompanion(
      id: Value(b.id),
      name: Value(b.name),
      description: Value(b.description),
      profileId: Value(b.profileId),
      parentId: Value(b.parentId),
      isActive: Value(b.isActive),
      vocabularyType: Value(b.vocabularyType.name),
      buttonCount: Value(b.buttonCount),
      createdAt: Value(b.createdAt),
      updatedAt: Value(b.updatedAt),
      exportFormat: Value(b.exportFormat.name),
    );
  }

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Watches all boards belonging to [profileId] (including shared boards).
  Stream<List<entity.Board>> watchBoardsForProfile(String profileId) {
    return (select(boardsTable)
          ..where(
            (t) => t.profileId.equals(profileId) | t.profileId.isNull(),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Returns a board by UUID, or null if not found.
  Future<entity.Board?> getBoardById(String id) async {
    final row = await (select(boardsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _rowToEntity(row);
  }

  /// Inserts a new board.
  Future<void> insertBoard(entity.Board board) async {
    await into(boardsTable).insert(_entityToCompanion(board));
  }

  /// Replaces an existing board row with updated data.
  Future<void> updateBoard(entity.Board board) async {
    await (update(boardsTable)..where((t) => t.id.equals(board.id)))
        .write(_entityToCompanion(board));
  }

  /// Deletes a board by UUID.
  Future<void> deleteBoard(String id) async {
    await (delete(boardsTable)..where((t) => t.id.equals(id))).go();
  }

  /// Returns the first active board for [profileId], or null.
  Future<entity.Board?> getActiveBoardForProfile(String profileId) async {
    final row = await (select(boardsTable)
          ..where(
            (t) =>
                t.profileId.equals(profileId) &
                t.isActive.equals(true),
          )
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _rowToEntity(row);
  }
}

import 'package:uuid/uuid.dart';

import '../../domain/entities/board.dart';
import '../local/daos/board_dao.dart';

// ---------------------------------------------------------------------------
// Abstract contract
// ---------------------------------------------------------------------------

abstract class BoardRepository {
  /// Watches boards for [profileId] (including shared boards with no profile).
  Stream<List<Board>> watchBoardsForProfile(String profileId);

  /// Returns a board by UUID, or null.
  Future<Board?> getBoardById(String id);

  /// Creates and persists a new board, returning the created entity.
  Future<Board> createBoard({
    required String name,
    String? description,
    String? profileId,
    String? parentId,
    bool isActive = true,
    VocabularyType vocabularyType = VocabularyType.coreFirst,
    int buttonCount = 16,
    ExportFormat exportFormat = ExportFormat.hablaJson,
  });

  /// Persists changes to an existing board.
  Future<void> updateBoard(Board board);

  /// Removes a board by UUID.
  Future<void> deleteBoard(String id);

  /// Returns the active board for [profileId], or null.
  Future<Board?> getActiveBoardForProfile(String profileId);

  /// Deactivates all boards for [profileId] and activates [boardId].
  Future<void> setActiveBoard(String profileId, String boardId);
}

// ---------------------------------------------------------------------------
// Implementation
// ---------------------------------------------------------------------------

class BoardRepositoryImpl implements BoardRepository {
  final BoardDao _dao;
  final Uuid _uuid;

  BoardRepositoryImpl({required BoardDao dao, Uuid? uuid})
      : _dao = dao,
        _uuid = uuid ?? const Uuid();

  @override
  Stream<List<Board>> watchBoardsForProfile(String profileId) =>
      _dao.watchBoardsForProfile(profileId);

  @override
  Future<Board?> getBoardById(String id) => _dao.getBoardById(id);

  @override
  Future<Board> createBoard({
    required String name,
    String? description,
    String? profileId,
    String? parentId,
    bool isActive = true,
    VocabularyType vocabularyType = VocabularyType.coreFirst,
    int buttonCount = 16,
    ExportFormat exportFormat = ExportFormat.hablaJson,
  }) async {
    final now = DateTime.now();
    final board = Board(
      id: _uuid.v4(),
      name: name,
      description: description,
      profileId: profileId,
      parentId: parentId,
      isActive: isActive,
      vocabularyType: vocabularyType,
      buttonCount: buttonCount,
      createdAt: now,
      updatedAt: now,
      exportFormat: exportFormat,
    );
    await _dao.insertBoard(board);
    return board;
  }

  @override
  Future<void> updateBoard(Board board) async {
    final updated = board.copyWith(updatedAt: DateTime.now());
    await _dao.updateBoard(updated);
  }

  @override
  Future<void> deleteBoard(String id) => _dao.deleteBoard(id);

  @override
  Future<Board?> getActiveBoardForProfile(String profileId) =>
      _dao.getActiveBoardForProfile(profileId);

  @override
  Future<void> setActiveBoard(String profileId, String boardId) async {
    final boards =
        await _dao.watchBoardsForProfile(profileId).first;
    for (final b in boards) {
      final shouldBeActive = b.id == boardId;
      if (b.isActive != shouldBeActive) {
        await _dao.updateBoard(
          b.copyWith(isActive: shouldBeActive, updatedAt: DateTime.now()),
        );
      }
    }
  }
}

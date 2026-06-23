import 'package:uuid/uuid.dart';

import '../../domain/entities/vocabulary_item.dart';
import '../local/daos/vocabulary_dao.dart';

// ---------------------------------------------------------------------------
// Abstract contract
// ---------------------------------------------------------------------------

abstract class VocabularyRepository {
  /// Watches items linked to [boardId], re-emitting on any change.
  Stream<List<VocabularyItem>> watchVocabularyForBoard(String boardId);

  /// Returns all vocabulary items visible to [profileId].
  Future<List<VocabularyItem>> getVocabularyForProfile(String profileId);

  /// Creates and persists a vocabulary item, returning the created entity.
  Future<VocabularyItem> createVocabularyItem({
    required String label,
    String? message,
    String? symbolPath,
    required String category,
    String? subcategory,
    FitzgeraldCategory fitzgeraldCategory = FitzgeraldCategory.nouns,
    SkinTone skinTone = SkinTone.defaultTone,
    HairColor hairColor = HairColor.defaultColor,
    GrammarRole grammarRole = GrammarRole.other,
    String? linkedBoardId,
    bool isCore = false,
    int sortOrder = 0,
    String? profileId,
  });

  /// Persists changes to an existing vocabulary item.
  Future<void> updateVocabularyItem(VocabularyItem item);

  /// Removes a vocabulary item by UUID.
  Future<void> deleteVocabularyItem(String id);

  /// Returns items matching [query] for [profileId].
  Future<List<VocabularyItem>> searchVocabulary(
    String query,
    String profileId,
  );

  /// Returns the [limit] most-used items for [profileId].
  Future<List<VocabularyItem>> getMostUsed(String profileId, int limit);

  /// Toggles the favorite flag on item [id].
  Future<void> toggleFavorite(String id);

  /// Increments the usage counter on item [id].
  Future<void> incrementUsage(String id);
}

// ---------------------------------------------------------------------------
// Implementation
// ---------------------------------------------------------------------------

class VocabularyRepositoryImpl implements VocabularyRepository {
  final VocabularyDao _dao;
  final Uuid _uuid;

  VocabularyRepositoryImpl({required VocabularyDao dao, Uuid? uuid})
      : _dao = dao,
        _uuid = uuid ?? const Uuid();

  @override
  Stream<List<VocabularyItem>> watchVocabularyForBoard(String boardId) =>
      _dao.watchVocabularyForBoard(boardId);

  @override
  Future<List<VocabularyItem>> getVocabularyForProfile(String profileId) =>
      _dao.getVocabularyForProfile(profileId);

  @override
  Future<VocabularyItem> createVocabularyItem({
    required String label,
    String? message,
    String? symbolPath,
    required String category,
    String? subcategory,
    FitzgeraldCategory fitzgeraldCategory = FitzgeraldCategory.nouns,
    SkinTone skinTone = SkinTone.defaultTone,
    HairColor hairColor = HairColor.defaultColor,
    GrammarRole grammarRole = GrammarRole.other,
    String? linkedBoardId,
    bool isCore = false,
    int sortOrder = 0,
    String? profileId,
  }) async {
    final item = VocabularyItem(
      id: _uuid.v4(),
      label: label,
      message: message,
      symbolPath: symbolPath,
      category: category,
      subcategory: subcategory,
      fitzgeraldCategory: fitzgeraldCategory,
      skinTone: skinTone,
      hairColor: hairColor,
      grammarRole: grammarRole,
      linkedBoardId: linkedBoardId,
      isCore: isCore,
      sortOrder: sortOrder,
      usageCount: 0,
      isFavorite: false,
      profileId: profileId,
    );
    await _dao.insertVocabularyItem(item);
    return item;
  }

  @override
  Future<void> updateVocabularyItem(VocabularyItem item) =>
      _dao.updateVocabularyItem(item);

  @override
  Future<void> deleteVocabularyItem(String id) =>
      _dao.deleteVocabularyItem(id);

  @override
  Future<List<VocabularyItem>> searchVocabulary(
    String query,
    String profileId,
  ) =>
      _dao.searchVocabulary(query, profileId);

  @override
  Future<List<VocabularyItem>> getMostUsed(String profileId, int limit) =>
      _dao.getMostUsed(profileId, limit);

  @override
  Future<void> toggleFavorite(String id) => _dao.toggleFavorite(id);

  @override
  Future<void> incrementUsage(String id) => _dao.incrementUsage(id);
}

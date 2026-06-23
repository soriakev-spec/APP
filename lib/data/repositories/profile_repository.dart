import 'package:uuid/uuid.dart';

import '../../domain/entities/profile.dart';
import '../local/daos/profile_dao.dart';

// ---------------------------------------------------------------------------
// Abstract contract
// ---------------------------------------------------------------------------

abstract class ProfileRepository {
  /// Emits the full profile list whenever any profile changes.
  Stream<List<Profile>> watchAllProfiles();

  /// Returns the current profile list.
  Future<List<Profile>> getAllProfiles();

  /// Returns a single profile by its UUID, or null.
  Future<Profile?> getProfileById(String id);

  /// Creates and persists a new profile.
  /// The [id] field is generated automatically if empty.
  Future<Profile> createProfile({
    required String name,
    String? avatarPath,
    DiagnosisType diagnosis = DiagnosisType.child,
    int gridSize = 9,
    BoardDisposition disposition = BoardDisposition.pictograms,
    String? activeBoardId,
    String? voiceId,
    String language = 'es',
    bool isDefault = false,
  });

  /// Persists changes to an existing profile.
  Future<void> updateProfile(Profile profile);

  /// Removes a profile and all its associated data.
  Future<void> deleteProfile(String id);

  /// Sets [id] as the default profile (clears isDefault on all others).
  Future<void> setDefaultProfile(String id);
}

// ---------------------------------------------------------------------------
// Implementation
// ---------------------------------------------------------------------------

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDao _dao;
  final Uuid _uuid;

  ProfileRepositoryImpl({required ProfileDao dao, Uuid? uuid})
      : _dao = dao,
        _uuid = uuid ?? const Uuid();

  @override
  Stream<List<Profile>> watchAllProfiles() => _dao.watchAllProfiles();

  @override
  Future<List<Profile>> getAllProfiles() => _dao.getAllProfiles();

  @override
  Future<Profile?> getProfileById(String id) => _dao.getProfileById(id);

  @override
  Future<Profile> createProfile({
    required String name,
    String? avatarPath,
    DiagnosisType diagnosis = DiagnosisType.child,
    int gridSize = 9,
    BoardDisposition disposition = BoardDisposition.pictograms,
    String? activeBoardId,
    String? voiceId,
    String language = 'es',
    bool isDefault = false,
  }) async {
    final now = DateTime.now();
    final profile = Profile(
      id: _uuid.v4(),
      name: name,
      avatarPath: avatarPath,
      diagnosis: diagnosis,
      gridSize: gridSize,
      disposition: disposition,
      activeBoardId: activeBoardId,
      voiceId: voiceId,
      language: language,
      createdAt: now,
      updatedAt: now,
      isDefault: isDefault,
    );
    await _dao.insertProfile(profile);
    return profile;
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    final updated = profile.copyWith(updatedAt: DateTime.now());
    await _dao.updateProfile(updated);
  }

  @override
  Future<void> deleteProfile(String id) => _dao.deleteProfile(id);

  @override
  Future<void> setDefaultProfile(String id) async {
    final profiles = await _dao.getAllProfiles();
    for (final p in profiles) {
      final shouldBeDefault = p.id == id;
      if (p.isDefault != shouldBeDefault) {
        await _dao.updateProfile(
          p.copyWith(isDefault: shouldBeDefault, updatedAt: DateTime.now()),
        );
      }
    }
  }
}

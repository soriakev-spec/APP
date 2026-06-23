import 'package:drift/drift.dart';

import '../app_database.dart';
import '../../../domain/entities/profile.dart' as entity;

part 'profile_dao.g.dart';

@DriftAccessor(tables: [ProfilesTable])
class ProfileDao extends DatabaseAccessor<AppDatabase>
    with _$ProfileDaoMixin {
  ProfileDao(super.db);

  // ---------------------------------------------------------------------------
  // Mappers
  // ---------------------------------------------------------------------------

  entity.Profile _rowToEntity(ProfilesTableData row) {
    return entity.Profile(
      id: row.id,
      name: row.name,
      avatarPath: row.avatarPath,
      diagnosis: entity.DiagnosisType.values.firstWhere(
        (e) => e.name == row.diagnosis,
        orElse: () => entity.DiagnosisType.child,
      ),
      gridSize: row.gridSize,
      disposition: entity.BoardDisposition.values.firstWhere(
        (e) => e.name == row.disposition,
        orElse: () => entity.BoardDisposition.pictograms,
      ),
      activeBoardId: row.activeBoardId,
      voiceId: row.voiceId,
      language: row.language,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isDefault: row.isDefault,
    );
  }

  ProfilesTableCompanion _entityToCompanion(entity.Profile p) {
    return ProfilesTableCompanion(
      id: Value(p.id),
      name: Value(p.name),
      avatarPath: Value(p.avatarPath),
      diagnosis: Value(p.diagnosis.name),
      gridSize: Value(p.gridSize),
      disposition: Value(p.disposition.name),
      activeBoardId: Value(p.activeBoardId),
      voiceId: Value(p.voiceId),
      language: Value(p.language),
      createdAt: Value(p.createdAt),
      updatedAt: Value(p.updatedAt),
      isDefault: Value(p.isDefault),
    );
  }

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Emits the full profile list whenever any profile row changes.
  Stream<List<entity.Profile>> watchAllProfiles() {
    return (select(profilesTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.isDefault, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.name),
          ]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Returns the current profile list as a one-shot future.
  Future<List<entity.Profile>> getAllProfiles() async {
    final rows = await (select(profilesTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.isDefault, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.name),
          ]))
        .get();
    return rows.map(_rowToEntity).toList();
  }

  /// Returns a single profile by its UUID, or null if not found.
  Future<entity.Profile?> getProfileById(String id) async {
    final row = await (select(profilesTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _rowToEntity(row);
  }

  /// Inserts a new profile. Throws if the id already exists.
  Future<void> insertProfile(entity.Profile profile) async {
    await into(profilesTable).insert(_entityToCompanion(profile));
  }

  /// Replaces an existing profile row with updated data.
  Future<void> updateProfile(entity.Profile profile) async {
    await (update(profilesTable)
          ..where((t) => t.id.equals(profile.id)))
        .write(_entityToCompanion(profile));
  }

  /// Deletes a profile by UUID.
  Future<void> deleteProfile(String id) async {
    await (delete(profilesTable)..where((t) => t.id.equals(id))).go();
  }
}

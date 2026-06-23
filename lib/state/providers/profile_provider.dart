// Profile state providers — manages communication profiles (alumnos) for Habla AAC.
// Uses Riverpod 2.x with AsyncNotifier. No database dependency yet; data is held
// in-memory with 7 default profiles seeded on first run.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// ---------------------------------------------------------------------------
// Entity
// ---------------------------------------------------------------------------

class ProfileEntity {
  final String id;
  final String name;
  final String? avatarEmoji;

  /// One of: autism, aphasia, als, cerebral_palsy, down_syndrome, child, adult_general
  final String diagnosis;

  /// One of: pictograms, visual_scene, keyboard
  final String disposition;
  final int gridSize;
  final String language;
  final String vocabularyType;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileEntity({
    required this.id,
    required this.name,
    this.avatarEmoji,
    required this.diagnosis,
    required this.disposition,
    required this.gridSize,
    required this.language,
    required this.vocabularyType,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  ProfileEntity copyWith({
    String? id,
    String? name,
    Object? avatarEmoji = _sentinel,
    String? diagnosis,
    String? disposition,
    int? gridSize,
    String? language,
    String? vocabularyType,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarEmoji: avatarEmoji == _sentinel
          ? this.avatarEmoji
          : avatarEmoji as String?,
      diagnosis: diagnosis ?? this.diagnosis,
      disposition: disposition ?? this.disposition,
      gridSize: gridSize ?? this.gridSize,
      language: language ?? this.language,
      vocabularyType: vocabularyType ?? this.vocabularyType,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ProfileEntity(id: $id, name: $name, diagnosis: $diagnosis)';
}

// Sentinel for nullable copyWith fields.
const Object _sentinel = Object();

// ---------------------------------------------------------------------------
// Default profiles factory
// ---------------------------------------------------------------------------

List<ProfileEntity> _buildDefaultProfiles() {
  final now = DateTime.now();
  const uuid = Uuid();
  return [
    ProfileEntity(
      id: uuid.v4(),
      name: 'Niño con Autismo',
      avatarEmoji: '🧩',
      diagnosis: 'autism',
      disposition: 'pictograms',
      gridSize: 15,
      language: 'es-MX',
      vocabularyType: 'core_first',
      isDefault: true,
      createdAt: now,
      updatedAt: now,
    ),
    ProfileEntity(
      id: uuid.v4(),
      name: 'Persona con Afasia',
      avatarEmoji: '💬',
      diagnosis: 'aphasia',
      disposition: 'pictograms',
      gridSize: 9,
      language: 'es-MX',
      vocabularyType: 'aphasia',
      isDefault: false,
      createdAt: now,
      updatedAt: now,
    ),
    ProfileEntity(
      id: uuid.v4(),
      name: 'Persona con ELA',
      avatarEmoji: '🖐️',
      diagnosis: 'als',
      disposition: 'keyboard',
      gridSize: 9,
      language: 'es-MX',
      vocabularyType: 'als',
      isDefault: false,
      createdAt: now,
      updatedAt: now,
    ),
    ProfileEntity(
      id: uuid.v4(),
      name: 'Parálisis Cerebral',
      avatarEmoji: '⭐',
      diagnosis: 'cerebral_palsy',
      disposition: 'pictograms',
      gridSize: 9,
      language: 'es-MX',
      vocabularyType: 'core_first',
      isDefault: false,
      createdAt: now,
      updatedAt: now,
    ),
    ProfileEntity(
      id: uuid.v4(),
      name: 'Síndrome de Down',
      avatarEmoji: '🌟',
      diagnosis: 'down_syndrome',
      disposition: 'pictograms',
      gridSize: 9,
      language: 'es-MX',
      vocabularyType: 'core_first',
      isDefault: false,
      createdAt: now,
      updatedAt: now,
    ),
    ProfileEntity(
      id: uuid.v4(),
      name: 'Niño General',
      avatarEmoji: '🧒',
      diagnosis: 'child',
      disposition: 'pictograms',
      gridSize: 15,
      language: 'es-MX',
      vocabularyType: 'core_first',
      isDefault: false,
      createdAt: now,
      updatedAt: now,
    ),
    ProfileEntity(
      id: uuid.v4(),
      name: 'Adulto General',
      avatarEmoji: '🧑',
      diagnosis: 'adult_general',
      disposition: 'pictograms',
      gridSize: 15,
      language: 'es-MX',
      vocabularyType: 'custom',
      isDefault: false,
      createdAt: now,
      updatedAt: now,
    ),
  ];
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// The ID of the currently active profile. Null when no profile is selected.
final currentProfileIdProvider = StateProvider<String?>((ref) => null);

/// In-memory list of all profiles — acts as the source of truth until the
/// database layer is wired up.
final _profilesStorageProvider =
    StateProvider<List<ProfileEntity>>((ref) => _buildDefaultProfiles());

/// Stream-like provider exposing all profiles. Backed by the in-memory store.
/// Replace with a real `StreamProvider<List<ProfileEntity>>` from Drift once the
/// DAO is generated.
final allProfilesProvider = Provider<List<ProfileEntity>>((ref) {
  return ref.watch(_profilesStorageProvider);
});

/// Derives the full [ProfileEntity] for the currently selected profile.
/// Returns null if no profile is selected or the ID is not found.
final currentProfileDataProvider = Provider<ProfileEntity?>((ref) {
  final id = ref.watch(currentProfileIdProvider);
  if (id == null) {
    final profiles = ref.watch(allProfilesProvider);
    // Fall back to the first default profile.
    return profiles.isEmpty ? null : profiles.first;
  }
  final profiles = ref.watch(allProfilesProvider);
  try {
    return profiles.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
});

/// Notifier that handles all profile CRUD and lifecycle operations.
final profilesNotifierProvider =
    AsyncNotifierProvider<ProfilesNotifier, List<ProfileEntity>>(
  ProfilesNotifier.new,
);

// ---------------------------------------------------------------------------
// ProfilesNotifier
// ---------------------------------------------------------------------------

class ProfilesNotifier extends AsyncNotifier<List<ProfileEntity>> {
  @override
  Future<List<ProfileEntity>> build() async {
    // On first build return — or seed — the default profiles.
    final current = ref.read(_profilesStorageProvider);
    if (current.isEmpty) {
      final defaults = _buildDefaultProfiles();
      ref.read(_profilesStorageProvider.notifier).state = defaults;
      return defaults;
    }
    return current;
  }

  // ---- helpers ----

  List<ProfileEntity> get _current => ref.read(_profilesStorageProvider);

  void _persist(List<ProfileEntity> profiles) {
    ref.read(_profilesStorageProvider.notifier).state = List.unmodifiable(profiles);
    state = AsyncData(List.unmodifiable(profiles));
  }

  // ---- public API ----

  Future<void> createProfile(ProfileEntity profile) async {
    state = const AsyncLoading();
    final updated = [..._current, profile];
    _persist(updated);
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    state = const AsyncLoading();
    final updated = _current
        .map((p) => p.id == profile.id ? profile : p)
        .toList();
    _persist(updated);
  }

  Future<void> deleteProfile(String id) async {
    state = const AsyncLoading();
    final updated = _current.where((p) => p.id != id).toList();
    _persist(updated);
    // Clear selection if the deleted profile was active.
    final currentId = ref.read(currentProfileIdProvider);
    if (currentId == id) {
      ref.read(currentProfileIdProvider.notifier).state = null;
    }
  }

  Future<void> duplicateProfile(String id) async {
    state = const AsyncLoading();
    final source = _current.firstWhere((p) => p.id == id);
    final now = DateTime.now();
    final copy = source.copyWith(
      id: const Uuid().v4(),
      name: '${source.name} (copia)',
      isDefault: false,
      createdAt: now,
      updatedAt: now,
    );
    final updated = [..._current, copy];
    _persist(updated);
  }

  Future<void> setActiveProfile(String id) async {
    ref.read(currentProfileIdProvider.notifier).state = id;
  }
}

// Profile entity — represents a communication user (alumno)
// Profiles are isolated: vocabulary, boards, phrases, favorites, history are per-profile

enum DiagnosisType {
  autism,
  aphasia,
  als,
  cerebralPalsy,
  downSyndrome,
  child,
  adultGeneral,
}

enum BoardDisposition {
  pictograms,
  visualScene,
  keyboard,
}

class Profile {
  final String id;
  final String name;
  final String? avatarPath;
  final DiagnosisType diagnosis;
  final int gridSize;
  final BoardDisposition disposition;
  final String? activeBoardId;
  final String? voiceId;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDefault;

  const Profile({
    required this.id,
    required this.name,
    this.avatarPath,
    required this.diagnosis,
    required this.gridSize,
    required this.disposition,
    this.activeBoardId,
    this.voiceId,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
    required this.isDefault,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? avatarPath,
    DiagnosisType? diagnosis,
    int? gridSize,
    BoardDisposition? disposition,
    String? activeBoardId,
    String? voiceId,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDefault,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      diagnosis: diagnosis ?? this.diagnosis,
      gridSize: gridSize ?? this.gridSize,
      disposition: disposition ?? this.disposition,
      activeBoardId: activeBoardId ?? this.activeBoardId,
      voiceId: voiceId ?? this.voiceId,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Profile(id: $id, name: $name, diagnosis: $diagnosis)';
}

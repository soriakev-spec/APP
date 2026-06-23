// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTableTable extends ProfilesTable
    with TableInfo<$ProfilesTableTable, ProfilesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _diagnosisMeta =
      const VerificationMeta('diagnosis');
  @override
  late final GeneratedColumn<String> diagnosis = GeneratedColumn<String>(
      'diagnosis', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gridSizeMeta =
      const VerificationMeta('gridSize');
  @override
  late final GeneratedColumn<int> gridSize = GeneratedColumn<int>(
      'grid_size', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(9));
  static const VerificationMeta _dispositionMeta =
      const VerificationMeta('disposition');
  @override
  late final GeneratedColumn<String> disposition = GeneratedColumn<String>(
      'disposition', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pictograms'));
  static const VerificationMeta _activeBoardIdMeta =
      const VerificationMeta('activeBoardId');
  @override
  late final GeneratedColumn<String> activeBoardId = GeneratedColumn<String>(
      'active_board_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _voiceIdMeta =
      const VerificationMeta('voiceId');
  @override
  late final GeneratedColumn<String> voiceId = GeneratedColumn<String>(
      'voice_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('es'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        avatarPath,
        diagnosis,
        gridSize,
        disposition,
        activeBoardId,
        voiceId,
        language,
        createdAt,
        updatedAt,
        isDefault
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<ProfilesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    if (data.containsKey('diagnosis')) {
      context.handle(_diagnosisMeta,
          diagnosis.isAcceptableOrUnknown(data['diagnosis']!, _diagnosisMeta));
    } else if (isInserting) {
      context.missing(_diagnosisMeta);
    }
    if (data.containsKey('grid_size')) {
      context.handle(_gridSizeMeta,
          gridSize.isAcceptableOrUnknown(data['grid_size']!, _gridSizeMeta));
    }
    if (data.containsKey('disposition')) {
      context.handle(
          _dispositionMeta,
          disposition.isAcceptableOrUnknown(
              data['disposition']!, _dispositionMeta));
    }
    if (data.containsKey('active_board_id')) {
      context.handle(
          _activeBoardIdMeta,
          activeBoardId.isAcceptableOrUnknown(
              data['active_board_id']!, _activeBoardIdMeta));
    }
    if (data.containsKey('voice_id')) {
      context.handle(_voiceIdMeta,
          voiceId.isAcceptableOrUnknown(data['voice_id']!, _voiceIdMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfilesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfilesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      diagnosis: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}diagnosis'])!,
      gridSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grid_size'])!,
      disposition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}disposition'])!,
      activeBoardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}active_board_id']),
      voiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}voice_id']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
    );
  }

  @override
  $ProfilesTableTable createAlias(String alias) {
    return $ProfilesTableTable(attachedDatabase, alias);
  }
}

class ProfilesTableData extends DataClass
    implements Insertable<ProfilesTableData> {
  final String id;
  final String name;
  final String? avatarPath;
  final String diagnosis;
  final int gridSize;
  final String disposition;
  final String? activeBoardId;
  final String? voiceId;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDefault;
  const ProfilesTableData(
      {required this.id,
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
      required this.isDefault});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['diagnosis'] = Variable<String>(diagnosis);
    map['grid_size'] = Variable<int>(gridSize);
    map['disposition'] = Variable<String>(disposition);
    if (!nullToAbsent || activeBoardId != null) {
      map['active_board_id'] = Variable<String>(activeBoardId);
    }
    if (!nullToAbsent || voiceId != null) {
      map['voice_id'] = Variable<String>(voiceId);
    }
    map['language'] = Variable<String>(language);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  ProfilesTableCompanion toCompanion(bool nullToAbsent) {
    return ProfilesTableCompanion(
      id: Value(id),
      name: Value(name),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      diagnosis: Value(diagnosis),
      gridSize: Value(gridSize),
      disposition: Value(disposition),
      activeBoardId: activeBoardId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeBoardId),
      voiceId: voiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceId),
      language: Value(language),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDefault: Value(isDefault),
    );
  }

  factory ProfilesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfilesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      diagnosis: serializer.fromJson<String>(json['diagnosis']),
      gridSize: serializer.fromJson<int>(json['gridSize']),
      disposition: serializer.fromJson<String>(json['disposition']),
      activeBoardId: serializer.fromJson<String?>(json['activeBoardId']),
      voiceId: serializer.fromJson<String?>(json['voiceId']),
      language: serializer.fromJson<String>(json['language']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'diagnosis': serializer.toJson<String>(diagnosis),
      'gridSize': serializer.toJson<int>(gridSize),
      'disposition': serializer.toJson<String>(disposition),
      'activeBoardId': serializer.toJson<String?>(activeBoardId),
      'voiceId': serializer.toJson<String?>(voiceId),
      'language': serializer.toJson<String>(language),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  ProfilesTableData copyWith(
          {String? id,
          String? name,
          Value<String?> avatarPath = const Value.absent(),
          String? diagnosis,
          int? gridSize,
          String? disposition,
          Value<String?> activeBoardId = const Value.absent(),
          Value<String?> voiceId = const Value.absent(),
          String? language,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isDefault}) =>
      ProfilesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        diagnosis: diagnosis ?? this.diagnosis,
        gridSize: gridSize ?? this.gridSize,
        disposition: disposition ?? this.disposition,
        activeBoardId:
            activeBoardId.present ? activeBoardId.value : this.activeBoardId,
        voiceId: voiceId.present ? voiceId.value : this.voiceId,
        language: language ?? this.language,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isDefault: isDefault ?? this.isDefault,
      );
  ProfilesTableData copyWithCompanion(ProfilesTableCompanion data) {
    return ProfilesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      diagnosis: data.diagnosis.present ? data.diagnosis.value : this.diagnosis,
      gridSize: data.gridSize.present ? data.gridSize.value : this.gridSize,
      disposition:
          data.disposition.present ? data.disposition.value : this.disposition,
      activeBoardId: data.activeBoardId.present
          ? data.activeBoardId.value
          : this.activeBoardId,
      voiceId: data.voiceId.present ? data.voiceId.value : this.voiceId,
      language: data.language.present ? data.language.value : this.language,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('gridSize: $gridSize, ')
          ..write('disposition: $disposition, ')
          ..write('activeBoardId: $activeBoardId, ')
          ..write('voiceId: $voiceId, ')
          ..write('language: $language, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      avatarPath,
      diagnosis,
      gridSize,
      disposition,
      activeBoardId,
      voiceId,
      language,
      createdAt,
      updatedAt,
      isDefault);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfilesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarPath == this.avatarPath &&
          other.diagnosis == this.diagnosis &&
          other.gridSize == this.gridSize &&
          other.disposition == this.disposition &&
          other.activeBoardId == this.activeBoardId &&
          other.voiceId == this.voiceId &&
          other.language == this.language &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDefault == this.isDefault);
}

class ProfilesTableCompanion extends UpdateCompanion<ProfilesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> avatarPath;
  final Value<String> diagnosis;
  final Value<int> gridSize;
  final Value<String> disposition;
  final Value<String?> activeBoardId;
  final Value<String?> voiceId;
  final Value<String> language;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDefault;
  final Value<int> rowid;
  const ProfilesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.gridSize = const Value.absent(),
    this.disposition = const Value.absent(),
    this.activeBoardId = const Value.absent(),
    this.voiceId = const Value.absent(),
    this.language = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesTableCompanion.insert({
    required String id,
    required String name,
    this.avatarPath = const Value.absent(),
    required String diagnosis,
    this.gridSize = const Value.absent(),
    this.disposition = const Value.absent(),
    this.activeBoardId = const Value.absent(),
    this.voiceId = const Value.absent(),
    this.language = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        diagnosis = Value(diagnosis),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ProfilesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatarPath,
    Expression<String>? diagnosis,
    Expression<int>? gridSize,
    Expression<String>? disposition,
    Expression<String>? activeBoardId,
    Expression<String>? voiceId,
    Expression<String>? language,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDefault,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (gridSize != null) 'grid_size': gridSize,
      if (disposition != null) 'disposition': disposition,
      if (activeBoardId != null) 'active_board_id': activeBoardId,
      if (voiceId != null) 'voice_id': voiceId,
      if (language != null) 'language': language,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDefault != null) 'is_default': isDefault,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? avatarPath,
      Value<String>? diagnosis,
      Value<int>? gridSize,
      Value<String>? disposition,
      Value<String?>? activeBoardId,
      Value<String?>? voiceId,
      Value<String>? language,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isDefault,
      Value<int>? rowid}) {
    return ProfilesTableCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (diagnosis.present) {
      map['diagnosis'] = Variable<String>(diagnosis.value);
    }
    if (gridSize.present) {
      map['grid_size'] = Variable<int>(gridSize.value);
    }
    if (disposition.present) {
      map['disposition'] = Variable<String>(disposition.value);
    }
    if (activeBoardId.present) {
      map['active_board_id'] = Variable<String>(activeBoardId.value);
    }
    if (voiceId.present) {
      map['voice_id'] = Variable<String>(voiceId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('gridSize: $gridSize, ')
          ..write('disposition: $disposition, ')
          ..write('activeBoardId: $activeBoardId, ')
          ..write('voiceId: $voiceId, ')
          ..write('language: $language, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDefault: $isDefault, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BoardsTableTable extends BoardsTable
    with TableInfo<$BoardsTableTable, BoardsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BoardsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _vocabularyTypeMeta =
      const VerificationMeta('vocabularyType');
  @override
  late final GeneratedColumn<String> vocabularyType = GeneratedColumn<String>(
      'vocabulary_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('core_first'));
  static const VerificationMeta _buttonCountMeta =
      const VerificationMeta('buttonCount');
  @override
  late final GeneratedColumn<int> buttonCount = GeneratedColumn<int>(
      'button_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(16));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _exportFormatMeta =
      const VerificationMeta('exportFormat');
  @override
  late final GeneratedColumn<String> exportFormat = GeneratedColumn<String>(
      'export_format', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('habla_json'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        profileId,
        parentId,
        isActive,
        vocabularyType,
        buttonCount,
        createdAt,
        updatedAt,
        exportFormat
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'boards';
  @override
  VerificationContext validateIntegrity(Insertable<BoardsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('vocabulary_type')) {
      context.handle(
          _vocabularyTypeMeta,
          vocabularyType.isAcceptableOrUnknown(
              data['vocabulary_type']!, _vocabularyTypeMeta));
    }
    if (data.containsKey('button_count')) {
      context.handle(
          _buttonCountMeta,
          buttonCount.isAcceptableOrUnknown(
              data['button_count']!, _buttonCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('export_format')) {
      context.handle(
          _exportFormatMeta,
          exportFormat.isAcceptableOrUnknown(
              data['export_format']!, _exportFormatMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BoardsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BoardsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id']),
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      vocabularyType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}vocabulary_type'])!,
      buttonCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}button_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      exportFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}export_format'])!,
    );
  }

  @override
  $BoardsTableTable createAlias(String alias) {
    return $BoardsTableTable(attachedDatabase, alias);
  }
}

class BoardsTableData extends DataClass implements Insertable<BoardsTableData> {
  final String id;
  final String name;
  final String? description;
  final String? profileId;
  final String? parentId;
  final bool isActive;
  final String vocabularyType;
  final int buttonCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String exportFormat;
  const BoardsTableData(
      {required this.id,
      required this.name,
      this.description,
      this.profileId,
      this.parentId,
      required this.isActive,
      required this.vocabularyType,
      required this.buttonCount,
      required this.createdAt,
      required this.updatedAt,
      required this.exportFormat});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<String>(profileId);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['vocabulary_type'] = Variable<String>(vocabularyType);
    map['button_count'] = Variable<int>(buttonCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['export_format'] = Variable<String>(exportFormat);
    return map;
  }

  BoardsTableCompanion toCompanion(bool nullToAbsent) {
    return BoardsTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isActive: Value(isActive),
      vocabularyType: Value(vocabularyType),
      buttonCount: Value(buttonCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      exportFormat: Value(exportFormat),
    );
  }

  factory BoardsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BoardsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      profileId: serializer.fromJson<String?>(json['profileId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      vocabularyType: serializer.fromJson<String>(json['vocabularyType']),
      buttonCount: serializer.fromJson<int>(json['buttonCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      exportFormat: serializer.fromJson<String>(json['exportFormat']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'profileId': serializer.toJson<String?>(profileId),
      'parentId': serializer.toJson<String?>(parentId),
      'isActive': serializer.toJson<bool>(isActive),
      'vocabularyType': serializer.toJson<String>(vocabularyType),
      'buttonCount': serializer.toJson<int>(buttonCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'exportFormat': serializer.toJson<String>(exportFormat),
    };
  }

  BoardsTableData copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> profileId = const Value.absent(),
          Value<String?> parentId = const Value.absent(),
          bool? isActive,
          String? vocabularyType,
          int? buttonCount,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? exportFormat}) =>
      BoardsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        profileId: profileId.present ? profileId.value : this.profileId,
        parentId: parentId.present ? parentId.value : this.parentId,
        isActive: isActive ?? this.isActive,
        vocabularyType: vocabularyType ?? this.vocabularyType,
        buttonCount: buttonCount ?? this.buttonCount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        exportFormat: exportFormat ?? this.exportFormat,
      );
  BoardsTableData copyWithCompanion(BoardsTableCompanion data) {
    return BoardsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      vocabularyType: data.vocabularyType.present
          ? data.vocabularyType.value
          : this.vocabularyType,
      buttonCount:
          data.buttonCount.present ? data.buttonCount.value : this.buttonCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      exportFormat: data.exportFormat.present
          ? data.exportFormat.value
          : this.exportFormat,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BoardsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('profileId: $profileId, ')
          ..write('parentId: $parentId, ')
          ..write('isActive: $isActive, ')
          ..write('vocabularyType: $vocabularyType, ')
          ..write('buttonCount: $buttonCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('exportFormat: $exportFormat')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      profileId,
      parentId,
      isActive,
      vocabularyType,
      buttonCount,
      createdAt,
      updatedAt,
      exportFormat);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BoardsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.profileId == this.profileId &&
          other.parentId == this.parentId &&
          other.isActive == this.isActive &&
          other.vocabularyType == this.vocabularyType &&
          other.buttonCount == this.buttonCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.exportFormat == this.exportFormat);
}

class BoardsTableCompanion extends UpdateCompanion<BoardsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> profileId;
  final Value<String?> parentId;
  final Value<bool> isActive;
  final Value<String> vocabularyType;
  final Value<int> buttonCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> exportFormat;
  final Value<int> rowid;
  const BoardsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.profileId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.vocabularyType = const Value.absent(),
    this.buttonCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.exportFormat = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BoardsTableCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.profileId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.vocabularyType = const Value.absent(),
    this.buttonCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.exportFormat = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<BoardsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? profileId,
    Expression<String>? parentId,
    Expression<bool>? isActive,
    Expression<String>? vocabularyType,
    Expression<int>? buttonCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? exportFormat,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (profileId != null) 'profile_id': profileId,
      if (parentId != null) 'parent_id': parentId,
      if (isActive != null) 'is_active': isActive,
      if (vocabularyType != null) 'vocabulary_type': vocabularyType,
      if (buttonCount != null) 'button_count': buttonCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (exportFormat != null) 'export_format': exportFormat,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BoardsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? profileId,
      Value<String?>? parentId,
      Value<bool>? isActive,
      Value<String>? vocabularyType,
      Value<int>? buttonCount,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? exportFormat,
      Value<int>? rowid}) {
    return BoardsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      profileId: profileId ?? this.profileId,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      vocabularyType: vocabularyType ?? this.vocabularyType,
      buttonCount: buttonCount ?? this.buttonCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      exportFormat: exportFormat ?? this.exportFormat,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (vocabularyType.present) {
      map['vocabulary_type'] = Variable<String>(vocabularyType.value);
    }
    if (buttonCount.present) {
      map['button_count'] = Variable<int>(buttonCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (exportFormat.present) {
      map['export_format'] = Variable<String>(exportFormat.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BoardsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('profileId: $profileId, ')
          ..write('parentId: $parentId, ')
          ..write('isActive: $isActive, ')
          ..write('vocabularyType: $vocabularyType, ')
          ..write('buttonCount: $buttonCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('exportFormat: $exportFormat, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VocabularyTableTable extends VocabularyTable
    with TableInfo<$VocabularyTableTable, VocabularyTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _symbolPathMeta =
      const VerificationMeta('symbolPath');
  @override
  late final GeneratedColumn<String> symbolPath = GeneratedColumn<String>(
      'symbol_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subcategoryMeta =
      const VerificationMeta('subcategory');
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
      'subcategory', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fitzgeraldCategoryMeta =
      const VerificationMeta('fitzgeraldCategory');
  @override
  late final GeneratedColumn<String> fitzgeraldCategory =
      GeneratedColumn<String>('fitzgerald_category', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('other'));
  static const VerificationMeta _skinToneMeta =
      const VerificationMeta('skinTone');
  @override
  late final GeneratedColumn<String> skinTone = GeneratedColumn<String>(
      'skin_tone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default_tone'));
  static const VerificationMeta _hairColorMeta =
      const VerificationMeta('hairColor');
  @override
  late final GeneratedColumn<String> hairColor = GeneratedColumn<String>(
      'hair_color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default_color'));
  static const VerificationMeta _grammarRoleMeta =
      const VerificationMeta('grammarRole');
  @override
  late final GeneratedColumn<String> grammarRole = GeneratedColumn<String>(
      'grammar_role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('other'));
  static const VerificationMeta _linkedBoardIdMeta =
      const VerificationMeta('linkedBoardId');
  @override
  late final GeneratedColumn<String> linkedBoardId = GeneratedColumn<String>(
      'linked_board_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCoreMeta = const VerificationMeta('isCore');
  @override
  late final GeneratedColumn<bool> isCore = GeneratedColumn<bool>(
      'is_core', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_core" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _usageCountMeta =
      const VerificationMeta('usageCount');
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
      'usage_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        label,
        message,
        symbolPath,
        category,
        subcategory,
        fitzgeraldCategory,
        skinTone,
        hairColor,
        grammarRole,
        linkedBoardId,
        isCore,
        sortOrder,
        usageCount,
        isFavorite,
        profileId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary';
  @override
  VerificationContext validateIntegrity(
      Insertable<VocabularyTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    }
    if (data.containsKey('symbol_path')) {
      context.handle(
          _symbolPathMeta,
          symbolPath.isAcceptableOrUnknown(
              data['symbol_path']!, _symbolPathMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('subcategory')) {
      context.handle(
          _subcategoryMeta,
          subcategory.isAcceptableOrUnknown(
              data['subcategory']!, _subcategoryMeta));
    }
    if (data.containsKey('fitzgerald_category')) {
      context.handle(
          _fitzgeraldCategoryMeta,
          fitzgeraldCategory.isAcceptableOrUnknown(
              data['fitzgerald_category']!, _fitzgeraldCategoryMeta));
    }
    if (data.containsKey('skin_tone')) {
      context.handle(_skinToneMeta,
          skinTone.isAcceptableOrUnknown(data['skin_tone']!, _skinToneMeta));
    }
    if (data.containsKey('hair_color')) {
      context.handle(_hairColorMeta,
          hairColor.isAcceptableOrUnknown(data['hair_color']!, _hairColorMeta));
    }
    if (data.containsKey('grammar_role')) {
      context.handle(
          _grammarRoleMeta,
          grammarRole.isAcceptableOrUnknown(
              data['grammar_role']!, _grammarRoleMeta));
    }
    if (data.containsKey('linked_board_id')) {
      context.handle(
          _linkedBoardIdMeta,
          linkedBoardId.isAcceptableOrUnknown(
              data['linked_board_id']!, _linkedBoardIdMeta));
    }
    if (data.containsKey('is_core')) {
      context.handle(_isCoreMeta,
          isCore.isAcceptableOrUnknown(data['is_core']!, _isCoreMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('usage_count')) {
      context.handle(
          _usageCountMeta,
          usageCount.isAcceptableOrUnknown(
              data['usage_count']!, _usageCountMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabularyTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message']),
      symbolPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol_path']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      subcategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subcategory']),
      fitzgeraldCategory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}fitzgerald_category'])!,
      skinTone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}skin_tone'])!,
      hairColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hair_color'])!,
      grammarRole: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}grammar_role'])!,
      linkedBoardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}linked_board_id']),
      isCore: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_core'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      usageCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usage_count'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id']),
    );
  }

  @override
  $VocabularyTableTable createAlias(String alias) {
    return $VocabularyTableTable(attachedDatabase, alias);
  }
}

class VocabularyTableData extends DataClass
    implements Insertable<VocabularyTableData> {
  final String id;
  final String label;
  final String? message;
  final String? symbolPath;
  final String category;
  final String? subcategory;
  final String fitzgeraldCategory;
  final String skinTone;
  final String hairColor;
  final String grammarRole;
  final String? linkedBoardId;
  final bool isCore;
  final int sortOrder;
  final int usageCount;
  final bool isFavorite;
  final String? profileId;
  const VocabularyTableData(
      {required this.id,
      required this.label,
      this.message,
      this.symbolPath,
      required this.category,
      this.subcategory,
      required this.fitzgeraldCategory,
      required this.skinTone,
      required this.hairColor,
      required this.grammarRole,
      this.linkedBoardId,
      required this.isCore,
      required this.sortOrder,
      required this.usageCount,
      required this.isFavorite,
      this.profileId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || symbolPath != null) {
      map['symbol_path'] = Variable<String>(symbolPath);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || subcategory != null) {
      map['subcategory'] = Variable<String>(subcategory);
    }
    map['fitzgerald_category'] = Variable<String>(fitzgeraldCategory);
    map['skin_tone'] = Variable<String>(skinTone);
    map['hair_color'] = Variable<String>(hairColor);
    map['grammar_role'] = Variable<String>(grammarRole);
    if (!nullToAbsent || linkedBoardId != null) {
      map['linked_board_id'] = Variable<String>(linkedBoardId);
    }
    map['is_core'] = Variable<bool>(isCore);
    map['sort_order'] = Variable<int>(sortOrder);
    map['usage_count'] = Variable<int>(usageCount);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<String>(profileId);
    }
    return map;
  }

  VocabularyTableCompanion toCompanion(bool nullToAbsent) {
    return VocabularyTableCompanion(
      id: Value(id),
      label: Value(label),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      symbolPath: symbolPath == null && nullToAbsent
          ? const Value.absent()
          : Value(symbolPath),
      category: Value(category),
      subcategory: subcategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategory),
      fitzgeraldCategory: Value(fitzgeraldCategory),
      skinTone: Value(skinTone),
      hairColor: Value(hairColor),
      grammarRole: Value(grammarRole),
      linkedBoardId: linkedBoardId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedBoardId),
      isCore: Value(isCore),
      sortOrder: Value(sortOrder),
      usageCount: Value(usageCount),
      isFavorite: Value(isFavorite),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
    );
  }

  factory VocabularyTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyTableData(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      message: serializer.fromJson<String?>(json['message']),
      symbolPath: serializer.fromJson<String?>(json['symbolPath']),
      category: serializer.fromJson<String>(json['category']),
      subcategory: serializer.fromJson<String?>(json['subcategory']),
      fitzgeraldCategory:
          serializer.fromJson<String>(json['fitzgeraldCategory']),
      skinTone: serializer.fromJson<String>(json['skinTone']),
      hairColor: serializer.fromJson<String>(json['hairColor']),
      grammarRole: serializer.fromJson<String>(json['grammarRole']),
      linkedBoardId: serializer.fromJson<String?>(json['linkedBoardId']),
      isCore: serializer.fromJson<bool>(json['isCore']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      profileId: serializer.fromJson<String?>(json['profileId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'message': serializer.toJson<String?>(message),
      'symbolPath': serializer.toJson<String?>(symbolPath),
      'category': serializer.toJson<String>(category),
      'subcategory': serializer.toJson<String?>(subcategory),
      'fitzgeraldCategory': serializer.toJson<String>(fitzgeraldCategory),
      'skinTone': serializer.toJson<String>(skinTone),
      'hairColor': serializer.toJson<String>(hairColor),
      'grammarRole': serializer.toJson<String>(grammarRole),
      'linkedBoardId': serializer.toJson<String?>(linkedBoardId),
      'isCore': serializer.toJson<bool>(isCore),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'usageCount': serializer.toJson<int>(usageCount),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'profileId': serializer.toJson<String?>(profileId),
    };
  }

  VocabularyTableData copyWith(
          {String? id,
          String? label,
          Value<String?> message = const Value.absent(),
          Value<String?> symbolPath = const Value.absent(),
          String? category,
          Value<String?> subcategory = const Value.absent(),
          String? fitzgeraldCategory,
          String? skinTone,
          String? hairColor,
          String? grammarRole,
          Value<String?> linkedBoardId = const Value.absent(),
          bool? isCore,
          int? sortOrder,
          int? usageCount,
          bool? isFavorite,
          Value<String?> profileId = const Value.absent()}) =>
      VocabularyTableData(
        id: id ?? this.id,
        label: label ?? this.label,
        message: message.present ? message.value : this.message,
        symbolPath: symbolPath.present ? symbolPath.value : this.symbolPath,
        category: category ?? this.category,
        subcategory: subcategory.present ? subcategory.value : this.subcategory,
        fitzgeraldCategory: fitzgeraldCategory ?? this.fitzgeraldCategory,
        skinTone: skinTone ?? this.skinTone,
        hairColor: hairColor ?? this.hairColor,
        grammarRole: grammarRole ?? this.grammarRole,
        linkedBoardId:
            linkedBoardId.present ? linkedBoardId.value : this.linkedBoardId,
        isCore: isCore ?? this.isCore,
        sortOrder: sortOrder ?? this.sortOrder,
        usageCount: usageCount ?? this.usageCount,
        isFavorite: isFavorite ?? this.isFavorite,
        profileId: profileId.present ? profileId.value : this.profileId,
      );
  VocabularyTableData copyWithCompanion(VocabularyTableCompanion data) {
    return VocabularyTableData(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      message: data.message.present ? data.message.value : this.message,
      symbolPath:
          data.symbolPath.present ? data.symbolPath.value : this.symbolPath,
      category: data.category.present ? data.category.value : this.category,
      subcategory:
          data.subcategory.present ? data.subcategory.value : this.subcategory,
      fitzgeraldCategory: data.fitzgeraldCategory.present
          ? data.fitzgeraldCategory.value
          : this.fitzgeraldCategory,
      skinTone: data.skinTone.present ? data.skinTone.value : this.skinTone,
      hairColor: data.hairColor.present ? data.hairColor.value : this.hairColor,
      grammarRole:
          data.grammarRole.present ? data.grammarRole.value : this.grammarRole,
      linkedBoardId: data.linkedBoardId.present
          ? data.linkedBoardId.value
          : this.linkedBoardId,
      isCore: data.isCore.present ? data.isCore.value : this.isCore,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      usageCount:
          data.usageCount.present ? data.usageCount.value : this.usageCount,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyTableData(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('message: $message, ')
          ..write('symbolPath: $symbolPath, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('fitzgeraldCategory: $fitzgeraldCategory, ')
          ..write('skinTone: $skinTone, ')
          ..write('hairColor: $hairColor, ')
          ..write('grammarRole: $grammarRole, ')
          ..write('linkedBoardId: $linkedBoardId, ')
          ..write('isCore: $isCore, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('usageCount: $usageCount, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('profileId: $profileId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      label,
      message,
      symbolPath,
      category,
      subcategory,
      fitzgeraldCategory,
      skinTone,
      hairColor,
      grammarRole,
      linkedBoardId,
      isCore,
      sortOrder,
      usageCount,
      isFavorite,
      profileId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyTableData &&
          other.id == this.id &&
          other.label == this.label &&
          other.message == this.message &&
          other.symbolPath == this.symbolPath &&
          other.category == this.category &&
          other.subcategory == this.subcategory &&
          other.fitzgeraldCategory == this.fitzgeraldCategory &&
          other.skinTone == this.skinTone &&
          other.hairColor == this.hairColor &&
          other.grammarRole == this.grammarRole &&
          other.linkedBoardId == this.linkedBoardId &&
          other.isCore == this.isCore &&
          other.sortOrder == this.sortOrder &&
          other.usageCount == this.usageCount &&
          other.isFavorite == this.isFavorite &&
          other.profileId == this.profileId);
}

class VocabularyTableCompanion extends UpdateCompanion<VocabularyTableData> {
  final Value<String> id;
  final Value<String> label;
  final Value<String?> message;
  final Value<String?> symbolPath;
  final Value<String> category;
  final Value<String?> subcategory;
  final Value<String> fitzgeraldCategory;
  final Value<String> skinTone;
  final Value<String> hairColor;
  final Value<String> grammarRole;
  final Value<String?> linkedBoardId;
  final Value<bool> isCore;
  final Value<int> sortOrder;
  final Value<int> usageCount;
  final Value<bool> isFavorite;
  final Value<String?> profileId;
  final Value<int> rowid;
  const VocabularyTableCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.message = const Value.absent(),
    this.symbolPath = const Value.absent(),
    this.category = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.fitzgeraldCategory = const Value.absent(),
    this.skinTone = const Value.absent(),
    this.hairColor = const Value.absent(),
    this.grammarRole = const Value.absent(),
    this.linkedBoardId = const Value.absent(),
    this.isCore = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.profileId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabularyTableCompanion.insert({
    required String id,
    required String label,
    this.message = const Value.absent(),
    this.symbolPath = const Value.absent(),
    required String category,
    this.subcategory = const Value.absent(),
    this.fitzgeraldCategory = const Value.absent(),
    this.skinTone = const Value.absent(),
    this.hairColor = const Value.absent(),
    this.grammarRole = const Value.absent(),
    this.linkedBoardId = const Value.absent(),
    this.isCore = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.profileId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        label = Value(label),
        category = Value(category);
  static Insertable<VocabularyTableData> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? message,
    Expression<String>? symbolPath,
    Expression<String>? category,
    Expression<String>? subcategory,
    Expression<String>? fitzgeraldCategory,
    Expression<String>? skinTone,
    Expression<String>? hairColor,
    Expression<String>? grammarRole,
    Expression<String>? linkedBoardId,
    Expression<bool>? isCore,
    Expression<int>? sortOrder,
    Expression<int>? usageCount,
    Expression<bool>? isFavorite,
    Expression<String>? profileId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (message != null) 'message': message,
      if (symbolPath != null) 'symbol_path': symbolPath,
      if (category != null) 'category': category,
      if (subcategory != null) 'subcategory': subcategory,
      if (fitzgeraldCategory != null) 'fitzgerald_category': fitzgeraldCategory,
      if (skinTone != null) 'skin_tone': skinTone,
      if (hairColor != null) 'hair_color': hairColor,
      if (grammarRole != null) 'grammar_role': grammarRole,
      if (linkedBoardId != null) 'linked_board_id': linkedBoardId,
      if (isCore != null) 'is_core': isCore,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (usageCount != null) 'usage_count': usageCount,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (profileId != null) 'profile_id': profileId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabularyTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? label,
      Value<String?>? message,
      Value<String?>? symbolPath,
      Value<String>? category,
      Value<String?>? subcategory,
      Value<String>? fitzgeraldCategory,
      Value<String>? skinTone,
      Value<String>? hairColor,
      Value<String>? grammarRole,
      Value<String?>? linkedBoardId,
      Value<bool>? isCore,
      Value<int>? sortOrder,
      Value<int>? usageCount,
      Value<bool>? isFavorite,
      Value<String?>? profileId,
      Value<int>? rowid}) {
    return VocabularyTableCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      message: message ?? this.message,
      symbolPath: symbolPath ?? this.symbolPath,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      fitzgeraldCategory: fitzgeraldCategory ?? this.fitzgeraldCategory,
      skinTone: skinTone ?? this.skinTone,
      hairColor: hairColor ?? this.hairColor,
      grammarRole: grammarRole ?? this.grammarRole,
      linkedBoardId: linkedBoardId ?? this.linkedBoardId,
      isCore: isCore ?? this.isCore,
      sortOrder: sortOrder ?? this.sortOrder,
      usageCount: usageCount ?? this.usageCount,
      isFavorite: isFavorite ?? this.isFavorite,
      profileId: profileId ?? this.profileId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (symbolPath.present) {
      map['symbol_path'] = Variable<String>(symbolPath.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (subcategory.present) {
      map['subcategory'] = Variable<String>(subcategory.value);
    }
    if (fitzgeraldCategory.present) {
      map['fitzgerald_category'] = Variable<String>(fitzgeraldCategory.value);
    }
    if (skinTone.present) {
      map['skin_tone'] = Variable<String>(skinTone.value);
    }
    if (hairColor.present) {
      map['hair_color'] = Variable<String>(hairColor.value);
    }
    if (grammarRole.present) {
      map['grammar_role'] = Variable<String>(grammarRole.value);
    }
    if (linkedBoardId.present) {
      map['linked_board_id'] = Variable<String>(linkedBoardId.value);
    }
    if (isCore.present) {
      map['is_core'] = Variable<bool>(isCore.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyTableCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('message: $message, ')
          ..write('symbolPath: $symbolPath, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('fitzgeraldCategory: $fitzgeraldCategory, ')
          ..write('skinTone: $skinTone, ')
          ..write('hairColor: $hairColor, ')
          ..write('grammarRole: $grammarRole, ')
          ..write('linkedBoardId: $linkedBoardId, ')
          ..write('isCore: $isCore, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('usageCount: $usageCount, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('profileId: $profileId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhrasesTableTable extends PhrasesTable
    with TableInfo<$PhrasesTableTable, PhrasesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhrasesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phraseTextMeta =
      const VerificationMeta('phraseText');
  @override
  late final GeneratedColumn<String> phraseText = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phraseContextMeta =
      const VerificationMeta('phraseContext');
  @override
  late final GeneratedColumn<String> phraseContext = GeneratedColumn<String>(
      'context', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subcategoryMeta =
      const VerificationMeta('subcategory');
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
      'subcategory', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ageGroupMeta =
      const VerificationMeta('ageGroup');
  @override
  late final GeneratedColumn<String> ageGroup = GeneratedColumn<String>(
      'age_group', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('child'));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('phrase'));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _usageCountMeta =
      const VerificationMeta('usageCount');
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
      'usage_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _folderIdMeta =
      const VerificationMeta('folderId');
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
      'folder_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        phraseText,
        phraseContext,
        subcategory,
        ageGroup,
        level,
        isFavorite,
        usageCount,
        profileId,
        isCustom,
        folderId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'phrases';
  @override
  VerificationContext validateIntegrity(Insertable<PhrasesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('text')) {
      context.handle(_phraseTextMeta,
          phraseText.isAcceptableOrUnknown(data['text']!, _phraseTextMeta));
    } else if (isInserting) {
      context.missing(_phraseTextMeta);
    }
    if (data.containsKey('context')) {
      context.handle(
          _phraseContextMeta,
          phraseContext.isAcceptableOrUnknown(
              data['context']!, _phraseContextMeta));
    } else if (isInserting) {
      context.missing(_phraseContextMeta);
    }
    if (data.containsKey('subcategory')) {
      context.handle(
          _subcategoryMeta,
          subcategory.isAcceptableOrUnknown(
              data['subcategory']!, _subcategoryMeta));
    }
    if (data.containsKey('age_group')) {
      context.handle(_ageGroupMeta,
          ageGroup.isAcceptableOrUnknown(data['age_group']!, _ageGroupMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('usage_count')) {
      context.handle(
          _usageCountMeta,
          usageCount.isAcceptableOrUnknown(
              data['usage_count']!, _usageCountMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    if (data.containsKey('folder_id')) {
      context.handle(_folderIdMeta,
          folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhrasesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhrasesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      phraseText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      phraseContext: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context'])!,
      subcategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subcategory']),
      ageGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}age_group'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      usageCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usage_count'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id']),
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
      folderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_id']),
    );
  }

  @override
  $PhrasesTableTable createAlias(String alias) {
    return $PhrasesTableTable(attachedDatabase, alias);
  }
}

class PhrasesTableData extends DataClass
    implements Insertable<PhrasesTableData> {
  final String id;
  final String phraseText;
  final String phraseContext;
  final String? subcategory;
  final String ageGroup;
  final String level;
  final bool isFavorite;
  final int usageCount;
  final String? profileId;
  final bool isCustom;
  final String? folderId;
  const PhrasesTableData(
      {required this.id,
      required this.phraseText,
      required this.phraseContext,
      this.subcategory,
      required this.ageGroup,
      required this.level,
      required this.isFavorite,
      required this.usageCount,
      this.profileId,
      required this.isCustom,
      this.folderId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['text'] = Variable<String>(phraseText);
    map['context'] = Variable<String>(phraseContext);
    if (!nullToAbsent || subcategory != null) {
      map['subcategory'] = Variable<String>(subcategory);
    }
    map['age_group'] = Variable<String>(ageGroup);
    map['level'] = Variable<String>(level);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['usage_count'] = Variable<int>(usageCount);
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<String>(profileId);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<String>(folderId);
    }
    return map;
  }

  PhrasesTableCompanion toCompanion(bool nullToAbsent) {
    return PhrasesTableCompanion(
      id: Value(id),
      phraseText: Value(phraseText),
      phraseContext: Value(phraseContext),
      subcategory: subcategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategory),
      ageGroup: Value(ageGroup),
      level: Value(level),
      isFavorite: Value(isFavorite),
      usageCount: Value(usageCount),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
      isCustom: Value(isCustom),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
    );
  }

  factory PhrasesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhrasesTableData(
      id: serializer.fromJson<String>(json['id']),
      phraseText: serializer.fromJson<String>(json['phraseText']),
      phraseContext: serializer.fromJson<String>(json['phraseContext']),
      subcategory: serializer.fromJson<String?>(json['subcategory']),
      ageGroup: serializer.fromJson<String>(json['ageGroup']),
      level: serializer.fromJson<String>(json['level']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      profileId: serializer.fromJson<String?>(json['profileId']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      folderId: serializer.fromJson<String?>(json['folderId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phraseText': serializer.toJson<String>(phraseText),
      'phraseContext': serializer.toJson<String>(phraseContext),
      'subcategory': serializer.toJson<String?>(subcategory),
      'ageGroup': serializer.toJson<String>(ageGroup),
      'level': serializer.toJson<String>(level),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'usageCount': serializer.toJson<int>(usageCount),
      'profileId': serializer.toJson<String?>(profileId),
      'isCustom': serializer.toJson<bool>(isCustom),
      'folderId': serializer.toJson<String?>(folderId),
    };
  }

  PhrasesTableData copyWith(
          {String? id,
          String? phraseText,
          String? phraseContext,
          Value<String?> subcategory = const Value.absent(),
          String? ageGroup,
          String? level,
          bool? isFavorite,
          int? usageCount,
          Value<String?> profileId = const Value.absent(),
          bool? isCustom,
          Value<String?> folderId = const Value.absent()}) =>
      PhrasesTableData(
        id: id ?? this.id,
        phraseText: phraseText ?? this.phraseText,
        phraseContext: phraseContext ?? this.phraseContext,
        subcategory: subcategory.present ? subcategory.value : this.subcategory,
        ageGroup: ageGroup ?? this.ageGroup,
        level: level ?? this.level,
        isFavorite: isFavorite ?? this.isFavorite,
        usageCount: usageCount ?? this.usageCount,
        profileId: profileId.present ? profileId.value : this.profileId,
        isCustom: isCustom ?? this.isCustom,
        folderId: folderId.present ? folderId.value : this.folderId,
      );
  PhrasesTableData copyWithCompanion(PhrasesTableCompanion data) {
    return PhrasesTableData(
      id: data.id.present ? data.id.value : this.id,
      phraseText:
          data.phraseText.present ? data.phraseText.value : this.phraseText,
      phraseContext: data.phraseContext.present
          ? data.phraseContext.value
          : this.phraseContext,
      subcategory:
          data.subcategory.present ? data.subcategory.value : this.subcategory,
      ageGroup: data.ageGroup.present ? data.ageGroup.value : this.ageGroup,
      level: data.level.present ? data.level.value : this.level,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      usageCount:
          data.usageCount.present ? data.usageCount.value : this.usageCount,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhrasesTableData(')
          ..write('id: $id, ')
          ..write('phraseText: $phraseText, ')
          ..write('phraseContext: $phraseContext, ')
          ..write('subcategory: $subcategory, ')
          ..write('ageGroup: $ageGroup, ')
          ..write('level: $level, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('usageCount: $usageCount, ')
          ..write('profileId: $profileId, ')
          ..write('isCustom: $isCustom, ')
          ..write('folderId: $folderId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, phraseText, phraseContext, subcategory,
      ageGroup, level, isFavorite, usageCount, profileId, isCustom, folderId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhrasesTableData &&
          other.id == this.id &&
          other.phraseText == this.phraseText &&
          other.phraseContext == this.phraseContext &&
          other.subcategory == this.subcategory &&
          other.ageGroup == this.ageGroup &&
          other.level == this.level &&
          other.isFavorite == this.isFavorite &&
          other.usageCount == this.usageCount &&
          other.profileId == this.profileId &&
          other.isCustom == this.isCustom &&
          other.folderId == this.folderId);
}

class PhrasesTableCompanion extends UpdateCompanion<PhrasesTableData> {
  final Value<String> id;
  final Value<String> phraseText;
  final Value<String> phraseContext;
  final Value<String?> subcategory;
  final Value<String> ageGroup;
  final Value<String> level;
  final Value<bool> isFavorite;
  final Value<int> usageCount;
  final Value<String?> profileId;
  final Value<bool> isCustom;
  final Value<String?> folderId;
  final Value<int> rowid;
  const PhrasesTableCompanion({
    this.id = const Value.absent(),
    this.phraseText = const Value.absent(),
    this.phraseContext = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.ageGroup = const Value.absent(),
    this.level = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.profileId = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.folderId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhrasesTableCompanion.insert({
    required String id,
    required String phraseText,
    required String phraseContext,
    this.subcategory = const Value.absent(),
    this.ageGroup = const Value.absent(),
    this.level = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.profileId = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.folderId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        phraseText = Value(phraseText),
        phraseContext = Value(phraseContext);
  static Insertable<PhrasesTableData> custom({
    Expression<String>? id,
    Expression<String>? phraseText,
    Expression<String>? phraseContext,
    Expression<String>? subcategory,
    Expression<String>? ageGroup,
    Expression<String>? level,
    Expression<bool>? isFavorite,
    Expression<int>? usageCount,
    Expression<String>? profileId,
    Expression<bool>? isCustom,
    Expression<String>? folderId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phraseText != null) 'text': phraseText,
      if (phraseContext != null) 'context': phraseContext,
      if (subcategory != null) 'subcategory': subcategory,
      if (ageGroup != null) 'age_group': ageGroup,
      if (level != null) 'level': level,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (usageCount != null) 'usage_count': usageCount,
      if (profileId != null) 'profile_id': profileId,
      if (isCustom != null) 'is_custom': isCustom,
      if (folderId != null) 'folder_id': folderId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhrasesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? phraseText,
      Value<String>? phraseContext,
      Value<String?>? subcategory,
      Value<String>? ageGroup,
      Value<String>? level,
      Value<bool>? isFavorite,
      Value<int>? usageCount,
      Value<String?>? profileId,
      Value<bool>? isCustom,
      Value<String?>? folderId,
      Value<int>? rowid}) {
    return PhrasesTableCompanion(
      id: id ?? this.id,
      phraseText: phraseText ?? this.phraseText,
      phraseContext: phraseContext ?? this.phraseContext,
      subcategory: subcategory ?? this.subcategory,
      ageGroup: ageGroup ?? this.ageGroup,
      level: level ?? this.level,
      isFavorite: isFavorite ?? this.isFavorite,
      usageCount: usageCount ?? this.usageCount,
      profileId: profileId ?? this.profileId,
      isCustom: isCustom ?? this.isCustom,
      folderId: folderId ?? this.folderId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phraseText.present) {
      map['text'] = Variable<String>(phraseText.value);
    }
    if (phraseContext.present) {
      map['context'] = Variable<String>(phraseContext.value);
    }
    if (subcategory.present) {
      map['subcategory'] = Variable<String>(subcategory.value);
    }
    if (ageGroup.present) {
      map['age_group'] = Variable<String>(ageGroup.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhrasesTableCompanion(')
          ..write('id: $id, ')
          ..write('phraseText: $phraseText, ')
          ..write('phraseContext: $phraseContext, ')
          ..write('subcategory: $subcategory, ')
          ..write('ageGroup: $ageGroup, ')
          ..write('level: $level, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('usageCount: $usageCount, ')
          ..write('profileId: $profileId, ')
          ..write('isCustom: $isCustom, ')
          ..write('folderId: $folderId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessageHistoryTableTable extends MessageHistoryTable
    with TableInfo<$MessageHistoryTableTable, MessageHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageTextMeta =
      const VerificationMeta('messageText');
  @override
  late final GeneratedColumn<String> messageText = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('typed'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, messageText, profileId, timestamp, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<MessageHistoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('text')) {
      context.handle(_messageTextMeta,
          messageText.isAcceptableOrUnknown(data['text']!, _messageTextMeta));
    } else if (isInserting) {
      context.missing(_messageTextMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageHistoryTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageHistoryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      messageText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
    );
  }

  @override
  $MessageHistoryTableTable createAlias(String alias) {
    return $MessageHistoryTableTable(attachedDatabase, alias);
  }
}

class MessageHistoryTableData extends DataClass
    implements Insertable<MessageHistoryTableData> {
  final String id;
  final String messageText;
  final String profileId;
  final DateTime timestamp;
  final String source;
  const MessageHistoryTableData(
      {required this.id,
      required this.messageText,
      required this.profileId,
      required this.timestamp,
      required this.source});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['text'] = Variable<String>(messageText);
    map['profile_id'] = Variable<String>(profileId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['source'] = Variable<String>(source);
    return map;
  }

  MessageHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return MessageHistoryTableCompanion(
      id: Value(id),
      messageText: Value(messageText),
      profileId: Value(profileId),
      timestamp: Value(timestamp),
      source: Value(source),
    );
  }

  factory MessageHistoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageHistoryTableData(
      id: serializer.fromJson<String>(json['id']),
      messageText: serializer.fromJson<String>(json['messageText']),
      profileId: serializer.fromJson<String>(json['profileId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageText': serializer.toJson<String>(messageText),
      'profileId': serializer.toJson<String>(profileId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'source': serializer.toJson<String>(source),
    };
  }

  MessageHistoryTableData copyWith(
          {String? id,
          String? messageText,
          String? profileId,
          DateTime? timestamp,
          String? source}) =>
      MessageHistoryTableData(
        id: id ?? this.id,
        messageText: messageText ?? this.messageText,
        profileId: profileId ?? this.profileId,
        timestamp: timestamp ?? this.timestamp,
        source: source ?? this.source,
      );
  MessageHistoryTableData copyWithCompanion(MessageHistoryTableCompanion data) {
    return MessageHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      messageText:
          data.messageText.present ? data.messageText.value : this.messageText,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageHistoryTableData(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('profileId: $profileId, ')
          ..write('timestamp: $timestamp, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, messageText, profileId, timestamp, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageHistoryTableData &&
          other.id == this.id &&
          other.messageText == this.messageText &&
          other.profileId == this.profileId &&
          other.timestamp == this.timestamp &&
          other.source == this.source);
}

class MessageHistoryTableCompanion
    extends UpdateCompanion<MessageHistoryTableData> {
  final Value<String> id;
  final Value<String> messageText;
  final Value<String> profileId;
  final Value<DateTime> timestamp;
  final Value<String> source;
  final Value<int> rowid;
  const MessageHistoryTableCompanion({
    this.id = const Value.absent(),
    this.messageText = const Value.absent(),
    this.profileId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageHistoryTableCompanion.insert({
    required String id,
    required String messageText,
    required String profileId,
    required DateTime timestamp,
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        messageText = Value(messageText),
        profileId = Value(profileId),
        timestamp = Value(timestamp);
  static Insertable<MessageHistoryTableData> custom({
    Expression<String>? id,
    Expression<String>? messageText,
    Expression<String>? profileId,
    Expression<DateTime>? timestamp,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageText != null) 'text': messageText,
      if (profileId != null) 'profile_id': profileId,
      if (timestamp != null) 'timestamp': timestamp,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageHistoryTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? messageText,
      Value<String>? profileId,
      Value<DateTime>? timestamp,
      Value<String>? source,
      Value<int>? rowid}) {
    return MessageHistoryTableCompanion(
      id: id ?? this.id,
      messageText: messageText ?? this.messageText,
      profileId: profileId ?? this.profileId,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageText.present) {
      map['text'] = Variable<String>(messageText.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('profileId: $profileId, ')
          ..write('timestamp: $timestamp, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _settingKeyMeta =
      const VerificationMeta('settingKey');
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _settingValueMeta =
      const VerificationMeta('settingValue');
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue, profileId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<SettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_settingKeyMeta,
          settingKey.isAcceptableOrUnknown(data['key']!, _settingKeyMeta));
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _settingValueMeta,
          settingValue.isAcceptableOrUnknown(
              data['value']!, _settingValueMeta));
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey, profileId};
  @override
  SettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsTableData(
      settingKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      settingValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id']),
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsTableData extends DataClass
    implements Insertable<SettingsTableData> {
  final String settingKey;
  final String settingValue;
  final String? profileId;
  const SettingsTableData(
      {required this.settingKey, required this.settingValue, this.profileId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(settingKey);
    map['value'] = Variable<String>(settingValue);
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<String>(profileId);
    }
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
    );
  }

  factory SettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsTableData(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
      profileId: serializer.fromJson<String?>(json['profileId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
      'profileId': serializer.toJson<String?>(profileId),
    };
  }

  SettingsTableData copyWith(
          {String? settingKey,
          String? settingValue,
          Value<String?> profileId = const Value.absent()}) =>
      SettingsTableData(
        settingKey: settingKey ?? this.settingKey,
        settingValue: settingValue ?? this.settingValue,
        profileId: profileId.present ? profileId.value : this.profileId,
      );
  SettingsTableData copyWithCompanion(SettingsTableCompanion data) {
    return SettingsTableData(
      settingKey:
          data.settingKey.present ? data.settingKey.value : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableData(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('profileId: $profileId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue, profileId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsTableData &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue &&
          other.profileId == this.profileId);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsTableData> {
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<String?> profileId;
  final Value<int> rowid;
  const SettingsTableCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.profileId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    required String settingKey,
    required String settingValue,
    this.profileId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : settingKey = Value(settingKey),
        settingValue = Value(settingValue);
  static Insertable<SettingsTableData> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<String>? profileId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'key': settingKey,
      if (settingValue != null) 'value': settingValue,
      if (profileId != null) 'profile_id': profileId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsTableCompanion copyWith(
      {Value<String>? settingKey,
      Value<String>? settingValue,
      Value<String?>? profileId,
      Value<int>? rowid}) {
    return SettingsTableCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      profileId: profileId ?? this.profileId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['value'] = Variable<String>(settingValue.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('profileId: $profileId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTableTable profilesTable = $ProfilesTableTable(this);
  late final $BoardsTableTable boardsTable = $BoardsTableTable(this);
  late final $VocabularyTableTable vocabularyTable =
      $VocabularyTableTable(this);
  late final $PhrasesTableTable phrasesTable = $PhrasesTableTable(this);
  late final $MessageHistoryTableTable messageHistoryTable =
      $MessageHistoryTableTable(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final ProfileDao profileDao = ProfileDao(this as AppDatabase);
  late final BoardDao boardDao = BoardDao(this as AppDatabase);
  late final VocabularyDao vocabularyDao = VocabularyDao(this as AppDatabase);
  late final PhraseDao phraseDao = PhraseDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        profilesTable,
        boardsTable,
        vocabularyTable,
        phrasesTable,
        messageHistoryTable,
        settingsTable
      ];
}

typedef $$ProfilesTableTableCreateCompanionBuilder = ProfilesTableCompanion
    Function({
  required String id,
  required String name,
  Value<String?> avatarPath,
  required String diagnosis,
  Value<int> gridSize,
  Value<String> disposition,
  Value<String?> activeBoardId,
  Value<String?> voiceId,
  Value<String> language,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> isDefault,
  Value<int> rowid,
});
typedef $$ProfilesTableTableUpdateCompanionBuilder = ProfilesTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> avatarPath,
  Value<String> diagnosis,
  Value<int> gridSize,
  Value<String> disposition,
  Value<String?> activeBoardId,
  Value<String?> voiceId,
  Value<String> language,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isDefault,
  Value<int> rowid,
});

class $$ProfilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTableTable> {
  $$ProfilesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get diagnosis => $composableBuilder(
      column: $table.diagnosis, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gridSize => $composableBuilder(
      column: $table.gridSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get disposition => $composableBuilder(
      column: $table.disposition, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activeBoardId => $composableBuilder(
      column: $table.activeBoardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voiceId => $composableBuilder(
      column: $table.voiceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));
}

class $$ProfilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTableTable> {
  $$ProfilesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get diagnosis => $composableBuilder(
      column: $table.diagnosis, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gridSize => $composableBuilder(
      column: $table.gridSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get disposition => $composableBuilder(
      column: $table.disposition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activeBoardId => $composableBuilder(
      column: $table.activeBoardId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voiceId => $composableBuilder(
      column: $table.voiceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));
}

class $$ProfilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTableTable> {
  $$ProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  GeneratedColumn<String> get diagnosis =>
      $composableBuilder(column: $table.diagnosis, builder: (column) => column);

  GeneratedColumn<int> get gridSize =>
      $composableBuilder(column: $table.gridSize, builder: (column) => column);

  GeneratedColumn<String> get disposition => $composableBuilder(
      column: $table.disposition, builder: (column) => column);

  GeneratedColumn<String> get activeBoardId => $composableBuilder(
      column: $table.activeBoardId, builder: (column) => column);

  GeneratedColumn<String> get voiceId =>
      $composableBuilder(column: $table.voiceId, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);
}

class $$ProfilesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProfilesTableTable,
    ProfilesTableData,
    $$ProfilesTableTableFilterComposer,
    $$ProfilesTableTableOrderingComposer,
    $$ProfilesTableTableAnnotationComposer,
    $$ProfilesTableTableCreateCompanionBuilder,
    $$ProfilesTableTableUpdateCompanionBuilder,
    (
      ProfilesTableData,
      BaseReferences<_$AppDatabase, $ProfilesTableTable, ProfilesTableData>
    ),
    ProfilesTableData,
    PrefetchHooks Function()> {
  $$ProfilesTableTableTableManager(_$AppDatabase db, $ProfilesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<String> diagnosis = const Value.absent(),
            Value<int> gridSize = const Value.absent(),
            Value<String> disposition = const Value.absent(),
            Value<String?> activeBoardId = const Value.absent(),
            Value<String?> voiceId = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesTableCompanion(
            id: id,
            name: name,
            avatarPath: avatarPath,
            diagnosis: diagnosis,
            gridSize: gridSize,
            disposition: disposition,
            activeBoardId: activeBoardId,
            voiceId: voiceId,
            language: language,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isDefault: isDefault,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> avatarPath = const Value.absent(),
            required String diagnosis,
            Value<int> gridSize = const Value.absent(),
            Value<String> disposition = const Value.absent(),
            Value<String?> activeBoardId = const Value.absent(),
            Value<String?> voiceId = const Value.absent(),
            Value<String> language = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> isDefault = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesTableCompanion.insert(
            id: id,
            name: name,
            avatarPath: avatarPath,
            diagnosis: diagnosis,
            gridSize: gridSize,
            disposition: disposition,
            activeBoardId: activeBoardId,
            voiceId: voiceId,
            language: language,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isDefault: isDefault,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProfilesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProfilesTableTable,
    ProfilesTableData,
    $$ProfilesTableTableFilterComposer,
    $$ProfilesTableTableOrderingComposer,
    $$ProfilesTableTableAnnotationComposer,
    $$ProfilesTableTableCreateCompanionBuilder,
    $$ProfilesTableTableUpdateCompanionBuilder,
    (
      ProfilesTableData,
      BaseReferences<_$AppDatabase, $ProfilesTableTable, ProfilesTableData>
    ),
    ProfilesTableData,
    PrefetchHooks Function()>;
typedef $$BoardsTableTableCreateCompanionBuilder = BoardsTableCompanion
    Function({
  required String id,
  required String name,
  Value<String?> description,
  Value<String?> profileId,
  Value<String?> parentId,
  Value<bool> isActive,
  Value<String> vocabularyType,
  Value<int> buttonCount,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String> exportFormat,
  Value<int> rowid,
});
typedef $$BoardsTableTableUpdateCompanionBuilder = BoardsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String?> profileId,
  Value<String?> parentId,
  Value<bool> isActive,
  Value<String> vocabularyType,
  Value<int> buttonCount,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> exportFormat,
  Value<int> rowid,
});

class $$BoardsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BoardsTableTable> {
  $$BoardsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vocabularyType => $composableBuilder(
      column: $table.vocabularyType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get buttonCount => $composableBuilder(
      column: $table.buttonCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exportFormat => $composableBuilder(
      column: $table.exportFormat, builder: (column) => ColumnFilters(column));
}

class $$BoardsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BoardsTableTable> {
  $$BoardsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vocabularyType => $composableBuilder(
      column: $table.vocabularyType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get buttonCount => $composableBuilder(
      column: $table.buttonCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exportFormat => $composableBuilder(
      column: $table.exportFormat,
      builder: (column) => ColumnOrderings(column));
}

class $$BoardsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BoardsTableTable> {
  $$BoardsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get vocabularyType => $composableBuilder(
      column: $table.vocabularyType, builder: (column) => column);

  GeneratedColumn<int> get buttonCount => $composableBuilder(
      column: $table.buttonCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get exportFormat => $composableBuilder(
      column: $table.exportFormat, builder: (column) => column);
}

class $$BoardsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BoardsTableTable,
    BoardsTableData,
    $$BoardsTableTableFilterComposer,
    $$BoardsTableTableOrderingComposer,
    $$BoardsTableTableAnnotationComposer,
    $$BoardsTableTableCreateCompanionBuilder,
    $$BoardsTableTableUpdateCompanionBuilder,
    (
      BoardsTableData,
      BaseReferences<_$AppDatabase, $BoardsTableTable, BoardsTableData>
    ),
    BoardsTableData,
    PrefetchHooks Function()> {
  $$BoardsTableTableTableManager(_$AppDatabase db, $BoardsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BoardsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BoardsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BoardsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> vocabularyType = const Value.absent(),
            Value<int> buttonCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> exportFormat = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BoardsTableCompanion(
            id: id,
            name: name,
            description: description,
            profileId: profileId,
            parentId: parentId,
            isActive: isActive,
            vocabularyType: vocabularyType,
            buttonCount: buttonCount,
            createdAt: createdAt,
            updatedAt: updatedAt,
            exportFormat: exportFormat,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> vocabularyType = const Value.absent(),
            Value<int> buttonCount = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String> exportFormat = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BoardsTableCompanion.insert(
            id: id,
            name: name,
            description: description,
            profileId: profileId,
            parentId: parentId,
            isActive: isActive,
            vocabularyType: vocabularyType,
            buttonCount: buttonCount,
            createdAt: createdAt,
            updatedAt: updatedAt,
            exportFormat: exportFormat,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BoardsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BoardsTableTable,
    BoardsTableData,
    $$BoardsTableTableFilterComposer,
    $$BoardsTableTableOrderingComposer,
    $$BoardsTableTableAnnotationComposer,
    $$BoardsTableTableCreateCompanionBuilder,
    $$BoardsTableTableUpdateCompanionBuilder,
    (
      BoardsTableData,
      BaseReferences<_$AppDatabase, $BoardsTableTable, BoardsTableData>
    ),
    BoardsTableData,
    PrefetchHooks Function()>;
typedef $$VocabularyTableTableCreateCompanionBuilder = VocabularyTableCompanion
    Function({
  required String id,
  required String label,
  Value<String?> message,
  Value<String?> symbolPath,
  required String category,
  Value<String?> subcategory,
  Value<String> fitzgeraldCategory,
  Value<String> skinTone,
  Value<String> hairColor,
  Value<String> grammarRole,
  Value<String?> linkedBoardId,
  Value<bool> isCore,
  Value<int> sortOrder,
  Value<int> usageCount,
  Value<bool> isFavorite,
  Value<String?> profileId,
  Value<int> rowid,
});
typedef $$VocabularyTableTableUpdateCompanionBuilder = VocabularyTableCompanion
    Function({
  Value<String> id,
  Value<String> label,
  Value<String?> message,
  Value<String?> symbolPath,
  Value<String> category,
  Value<String?> subcategory,
  Value<String> fitzgeraldCategory,
  Value<String> skinTone,
  Value<String> hairColor,
  Value<String> grammarRole,
  Value<String?> linkedBoardId,
  Value<bool> isCore,
  Value<int> sortOrder,
  Value<int> usageCount,
  Value<bool> isFavorite,
  Value<String?> profileId,
  Value<int> rowid,
});

class $$VocabularyTableTableFilterComposer
    extends Composer<_$AppDatabase, $VocabularyTableTable> {
  $$VocabularyTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbolPath => $composableBuilder(
      column: $table.symbolPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fitzgeraldCategory => $composableBuilder(
      column: $table.fitzgeraldCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get skinTone => $composableBuilder(
      column: $table.skinTone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hairColor => $composableBuilder(
      column: $table.hairColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get grammarRole => $composableBuilder(
      column: $table.grammarRole, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedBoardId => $composableBuilder(
      column: $table.linkedBoardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCore => $composableBuilder(
      column: $table.isCore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));
}

class $$VocabularyTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabularyTableTable> {
  $$VocabularyTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbolPath => $composableBuilder(
      column: $table.symbolPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fitzgeraldCategory => $composableBuilder(
      column: $table.fitzgeraldCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get skinTone => $composableBuilder(
      column: $table.skinTone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hairColor => $composableBuilder(
      column: $table.hairColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get grammarRole => $composableBuilder(
      column: $table.grammarRole, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedBoardId => $composableBuilder(
      column: $table.linkedBoardId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCore => $composableBuilder(
      column: $table.isCore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));
}

class $$VocabularyTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabularyTableTable> {
  $$VocabularyTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get symbolPath => $composableBuilder(
      column: $table.symbolPath, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => column);

  GeneratedColumn<String> get fitzgeraldCategory => $composableBuilder(
      column: $table.fitzgeraldCategory, builder: (column) => column);

  GeneratedColumn<String> get skinTone =>
      $composableBuilder(column: $table.skinTone, builder: (column) => column);

  GeneratedColumn<String> get hairColor =>
      $composableBuilder(column: $table.hairColor, builder: (column) => column);

  GeneratedColumn<String> get grammarRole => $composableBuilder(
      column: $table.grammarRole, builder: (column) => column);

  GeneratedColumn<String> get linkedBoardId => $composableBuilder(
      column: $table.linkedBoardId, builder: (column) => column);

  GeneratedColumn<bool> get isCore =>
      $composableBuilder(column: $table.isCore, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);
}

class $$VocabularyTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VocabularyTableTable,
    VocabularyTableData,
    $$VocabularyTableTableFilterComposer,
    $$VocabularyTableTableOrderingComposer,
    $$VocabularyTableTableAnnotationComposer,
    $$VocabularyTableTableCreateCompanionBuilder,
    $$VocabularyTableTableUpdateCompanionBuilder,
    (
      VocabularyTableData,
      BaseReferences<_$AppDatabase, $VocabularyTableTable, VocabularyTableData>
    ),
    VocabularyTableData,
    PrefetchHooks Function()> {
  $$VocabularyTableTableTableManager(
      _$AppDatabase db, $VocabularyTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabularyTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabularyTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabularyTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String?> message = const Value.absent(),
            Value<String?> symbolPath = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String> fitzgeraldCategory = const Value.absent(),
            Value<String> skinTone = const Value.absent(),
            Value<String> hairColor = const Value.absent(),
            Value<String> grammarRole = const Value.absent(),
            Value<String?> linkedBoardId = const Value.absent(),
            Value<bool> isCore = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> usageCount = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VocabularyTableCompanion(
            id: id,
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
            usageCount: usageCount,
            isFavorite: isFavorite,
            profileId: profileId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String label,
            Value<String?> message = const Value.absent(),
            Value<String?> symbolPath = const Value.absent(),
            required String category,
            Value<String?> subcategory = const Value.absent(),
            Value<String> fitzgeraldCategory = const Value.absent(),
            Value<String> skinTone = const Value.absent(),
            Value<String> hairColor = const Value.absent(),
            Value<String> grammarRole = const Value.absent(),
            Value<String?> linkedBoardId = const Value.absent(),
            Value<bool> isCore = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> usageCount = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VocabularyTableCompanion.insert(
            id: id,
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
            usageCount: usageCount,
            isFavorite: isFavorite,
            profileId: profileId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VocabularyTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VocabularyTableTable,
    VocabularyTableData,
    $$VocabularyTableTableFilterComposer,
    $$VocabularyTableTableOrderingComposer,
    $$VocabularyTableTableAnnotationComposer,
    $$VocabularyTableTableCreateCompanionBuilder,
    $$VocabularyTableTableUpdateCompanionBuilder,
    (
      VocabularyTableData,
      BaseReferences<_$AppDatabase, $VocabularyTableTable, VocabularyTableData>
    ),
    VocabularyTableData,
    PrefetchHooks Function()>;
typedef $$PhrasesTableTableCreateCompanionBuilder = PhrasesTableCompanion
    Function({
  required String id,
  required String phraseText,
  required String phraseContext,
  Value<String?> subcategory,
  Value<String> ageGroup,
  Value<String> level,
  Value<bool> isFavorite,
  Value<int> usageCount,
  Value<String?> profileId,
  Value<bool> isCustom,
  Value<String?> folderId,
  Value<int> rowid,
});
typedef $$PhrasesTableTableUpdateCompanionBuilder = PhrasesTableCompanion
    Function({
  Value<String> id,
  Value<String> phraseText,
  Value<String> phraseContext,
  Value<String?> subcategory,
  Value<String> ageGroup,
  Value<String> level,
  Value<bool> isFavorite,
  Value<int> usageCount,
  Value<String?> profileId,
  Value<bool> isCustom,
  Value<String?> folderId,
  Value<int> rowid,
});

class $$PhrasesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PhrasesTableTable> {
  $$PhrasesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phraseText => $composableBuilder(
      column: $table.phraseText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phraseContext => $composableBuilder(
      column: $table.phraseContext, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ageGroup => $composableBuilder(
      column: $table.ageGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get folderId => $composableBuilder(
      column: $table.folderId, builder: (column) => ColumnFilters(column));
}

class $$PhrasesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PhrasesTableTable> {
  $$PhrasesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phraseText => $composableBuilder(
      column: $table.phraseText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phraseContext => $composableBuilder(
      column: $table.phraseContext,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ageGroup => $composableBuilder(
      column: $table.ageGroup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get folderId => $composableBuilder(
      column: $table.folderId, builder: (column) => ColumnOrderings(column));
}

class $$PhrasesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhrasesTableTable> {
  $$PhrasesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phraseText => $composableBuilder(
      column: $table.phraseText, builder: (column) => column);

  GeneratedColumn<String> get phraseContext => $composableBuilder(
      column: $table.phraseContext, builder: (column) => column);

  GeneratedColumn<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => column);

  GeneratedColumn<String> get ageGroup =>
      $composableBuilder(column: $table.ageGroup, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<String> get folderId =>
      $composableBuilder(column: $table.folderId, builder: (column) => column);
}

class $$PhrasesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PhrasesTableTable,
    PhrasesTableData,
    $$PhrasesTableTableFilterComposer,
    $$PhrasesTableTableOrderingComposer,
    $$PhrasesTableTableAnnotationComposer,
    $$PhrasesTableTableCreateCompanionBuilder,
    $$PhrasesTableTableUpdateCompanionBuilder,
    (
      PhrasesTableData,
      BaseReferences<_$AppDatabase, $PhrasesTableTable, PhrasesTableData>
    ),
    PhrasesTableData,
    PrefetchHooks Function()> {
  $$PhrasesTableTableTableManager(_$AppDatabase db, $PhrasesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhrasesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhrasesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhrasesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> phraseText = const Value.absent(),
            Value<String> phraseContext = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String> ageGroup = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<int> usageCount = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<String?> folderId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhrasesTableCompanion(
            id: id,
            phraseText: phraseText,
            phraseContext: phraseContext,
            subcategory: subcategory,
            ageGroup: ageGroup,
            level: level,
            isFavorite: isFavorite,
            usageCount: usageCount,
            profileId: profileId,
            isCustom: isCustom,
            folderId: folderId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String phraseText,
            required String phraseContext,
            Value<String?> subcategory = const Value.absent(),
            Value<String> ageGroup = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<int> usageCount = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<String?> folderId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhrasesTableCompanion.insert(
            id: id,
            phraseText: phraseText,
            phraseContext: phraseContext,
            subcategory: subcategory,
            ageGroup: ageGroup,
            level: level,
            isFavorite: isFavorite,
            usageCount: usageCount,
            profileId: profileId,
            isCustom: isCustom,
            folderId: folderId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PhrasesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PhrasesTableTable,
    PhrasesTableData,
    $$PhrasesTableTableFilterComposer,
    $$PhrasesTableTableOrderingComposer,
    $$PhrasesTableTableAnnotationComposer,
    $$PhrasesTableTableCreateCompanionBuilder,
    $$PhrasesTableTableUpdateCompanionBuilder,
    (
      PhrasesTableData,
      BaseReferences<_$AppDatabase, $PhrasesTableTable, PhrasesTableData>
    ),
    PhrasesTableData,
    PrefetchHooks Function()>;
typedef $$MessageHistoryTableTableCreateCompanionBuilder
    = MessageHistoryTableCompanion Function({
  required String id,
  required String messageText,
  required String profileId,
  required DateTime timestamp,
  Value<String> source,
  Value<int> rowid,
});
typedef $$MessageHistoryTableTableUpdateCompanionBuilder
    = MessageHistoryTableCompanion Function({
  Value<String> id,
  Value<String> messageText,
  Value<String> profileId,
  Value<DateTime> timestamp,
  Value<String> source,
  Value<int> rowid,
});

class $$MessageHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $MessageHistoryTableTable> {
  $$MessageHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messageText => $composableBuilder(
      column: $table.messageText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));
}

class $$MessageHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MessageHistoryTableTable> {
  $$MessageHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messageText => $composableBuilder(
      column: $table.messageText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));
}

class $$MessageHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessageHistoryTableTable> {
  $$MessageHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageText => $composableBuilder(
      column: $table.messageText, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$MessageHistoryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MessageHistoryTableTable,
    MessageHistoryTableData,
    $$MessageHistoryTableTableFilterComposer,
    $$MessageHistoryTableTableOrderingComposer,
    $$MessageHistoryTableTableAnnotationComposer,
    $$MessageHistoryTableTableCreateCompanionBuilder,
    $$MessageHistoryTableTableUpdateCompanionBuilder,
    (
      MessageHistoryTableData,
      BaseReferences<_$AppDatabase, $MessageHistoryTableTable,
          MessageHistoryTableData>
    ),
    MessageHistoryTableData,
    PrefetchHooks Function()> {
  $$MessageHistoryTableTableTableManager(
      _$AppDatabase db, $MessageHistoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageHistoryTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageHistoryTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> messageText = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessageHistoryTableCompanion(
            id: id,
            messageText: messageText,
            profileId: profileId,
            timestamp: timestamp,
            source: source,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String messageText,
            required String profileId,
            required DateTime timestamp,
            Value<String> source = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessageHistoryTableCompanion.insert(
            id: id,
            messageText: messageText,
            profileId: profileId,
            timestamp: timestamp,
            source: source,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MessageHistoryTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MessageHistoryTableTable,
    MessageHistoryTableData,
    $$MessageHistoryTableTableFilterComposer,
    $$MessageHistoryTableTableOrderingComposer,
    $$MessageHistoryTableTableAnnotationComposer,
    $$MessageHistoryTableTableCreateCompanionBuilder,
    $$MessageHistoryTableTableUpdateCompanionBuilder,
    (
      MessageHistoryTableData,
      BaseReferences<_$AppDatabase, $MessageHistoryTableTable,
          MessageHistoryTableData>
    ),
    MessageHistoryTableData,
    PrefetchHooks Function()>;
typedef $$SettingsTableTableCreateCompanionBuilder = SettingsTableCompanion
    Function({
  required String settingKey,
  required String settingValue,
  Value<String?> profileId,
  Value<int> rowid,
});
typedef $$SettingsTableTableUpdateCompanionBuilder = SettingsTableCompanion
    Function({
  Value<String> settingKey,
  Value<String> settingValue,
  Value<String?> profileId,
  Value<int> rowid,
});

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get settingKey => $composableBuilder(
      column: $table.settingKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get settingValue => $composableBuilder(
      column: $table.settingValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get settingKey => $composableBuilder(
      column: $table.settingKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get settingValue => $composableBuilder(
      column: $table.settingValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get settingKey => $composableBuilder(
      column: $table.settingKey, builder: (column) => column);

  GeneratedColumn<String> get settingValue => $composableBuilder(
      column: $table.settingValue, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);
}

class $$SettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTableTable,
    SettingsTableData,
    $$SettingsTableTableFilterComposer,
    $$SettingsTableTableOrderingComposer,
    $$SettingsTableTableAnnotationComposer,
    $$SettingsTableTableCreateCompanionBuilder,
    $$SettingsTableTableUpdateCompanionBuilder,
    (
      SettingsTableData,
      BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>
    ),
    SettingsTableData,
    PrefetchHooks Function()> {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> settingKey = const Value.absent(),
            Value<String> settingValue = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsTableCompanion(
            settingKey: settingKey,
            settingValue: settingValue,
            profileId: profileId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String settingKey,
            required String settingValue,
            Value<String?> profileId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsTableCompanion.insert(
            settingKey: settingKey,
            settingValue: settingValue,
            profileId: profileId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTableTable,
    SettingsTableData,
    $$SettingsTableTableFilterComposer,
    $$SettingsTableTableOrderingComposer,
    $$SettingsTableTableAnnotationComposer,
    $$SettingsTableTableCreateCompanionBuilder,
    $$SettingsTableTableUpdateCompanionBuilder,
    (
      SettingsTableData,
      BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>
    ),
    SettingsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableTableManager get profilesTable =>
      $$ProfilesTableTableTableManager(_db, _db.profilesTable);
  $$BoardsTableTableTableManager get boardsTable =>
      $$BoardsTableTableTableManager(_db, _db.boardsTable);
  $$VocabularyTableTableTableManager get vocabularyTable =>
      $$VocabularyTableTableTableManager(_db, _db.vocabularyTable);
  $$PhrasesTableTableTableManager get phrasesTable =>
      $$PhrasesTableTableTableManager(_db, _db.phrasesTable);
  $$MessageHistoryTableTableTableManager get messageHistoryTable =>
      $$MessageHistoryTableTableTableManager(_db, _db.messageHistoryTable);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
}

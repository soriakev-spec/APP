import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/profile_dao.dart';
import 'daos/board_dao.dart';
import 'daos/vocabulary_dao.dart';
import 'daos/phrase_dao.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

class ProfilesTable extends Table {
  @override
  String get tableName => 'profiles';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get avatarPath => text().nullable()();
  TextColumn get diagnosis => text()(); // DiagnosisType.name
  IntColumn get gridSize => integer().withDefault(const Constant(9))();
  TextColumn get disposition => text().withDefault(const Constant('pictograms'))();
  TextColumn get activeBoardId => text().nullable()();
  TextColumn get voiceId => text().nullable()();
  TextColumn get language => text().withDefault(const Constant('es'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class BoardsTable extends Table {
  @override
  String get tableName => 'boards';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get profileId => text().nullable()();
  TextColumn get parentId => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get vocabularyType => text().withDefault(const Constant('core_first'))();
  IntColumn get buttonCount => integer().withDefault(const Constant(16))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get exportFormat => text().withDefault(const Constant('habla_json'))();

  @override
  Set<Column> get primaryKey => {id};
}

class VocabularyTable extends Table {
  @override
  String get tableName => 'vocabulary';

  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get message => text().nullable()();
  TextColumn get symbolPath => text().nullable()();
  TextColumn get category => text()();
  TextColumn get subcategory => text().nullable()();
  TextColumn get fitzgeraldCategory => text().withDefault(const Constant('other'))();
  TextColumn get skinTone => text().withDefault(const Constant('default_tone'))();
  TextColumn get hairColor => text().withDefault(const Constant('default_color'))();
  TextColumn get grammarRole => text().withDefault(const Constant('other'))();
  TextColumn get linkedBoardId => text().nullable()();
  BoolColumn get isCore => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get profileId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PhrasesTable extends Table {
  @override
  String get tableName => 'phrases';

  // 'text' and 'context' are safe getter names; Drift uses the getter name
  // as column name but 'text' conflicts with the Table.text() builder method.
  // We rename the getter and use .named() so the SQL column stays 'text'.
  TextColumn get id => text()();
  TextColumn get phraseText => text().named('text')();
  TextColumn get phraseContext => text().named('context')();
  TextColumn get subcategory => text().nullable()();
  TextColumn get ageGroup => text().withDefault(const Constant('child'))();
  TextColumn get level => text().withDefault(const Constant('phrase'))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  TextColumn get profileId => text().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  TextColumn get folderId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MessageHistoryTable extends Table {
  @override
  String get tableName => 'message_history';

  TextColumn get id => text()();
  // 'text' conflicts with Table.text() builder; use named() to keep SQL name.
  TextColumn get messageText => text().named('text')();
  TextColumn get profileId => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get source => text().withDefault(const Constant('typed'))();

  @override
  Set<Column> get primaryKey => {id};
}

class SettingsTable extends Table {
  @override
  String get tableName => 'settings';

  // 'key' conflicts with Map.key — use settingKey getter with named() override.
  TextColumn get settingKey => text().named('key')();
  TextColumn get settingValue => text().named('value')();
  TextColumn get profileId => text().nullable()();

  @override
  Set<Column> get primaryKey => {settingKey, profileId};
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(
  tables: [
    ProfilesTable,
    BoardsTable,
    VocabularyTable,
    PhrasesTable,
    MessageHistoryTable,
    SettingsTable,
  ],
  daos: [
    ProfileDao,
    BoardDao,
    VocabularyDao,
    PhraseDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations go here
        },
      );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'habla_db');
}

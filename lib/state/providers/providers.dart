import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/vocabulary_item.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/message_history.dart';
import '../../services/tts/tts_engine.dart';
import '../../services/tts/system_tts_engine.dart';
import '../../services/ai/ai_service.dart';

// ---------------------------------------------------------------------------
// Settings state
// ---------------------------------------------------------------------------

class SettingsState {
  final bool auditoryFeedback;
  final bool scanningMode;
  final double scanSpeed;
  final bool highContrast;
  final double symbolScale;
  final bool showLabels;
  final String language;
  final double ttsRate;
  final double ttsPitch;
  final double ttsVolume;

  const SettingsState({
    this.auditoryFeedback = true,
    this.scanningMode = false,
    this.scanSpeed = 2.0,
    this.highContrast = false,
    this.symbolScale = 1.0,
    this.showLabels = true,
    this.language = 'es-MX',
    this.ttsRate = 0.45,
    this.ttsPitch = 1.0,
    this.ttsVolume = 1.0,
  });

  SettingsState copyWith({
    bool? auditoryFeedback,
    bool? scanningMode,
    double? scanSpeed,
    bool? highContrast,
    double? symbolScale,
    bool? showLabels,
    String? language,
    double? ttsRate,
    double? ttsPitch,
    double? ttsVolume,
  }) {
    return SettingsState(
      auditoryFeedback: auditoryFeedback ?? this.auditoryFeedback,
      scanningMode: scanningMode ?? this.scanningMode,
      scanSpeed: scanSpeed ?? this.scanSpeed,
      highContrast: highContrast ?? this.highContrast,
      symbolScale: symbolScale ?? this.symbolScale,
      showLabels: showLabels ?? this.showLabels,
      language: language ?? this.language,
      ttsRate: ttsRate ?? this.ttsRate,
      ttsPitch: ttsPitch ?? this.ttsPitch,
      ttsVolume: ttsVolume ?? this.ttsVolume,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void setAuditoryFeedback(bool value) =>
      state = state.copyWith(auditoryFeedback: value);
  void setScanningMode(bool value) =>
      state = state.copyWith(scanningMode: value);
  void setHighContrast(bool value) =>
      state = state.copyWith(highContrast: value);
  void setSymbolScale(double value) =>
      state = state.copyWith(symbolScale: value);
  void setShowLabels(bool value) =>
      state = state.copyWith(showLabels: value);
  void setLanguage(String value) =>
      state = state.copyWith(language: value);
  void setTtsRate(double value) =>
      state = state.copyWith(ttsRate: value);
  void setTtsPitch(double value) =>
      state = state.copyWith(ttsPitch: value);
  void setTtsVolume(double value) =>
      state = state.copyWith(ttsVolume: value);
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

// ---------------------------------------------------------------------------
// Active profile state
// ---------------------------------------------------------------------------

class ActiveProfileNotifier extends Notifier<Profile?> {
  @override
  Profile? build() => Profile(
        id: 'default',
        name: 'Usuario',
        diagnosis: DiagnosisType.child,
        gridSize: 15,
        disposition: BoardDisposition.pictograms,
        language: 'es-MX',
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
        isDefault: true,
      );

  void setProfile(Profile profile) => state = profile;
  void clearProfile() => state = null;

  void updateGridSize(int size) {
    if (state != null) state = state!.copyWith(gridSize: size);
  }

  void updateDisposition(BoardDisposition disposition) {
    if (state != null) state = state!.copyWith(disposition: disposition);
  }
}

final activeProfileProvider =
    NotifierProvider<ActiveProfileNotifier, Profile?>(
        ActiveProfileNotifier.new);

// ---------------------------------------------------------------------------
// All profiles state
// ---------------------------------------------------------------------------

class ProfilesNotifier extends Notifier<List<Profile>> {
  @override
  List<Profile> build() => [
        Profile(
          id: 'default',
          name: 'Usuario',
          diagnosis: DiagnosisType.child,
          gridSize: 15,
          disposition: BoardDisposition.pictograms,
          language: 'es-MX',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
          isDefault: true,
        ),
      ];

  void addProfile(Profile profile) => state = [...state, profile];

  void updateProfile(Profile profile) {
    state = [
      for (final p in state)
        if (p.id == profile.id) profile else p,
    ];
  }

  void deleteProfile(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  void setDefault(String id) {
    state = [
      for (final p in state) p.copyWith(isDefault: p.id == id),
    ];
    final active = state.firstWhere((p) => p.id == id, orElse: () => state.first);
    ref.read(activeProfileProvider.notifier).setProfile(active);
  }
}

final profilesProvider =
    NotifierProvider<ProfilesNotifier, List<Profile>>(ProfilesNotifier.new);

// ---------------------------------------------------------------------------
// Grid size provider (derived from active profile, can be overridden)
// ---------------------------------------------------------------------------

final gridSizeProvider = StateProvider<int>((ref) {
  final profile = ref.watch(activeProfileProvider);
  return profile?.gridSize ?? 15;
});

// ---------------------------------------------------------------------------
// Message bar state
// ---------------------------------------------------------------------------

class MessageBarState {
  final List<String> words;
  final bool isAiExpanding;

  const MessageBarState({
    this.words = const [],
    this.isAiExpanding = false,
  });

  MessageBarState copyWith({
    List<String>? words,
    bool? isAiExpanding,
  }) {
    return MessageBarState(
      words: words ?? this.words,
      isAiExpanding: isAiExpanding ?? this.isAiExpanding,
    );
  }

  String get fullText => words.join(' ');
  bool get isEmpty => words.isEmpty;
}

class MessageBarNotifier extends Notifier<MessageBarState> {
  @override
  MessageBarState build() => const MessageBarState();

  void addWord(String word) {
    state = state.copyWith(words: [...state.words, word]);
  }

  void removeWordAt(int index) {
    final words = List<String>.from(state.words);
    if (index >= 0 && index < words.length) {
      words.removeAt(index);
    }
    state = state.copyWith(words: words);
  }

  void removeLastWord() {
    if (state.words.isEmpty) return;
    final words = List<String>.from(state.words)..removeLast();
    state = state.copyWith(words: words);
  }

  void clear() => state = const MessageBarState();

  void setAiExpanding(bool value) =>
      state = state.copyWith(isAiExpanding: value);

  void setWords(List<String> words) =>
      state = state.copyWith(words: words);
}

final messageBarProvider =
    NotifierProvider<MessageBarNotifier, MessageBarState>(
        MessageBarNotifier.new);

// ---------------------------------------------------------------------------
// Message history state
// ---------------------------------------------------------------------------

class MessageHistoryNotifier extends Notifier<List<MessageEntry>> {
  @override
  List<MessageEntry> build() => [];

  void addEntry(MessageEntry entry) {
    state = [entry, ...state];
  }

  void addMessage(String text, MessageSource source) {
    final profile = ref.read(activeProfileProvider);
    final entry = MessageEntry(
      id: const Uuid().v4(),
      text: text,
      profileId: profile?.id ?? 'default',
      timestamp: DateTime.now(),
      source: source,
    );
    state = [entry, ...state];
  }

  void clearHistory() => state = [];
}

final messageHistoryProvider =
    NotifierProvider<MessageHistoryNotifier, List<MessageEntry>>(
        MessageHistoryNotifier.new);

// ---------------------------------------------------------------------------
// Active category (for CategoryTabs)
// ---------------------------------------------------------------------------

final activeCategoryProvider = StateProvider<String>((ref) => 'Inicio');

// ---------------------------------------------------------------------------
// Search query provider
// ---------------------------------------------------------------------------

final searchQueryProvider = StateProvider<String>((ref) => '');

// ---------------------------------------------------------------------------
// Vocabulary items for current board (stub)
// ---------------------------------------------------------------------------

final vocabularyItemsProvider =
    StateProvider<List<VocabularyItem>>((ref) => _sampleVocabulary());

List<VocabularyItem> _sampleVocabulary() {
  const items = [
    ('quiero', 'verbs', FitzgeraldCategory.verbs),
    ('comer', 'verbs', FitzgeraldCategory.verbs),
    ('beber', 'verbs', FitzgeraldCategory.verbs),
    ('ir', 'verbs', FitzgeraldCategory.verbs),
    ('yo', 'people', FitzgeraldCategory.people),
    ('tú', 'people', FitzgeraldCategory.people),
    ('mamá', 'people', FitzgeraldCategory.people),
    ('papá', 'people', FitzgeraldCategory.people),
    ('agua', 'nouns', FitzgeraldCategory.nouns),
    ('comida', 'nouns', FitzgeraldCategory.nouns),
    ('casa', 'nouns', FitzgeraldCategory.nouns),
    ('escuela', 'nouns', FitzgeraldCategory.nouns),
    ('grande', 'descriptors', FitzgeraldCategory.descriptors),
    ('pequeño', 'descriptors', FitzgeraldCategory.descriptors),
    ('bonito', 'descriptors', FitzgeraldCategory.descriptors),
    ('hola', 'social', FitzgeraldCategory.social),
    ('gracias', 'social', FitzgeraldCategory.social),
    ('por favor', 'social', FitzgeraldCategory.social),
    ('sí', 'function', FitzgeraldCategory.function),
    ('no', 'function', FitzgeraldCategory.function),
    ('más', 'function', FitzgeraldCategory.function),
    ('ayuda', 'function', FitzgeraldCategory.function),
    ('baño', 'nouns', FitzgeraldCategory.nouns),
    ('jugar', 'verbs', FitzgeraldCategory.verbs),
    ('dormir', 'verbs', FitzgeraldCategory.verbs),
    ('feliz', 'descriptors', FitzgeraldCategory.descriptors),
    ('triste', 'descriptors', FitzgeraldCategory.descriptors),
    ('aquí', 'navigation', FitzgeraldCategory.navigation),
    ('allá', 'navigation', FitzgeraldCategory.navigation),
    ('parar', 'verbs', FitzgeraldCategory.verbs),
  ];

  return items.asMap().entries.map((e) {
    final i = e.key;
    final (label, category, fitz) = e.value;
    return VocabularyItem(
      id: 'item_$i',
      label: label,
      category: category,
      fitzgeraldCategory: fitz,
      skinTone: SkinTone.defaultTone,
      hairColor: HairColor.defaultColor,
      grammarRole: GrammarRole.other,
      isCore: true,
      sortOrder: i,
      usageCount: 0,
      isFavorite: i < 4,
    );
  }).toList();
}

// ---------------------------------------------------------------------------
// Weekly stats (stub for home screen)
// ---------------------------------------------------------------------------

class WeeklyStats {
  final int practiceStreakDays;
  final int wordsUsedThisWeek;
  final int communicationGoal;
  final int communicationProgress;
  final String? lastBoardName;
  final List<String> recentWords;

  const WeeklyStats({
    this.practiceStreakDays = 3,
    this.wordsUsedThisWeek = 47,
    this.communicationGoal = 100,
    this.communicationProgress = 47,
    this.lastBoardName = 'Tablero Principal',
    this.recentWords = const ['quiero', 'comer', 'jugar', 'mamá', 'agua'],
  });
}

final weeklyStatsProvider = Provider<WeeklyStats>((ref) => const WeeklyStats());

// ---------------------------------------------------------------------------
// TTS engine provider
// ---------------------------------------------------------------------------

final ttsEngineProvider = Provider<TtsEngine>((ref) {
  final engine = SystemTtsEngine();
  engine.initialize();
  ref.onDispose(() => engine.dispose());
  return engine;
});

// ---------------------------------------------------------------------------
// AI service provider
// ---------------------------------------------------------------------------

final aiServiceProvider = Provider<AiService>((ref) => StubAiService());

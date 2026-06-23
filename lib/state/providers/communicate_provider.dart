// Communication screen state providers for Habla AAC.
// Manages the message bar, history, search and grid configuration.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:habla/services/ai/ai_service.dart';
import 'package:habla/services/tts/system_tts_engine.dart';
import 'package:habla/services/tts/tts_engine.dart';
import 'package:habla/state/providers/board_provider.dart';
import 'package:habla/state/providers/profile_provider.dart';

// ---------------------------------------------------------------------------
// MessageHistoryEntry
// ---------------------------------------------------------------------------

class MessageHistoryEntry {
  final String id;
  final String text;
  final DateTime timestamp;

  /// One of: typed, symbol, phrase, ai_expanded
  final String source;

  const MessageHistoryEntry({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.source,
  });

  MessageHistoryEntry copyWith({
    String? id,
    String? text,
    DateTime? timestamp,
    String? source,
  }) {
    return MessageHistoryEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageHistoryEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MessageHistoryEntry(id: $id, source: $source, timestamp: $timestamp)';
}

// ---------------------------------------------------------------------------
// MessageBarState
// ---------------------------------------------------------------------------

class MessageBarState {
  /// Individual word tokens shown in the message bar.
  final List<String> words;

  /// The joined, potentially AI-expanded sentence.
  final String fullMessage;

  /// True after the AI has expanded / corrected the phrase.
  final bool isExpanded;

  const MessageBarState({
    required this.words,
    required this.fullMessage,
    this.isExpanded = false,
  });

  MessageBarState copyWith({
    List<String>? words,
    String? fullMessage,
    bool? isExpanded,
  }) {
    return MessageBarState(
      words: words ?? this.words,
      fullMessage: fullMessage ?? this.fullMessage,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  static const empty = MessageBarState(words: [], fullMessage: '');
}

// ---------------------------------------------------------------------------
// Service providers (lightweight stubs — replace with real DI when ready)
// ---------------------------------------------------------------------------

/// Provider for the AI service instance.
final aiServiceProvider = Provider<AiService>((ref) => StubAiService());

/// Singleton TTS engine — initialized lazily on first speak.
final ttsEngineProvider = Provider<TtsEngine>((ref) {
  final engine = SystemTtsEngine();
  ref.onDispose(engine.dispose);
  return engine;
});

// ---------------------------------------------------------------------------
// MessageBarNotifier
// ---------------------------------------------------------------------------

class MessageBarNotifier extends StateNotifier<MessageBarState> {
  final Ref _ref;

  MessageBarNotifier(this._ref) : super(MessageBarState.empty);

  void addWord(String word) {
    final updated = [...state.words, word];
    state = state.copyWith(
      words: updated,
      fullMessage: updated.join(' '),
      isExpanded: false,
    );
  }

  void removeLastWord() {
    if (state.words.isEmpty) return;
    final updated = state.words.sublist(0, state.words.length - 1);
    state = state.copyWith(
      words: updated,
      fullMessage: updated.join(' '),
      isExpanded: false,
    );
  }

  void clearAll() {
    state = MessageBarState.empty;
  }

  Future<void> expandWithAi() async {
    if (state.words.isEmpty) return;
    final aiService = _ref.read(aiServiceProvider);
    final profile = _ref.read(currentProfileDataProvider);
    final expanded = await aiService.expandPhrase(
      state.fullMessage,
      profileContext: profile?.diagnosis,
      language: profile?.language ?? 'es-MX',
    );
    state = state.copyWith(
      fullMessage: expanded,
      isExpanded: true,
    );
  }

  /// Basic Spanish grammar correction: capitalise first word, add period.
  void applyGrammar() {
    if (state.fullMessage.isEmpty) return;
    var text = state.fullMessage.trim();
    text = text[0].toUpperCase() + text.substring(1);
    if (!text.endsWith('.') &&
        !text.endsWith('?') &&
        !text.endsWith('!')) {
      text = '$text.';
    }
    state = state.copyWith(fullMessage: text);
  }

  Future<void> addToFavorites() async {
    // Record in history with source = phrase (favorites persistence is handled
    // separately by a phrases feature provider).
    final entry = MessageHistoryEntry(
      id: const Uuid().v4(),
      text: state.fullMessage,
      timestamp: DateTime.now(),
      source: 'phrase',
    );
    _ref.read(messageHistoryProvider.notifier).addEntry(entry);
  }

  Future<void> speak() async {
    if (state.fullMessage.isEmpty) return;
    await _ref.read(ttsEngineProvider).speak(state.fullMessage);
    final entry = MessageHistoryEntry(
      id: const Uuid().v4(),
      text: state.fullMessage,
      timestamp: DateTime.now(),
      source: state.isExpanded ? 'ai_expanded' : 'symbol',
    );
    _ref.read(messageHistoryProvider.notifier).addEntry(entry);
  }

  Future<void> speakWord(String word) async {
    await _ref.read(ttsEngineProvider).speak(word);
  }
}

/// Provider for the message bar state and notifier.
final messageBarProvider =
    StateNotifierProvider<MessageBarNotifier, MessageBarState>((ref) {
  return MessageBarNotifier(ref);
});

// ---------------------------------------------------------------------------
// Grid and disposition providers
// ---------------------------------------------------------------------------

/// Number of buttons currently shown in the grid (rows × columns).
final currentGridSizeProvider = StateProvider<int>((ref) => 15);

/// Current board display mode: 'pictograms', 'visual_scene', 'keyboard'.
final currentDispositionProvider = StateProvider<String>((ref) => 'pictograms');

// ---------------------------------------------------------------------------
// MessageHistoryNotifier
// ---------------------------------------------------------------------------

class MessageHistoryNotifier
    extends StateNotifier<List<MessageHistoryEntry>> {
  MessageHistoryNotifier() : super([]);

  void addEntry(MessageHistoryEntry entry) {
    // Keep the 200 most recent entries.
    final updated = [entry, ...state];
    state = updated.length > 200 ? updated.sublist(0, 200) : updated;
  }

  void removeEntry(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

/// Provider for the communication message history list.
final messageHistoryProvider =
    StateNotifierProvider<MessageHistoryNotifier, List<MessageHistoryEntry>>(
  (ref) => MessageHistoryNotifier(),
);

// ---------------------------------------------------------------------------
// Vocabulary search and category filters
// ---------------------------------------------------------------------------

/// Current search query for the vocabulary grid.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// The active Fitzgerald category filter (null = show all).
final activeCategoryProvider = StateProvider<String?>((ref) => null);

// ---------------------------------------------------------------------------
// Suggested words — FutureProvider
// ---------------------------------------------------------------------------

/// Returns vocabulary items sorted by recent usage for quick-access suggestions.
/// Derives from the current board's vocabulary; falls back to an empty list.
final suggestedWordsProvider =
    FutureProvider<List<VocabularyItemEntity>>((ref) async {
  final vocab = ref.watch(vocabularyForActiveBoardProvider);
  if (vocab.isEmpty) return [];
  // Sort by usage descending, take top 8.
  final sorted = [...vocab]
    ..sort((a, b) => b.usageCount.compareTo(a.usageCount));
  return sorted.take(8).toList();
});

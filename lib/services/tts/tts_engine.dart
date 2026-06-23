import 'package:flutter/foundation.dart';

enum TtsEngineType { system, elevenLabs, azure, googleNeural }

enum SpeechEmotion { neutral, happy, sad, excited, calm, urgent }

abstract class TtsEngine {
  Future<void> initialize();
  Future<void> speak(String text, {SpeechEmotion emotion = SpeechEmotion.neutral});
  Future<void> stop();
  Future<void> pause();
  Future<void> resume();
  Future<List<TtsVoice>> getAvailableVoices();
  Future<void> setVoice(TtsVoice voice);
  Future<void> setLanguage(String languageCode);
  Future<void> setRate(double rate);
  Future<void> setPitch(double pitch);
  Future<void> setVolume(double volume);
  bool get isAvailableOffline;
  TtsEngineType get engineType;
  ValueNotifier<TtsState> get stateNotifier;
  Future<void> dispose();
}

enum TtsState { idle, playing, paused, error }

class TtsVoice {
  final String id;
  final String name;
  final String locale;
  final String? gender;
  final bool isNeural;
  final TtsEngineType engineType;

  const TtsVoice({
    required this.id,
    required this.name,
    required this.locale,
    this.gender,
    required this.isNeural,
    required this.engineType,
  });

  @override
  String toString() => '$name ($locale)';
}

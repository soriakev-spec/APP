import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'tts_engine.dart';

class SystemTtsEngine implements TtsEngine {
  final FlutterTts _tts = FlutterTts();
  final _stateNotifier = ValueNotifier<TtsState>(TtsState.idle);
  bool _initialized = false;

  @override
  TtsEngineType get engineType => TtsEngineType.system;

  @override
  bool get isAvailableOffline => true;

  @override
  ValueNotifier<TtsState> get stateNotifier => _stateNotifier;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    _tts.setStartHandler(() => _stateNotifier.value = TtsState.playing);
    _tts.setCompletionHandler(() => _stateNotifier.value = TtsState.idle);
    _tts.setPauseHandler(() => _stateNotifier.value = TtsState.paused);
    _tts.setContinueHandler(() => _stateNotifier.value = TtsState.playing);
    _tts.setErrorHandler((_) => _stateNotifier.value = TtsState.error);

    await _tts.setLanguage('es-MX');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);

    // Prefer best available voice for es-MX
    final voices = await _getSystemVoices();
    final bestVoice = voices.firstWhere(
      (v) => v.locale.startsWith('es') && v.isNeural,
      orElse: () => voices.firstWhere(
        (v) => v.locale.startsWith('es'),
        orElse: () => voices.isNotEmpty ? voices.first : TtsVoice(
          id: 'default', name: 'Default', locale: 'es-MX',
          isNeural: false, engineType: TtsEngineType.system,
        ),
      ),
    );
    if (voices.isNotEmpty) {
      await _tts.setVoice({'name': bestVoice.id, 'locale': bestVoice.locale});
    }

    _initialized = true;
  }

  @override
  Future<void> speak(String text, {SpeechEmotion emotion = SpeechEmotion.neutral}) async {
    if (!_initialized) await initialize();
    await stop();

    // Apply prosody based on emotion and punctuation
    final processedText = _applyProsody(text, emotion);
    await _tts.speak(processedText);
  }

  String _applyProsody(String text, SpeechEmotion emotion) {
    // Punctuation-based prosody is applied via rate/pitch API adjustments below.

    // Adjust pitch/rate per emotion through SSML-like hints
    // flutter_tts doesn't fully support SSML on all voices,
    // so we adjust via API calls before speaking
    switch (emotion) {
      case SpeechEmotion.happy:
        _tts.setPitch(1.2);
        _tts.setSpeechRate(0.5);
      case SpeechEmotion.sad:
        _tts.setPitch(0.9);
        _tts.setSpeechRate(0.4);
      case SpeechEmotion.excited:
        _tts.setPitch(1.3);
        _tts.setSpeechRate(0.55);
      case SpeechEmotion.urgent:
        _tts.setPitch(1.0);
        _tts.setSpeechRate(0.6);
      case SpeechEmotion.calm:
      case SpeechEmotion.neutral:
        _tts.setPitch(1.0);
        _tts.setSpeechRate(0.45);
    }

    // If text ends with "?", adjust for question intonation
    if (text.endsWith('?')) {
      _tts.setPitch(1.15);
    } else if (text.endsWith('!')) {
      _tts.setPitch(1.2);
    }

    return text; // Return original; prosody applied via API
  }

  @override
  Future<void> stop() async => _tts.stop();

  @override
  Future<void> pause() async => _tts.pause();

  @override
  Future<void> resume() async => _tts.speak('');

  @override
  Future<List<TtsVoice>> getAvailableVoices() => _getSystemVoices();

  Future<List<TtsVoice>> _getSystemVoices() async {
    try {
      final raw = await _tts.getVoices as List?;
      if (raw == null) return [];
      return raw
          .whereType<Map>()
          .where((v) {
            final locale = (v['locale'] as String? ?? '').toLowerCase();
            return locale.startsWith('es') || locale.startsWith('en');
          })
          .map((v) => TtsVoice(
                id: v['name'] as String? ?? 'unknown',
                name: v['name'] as String? ?? 'Voz del sistema',
                locale: v['locale'] as String? ?? 'es-MX',
                gender: v['gender'] as String?,
                isNeural: (v['name'] as String? ?? '').contains('Neural') ||
                    (v['name'] as String? ?? '').contains('neural'),
                engineType: TtsEngineType.system,
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> setVoice(TtsVoice voice) async {
    await _tts.setVoice({'name': voice.id, 'locale': voice.locale});
  }

  @override
  Future<void> setLanguage(String languageCode) => _tts.setLanguage(languageCode);

  @override
  Future<void> setRate(double rate) => _tts.setSpeechRate(rate.clamp(0.1, 1.0));

  @override
  Future<void> setPitch(double pitch) => _tts.setPitch(pitch.clamp(0.5, 2.0));

  @override
  Future<void> setVolume(double volume) => _tts.setVolume(volume.clamp(0.0, 1.0));

  @override
  Future<void> dispose() async {
    await _tts.stop();
    _stateNotifier.dispose();
  }
}

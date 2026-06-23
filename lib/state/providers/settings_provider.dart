// App settings providers for Habla AAC.
// Persists user preferences via SharedPreferences.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// AppSettings model
// ---------------------------------------------------------------------------

class AppSettings {
  /// TTS playback rate (0.0 – 1.0). Default 0.45 for clear AAC speech.
  final double ttsRate;

  /// TTS pitch multiplier. Default 1.0 (natural).
  final double ttsPitch;

  /// TTS volume (0.0 – 1.0). Default 1.0.
  final double ttsVolume;

  /// TTS engine identifier: 'system', 'elevenlabs', 'azure', 'google'.
  final String ttsEngine;

  /// BCP-47 language tag used for TTS and AI services.
  final String language;

  /// High-contrast display mode for low-vision users.
  final bool highContrast;

  /// Disables animations and transitions for motion-sensitive users.
  final bool reducedMotion;

  /// Enable vibration feedback on button press.
  final bool hapticFeedback;

  /// Enable auditory click/confirm feedback.
  final bool auditoryFeedback;

  /// Grid size as a string (e.g. '9', '15', '20').
  final String gridSize;

  /// Enable switch access scanning mode.
  final bool switchAccessEnabled;

  /// Dwell time in milliseconds for eye-gaze / dwell activation.
  final double dwellTimeMs;

  /// Scan cycle speed in milliseconds for switch access.
  final double scanSpeedMs;

  const AppSettings({
    this.ttsRate = 0.45,
    this.ttsPitch = 1.0,
    this.ttsVolume = 1.0,
    this.ttsEngine = 'system',
    this.language = 'es-MX',
    this.highContrast = false,
    this.reducedMotion = false,
    this.hapticFeedback = true,
    this.auditoryFeedback = true,
    this.gridSize = '15',
    this.switchAccessEnabled = false,
    this.dwellTimeMs = 800,
    this.scanSpeedMs = 1500,
  });

  AppSettings copyWith({
    double? ttsRate,
    double? ttsPitch,
    double? ttsVolume,
    String? ttsEngine,
    String? language,
    bool? highContrast,
    bool? reducedMotion,
    bool? hapticFeedback,
    bool? auditoryFeedback,
    String? gridSize,
    bool? switchAccessEnabled,
    double? dwellTimeMs,
    double? scanSpeedMs,
  }) {
    return AppSettings(
      ttsRate: ttsRate ?? this.ttsRate,
      ttsPitch: ttsPitch ?? this.ttsPitch,
      ttsVolume: ttsVolume ?? this.ttsVolume,
      ttsEngine: ttsEngine ?? this.ttsEngine,
      language: language ?? this.language,
      highContrast: highContrast ?? this.highContrast,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      auditoryFeedback: auditoryFeedback ?? this.auditoryFeedback,
      gridSize: gridSize ?? this.gridSize,
      switchAccessEnabled: switchAccessEnabled ?? this.switchAccessEnabled,
      dwellTimeMs: dwellTimeMs ?? this.dwellTimeMs,
      scanSpeedMs: scanSpeedMs ?? this.scanSpeedMs,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          ttsRate == other.ttsRate &&
          ttsPitch == other.ttsPitch &&
          ttsVolume == other.ttsVolume &&
          ttsEngine == other.ttsEngine &&
          language == other.language &&
          highContrast == other.highContrast &&
          reducedMotion == other.reducedMotion &&
          hapticFeedback == other.hapticFeedback &&
          auditoryFeedback == other.auditoryFeedback &&
          gridSize == other.gridSize &&
          switchAccessEnabled == other.switchAccessEnabled &&
          dwellTimeMs == other.dwellTimeMs &&
          scanSpeedMs == other.scanSpeedMs;

  @override
  int get hashCode => Object.hash(
        ttsRate,
        ttsPitch,
        ttsVolume,
        ttsEngine,
        language,
        highContrast,
        reducedMotion,
        hapticFeedback,
        auditoryFeedback,
        gridSize,
        switchAccessEnabled,
        dwellTimeMs,
        scanSpeedMs,
      );

  @override
  String toString() =>
      'AppSettings(ttsRate: $ttsRate, language: $language, highContrast: $highContrast)';
}

// ---------------------------------------------------------------------------
// SharedPreferences keys
// ---------------------------------------------------------------------------

abstract final class _Keys {
  static const ttsRate = 'tts_rate';
  static const ttsPitch = 'tts_pitch';
  static const ttsVolume = 'tts_volume';
  static const ttsEngine = 'tts_engine';
  static const language = 'language';
  static const highContrast = 'high_contrast';
  static const reducedMotion = 'reduced_motion';
  static const hapticFeedback = 'haptic_feedback';
  static const auditoryFeedback = 'auditory_feedback';
  static const gridSize = 'grid_size';
  static const switchAccessEnabled = 'switch_access_enabled';
  static const dwellTimeMs = 'dwell_time_ms';
  static const scanSpeedMs = 'scan_speed_ms';
}

// ---------------------------------------------------------------------------
// SettingsRepository
// ---------------------------------------------------------------------------

class SettingsRepository {
  final SharedPreferences _prefs;

  const SettingsRepository(this._prefs);

  AppSettings load() {
    return AppSettings(
      ttsRate: _prefs.getDouble(_Keys.ttsRate) ?? 0.45,
      ttsPitch: _prefs.getDouble(_Keys.ttsPitch) ?? 1.0,
      ttsVolume: _prefs.getDouble(_Keys.ttsVolume) ?? 1.0,
      ttsEngine: _prefs.getString(_Keys.ttsEngine) ?? 'system',
      language: _prefs.getString(_Keys.language) ?? 'es-MX',
      highContrast: _prefs.getBool(_Keys.highContrast) ?? false,
      reducedMotion: _prefs.getBool(_Keys.reducedMotion) ?? false,
      hapticFeedback: _prefs.getBool(_Keys.hapticFeedback) ?? true,
      auditoryFeedback: _prefs.getBool(_Keys.auditoryFeedback) ?? true,
      gridSize: _prefs.getString(_Keys.gridSize) ?? '15',
      switchAccessEnabled:
          _prefs.getBool(_Keys.switchAccessEnabled) ?? false,
      dwellTimeMs: _prefs.getDouble(_Keys.dwellTimeMs) ?? 800,
      scanSpeedMs: _prefs.getDouble(_Keys.scanSpeedMs) ?? 1500,
    );
  }

  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _prefs.setDouble(_Keys.ttsRate, settings.ttsRate),
      _prefs.setDouble(_Keys.ttsPitch, settings.ttsPitch),
      _prefs.setDouble(_Keys.ttsVolume, settings.ttsVolume),
      _prefs.setString(_Keys.ttsEngine, settings.ttsEngine),
      _prefs.setString(_Keys.language, settings.language),
      _prefs.setBool(_Keys.highContrast, settings.highContrast),
      _prefs.setBool(_Keys.reducedMotion, settings.reducedMotion),
      _prefs.setBool(_Keys.hapticFeedback, settings.hapticFeedback),
      _prefs.setBool(_Keys.auditoryFeedback, settings.auditoryFeedback),
      _prefs.setString(_Keys.gridSize, settings.gridSize),
      _prefs.setBool(_Keys.switchAccessEnabled, settings.switchAccessEnabled),
      _prefs.setDouble(_Keys.dwellTimeMs, settings.dwellTimeMs),
      _prefs.setDouble(_Keys.scanSpeedMs, settings.scanSpeedMs),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// Provides the SharedPreferences instance. Must be overridden with a real
/// instance before app startup (use ProviderScope overrides).
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with an instance from '
    'SharedPreferences.getInstance() in main.dart before the app starts.',
  );
});

/// Provides the SettingsRepository singleton.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(prefs);
});

/// App-wide settings notifier. Reads from SharedPreferences on init and
/// persists every change.
final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return AppSettingsNotifier(repo);
});

// ---------------------------------------------------------------------------
// AppSettingsNotifier
// ---------------------------------------------------------------------------

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repo;

  AppSettingsNotifier(this._repo) : super(_repo.load());

  Future<void> _persist() => _repo.save(state);

  Future<void> setTtsRate(double value) async {
    state = state.copyWith(ttsRate: value.clamp(0.0, 1.0));
    await _persist();
  }

  Future<void> setTtsPitch(double value) async {
    state = state.copyWith(ttsPitch: value.clamp(0.5, 2.0));
    await _persist();
  }

  Future<void> setTtsVolume(double value) async {
    state = state.copyWith(ttsVolume: value.clamp(0.0, 1.0));
    await _persist();
  }

  Future<void> setTtsEngine(String engine) async {
    state = state.copyWith(ttsEngine: engine);
    await _persist();
  }

  Future<void> setLanguage(String language) async {
    state = state.copyWith(language: language);
    await _persist();
  }

  Future<void> setHighContrast(bool value) async {
    state = state.copyWith(highContrast: value);
    await _persist();
  }

  Future<void> setReducedMotion(bool value) async {
    state = state.copyWith(reducedMotion: value);
    await _persist();
  }

  Future<void> setHapticFeedback(bool value) async {
    state = state.copyWith(hapticFeedback: value);
    await _persist();
  }

  Future<void> setAuditoryFeedback(bool value) async {
    state = state.copyWith(auditoryFeedback: value);
    await _persist();
  }

  Future<void> setGridSize(String gridSize) async {
    state = state.copyWith(gridSize: gridSize);
    await _persist();
  }

  Future<void> setSwitchAccessEnabled(bool value) async {
    state = state.copyWith(switchAccessEnabled: value);
    await _persist();
  }

  Future<void> setDwellTimeMs(double value) async {
    state = state.copyWith(dwellTimeMs: value.clamp(200, 5000));
    await _persist();
  }

  Future<void> setScanSpeedMs(double value) async {
    state = state.copyWith(scanSpeedMs: value.clamp(200, 5000));
    await _persist();
  }

  Future<void> resetToDefaults() async {
    state = const AppSettings();
    await _persist();
  }
}

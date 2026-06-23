/// App-wide constants for Habla AAC.
///
/// All values here are compile-time constants (`const`).  Do not add mutable
/// state or logic to this class — that belongs in services or providers.
abstract final class AppConstants {
  // -------------------------------------------------------------------------
  // Identity
  // -------------------------------------------------------------------------

  static const String appName = 'Habla';
  static const String bundleId = 'com.habla.aac';

  // -------------------------------------------------------------------------
  // Localisation
  // -------------------------------------------------------------------------

  /// Default locale used when no user preference is set.
  static const String defaultLocale = 'es-MX';

  /// All locales supported by the app (BCP 47 tags).
  static const List<String> supportedLocales = ['es-MX', 'es', 'en-US', 'en'];

  // -------------------------------------------------------------------------
  // Grid sizes
  // -------------------------------------------------------------------------

  /// Available symbol-grid column counts.
  /// Maps to the AAC industry-standard vocabulary sizes.
  static const List<int> gridSizes = [4, 8, 15, 30, 60, 90];

  /// Default grid size when a new board is created.
  static const int defaultGridSize = 15;

  // -------------------------------------------------------------------------
  // Layout dispositions
  // -------------------------------------------------------------------------

  /// Identifier for a regular pictogram / symbol grid layout.
  static const String dispositionPictograms = 'pictograms';

  /// Identifier for a visual scene display layout (image with hotspots).
  static const String dispositionVisualScene = 'visual_scene';

  /// Identifier for an on-screen keyboard / letter-by-letter layout.
  static const String dispositionKeyboard = 'keyboard';

  /// All valid layout disposition names.
  static const List<String> layoutDispositions = [
    dispositionPictograms,
    dispositionVisualScene,
    dispositionKeyboard,
  ];

  // -------------------------------------------------------------------------
  // Profile / diagnosis names
  // -------------------------------------------------------------------------

  /// Clinical diagnosis labels used to pre-configure AAC profiles.
  /// These are stored as identifiers; the UI layer localizes them.
  static const List<String> profileDiagnoses = [
    'autism_spectrum_disorder',
    'cerebral_palsy',
    'down_syndrome',
    'traumatic_brain_injury',
    'stroke_aphasia',
    'als_motor_neuron_disease',
    'rett_syndrome',
    'angelman_syndrome',
    'developmental_language_disorder',
    'intellectual_disability',
    'acquired_communication_disorder',
    'other',
  ];

  // -------------------------------------------------------------------------
  // Asset paths
  // -------------------------------------------------------------------------

  // -- Data files --

  static const String assetVocabulary = 'assets/data/vocabulary.json';
  static const String assetPhrases = 'assets/data/phrases.json';
  static const String assetScenarios = 'assets/data/scenarios.json';
  static const String assetActivities = 'assets/data/activities.json';
  static const String assetProfilesDefault = 'assets/data/profiles_default.json';

  // -- Symbol assets --

  static const String assetSymbolsDir = 'assets/symbols/';
  static const String assetSymbolPlaceholder = 'assets/symbols/placeholder.png';

  // -- Font families (must match pubspec.yaml) --

  static const String fontBricolageGrotesque = 'BricolageGrotesque';
  static const String fontDmSans = 'DMSans';

  // -------------------------------------------------------------------------
  // TTS
  // -------------------------------------------------------------------------

  static const String ttsDefaultLanguage = 'es-MX';
  static const double ttsDefaultRate = 0.5;   // 0.0 – 1.0
  static const double ttsDefaultPitch = 1.0;  // 0.5 – 2.0
  static const double ttsDefaultVolume = 1.0; // 0.0 – 1.0

  // -------------------------------------------------------------------------
  // AI / suggestion engine
  // -------------------------------------------------------------------------

  /// Maximum number of AI word suggestions shown in the suggestion bar.
  static const int aiMaxSuggestions = 6;

  /// Debounce delay before firing an AI prediction request (milliseconds).
  static const int aiDebounceMsec = 400;

  // -------------------------------------------------------------------------
  // Database
  // -------------------------------------------------------------------------

  /// File name of the local SQLite database (inside app documents dir).
  static const String dbFileName = 'habla.db';

  /// Current schema version — increment when running a Drift migration.
  static const int dbSchemaVersion = 1;

  // -------------------------------------------------------------------------
  // Shared-preferences keys
  // -------------------------------------------------------------------------

  static const String prefActiveProfileId = 'active_profile_id';
  static const String prefGridSize = 'grid_size';
  static const String prefDisposition = 'disposition';
  static const String prefTtsLanguage = 'tts_language';
  static const String prefTtsRate = 'tts_rate';
  static const String prefTtsPitch = 'tts_pitch';
  static const String prefReduceAnimations = 'reduce_animations';
  static const String prefHighContrast = 'high_contrast';
  static const String prefFitzgeraldColors = 'fitzgerald_colors';
  static const String prefOnboardingDone = 'onboarding_done';
  static const String prefLastSyncTimestamp = 'last_sync_timestamp';

  // -------------------------------------------------------------------------
  // Network / API
  // -------------------------------------------------------------------------

  static const Duration networkTimeout = Duration(seconds: 20);
  static const int networkMaxRetries = 3;

  // -------------------------------------------------------------------------
  // Output bar
  // -------------------------------------------------------------------------

  /// Maximum number of symbols held in the output bar before oldest is dropped.
  static const int outputBarMaxSymbols = 20;

  // -------------------------------------------------------------------------
  // Private constructor
  // -------------------------------------------------------------------------

  const AppConstants._();
}

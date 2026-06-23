/// Sealed exception hierarchy for Habla AAC.
///
/// All domain errors are subtypes of [AppException].  Features throw (or
/// return) these types instead of raw [Exception] / [Error] objects so that
/// the UI layer can pattern-match on them.
///
/// For async operations that may fail, prefer returning [AppResult<T>] rather
/// than throwing, to keep error paths explicit in the type system.
sealed class AppException implements Exception {
  const AppException({
    required this.message,
    required this.code,
    this.cause,
  });

  /// Human-readable description (English; UI layer localises).
  final String message;

  /// Machine-readable error code for logging and analytics.
  final String code;

  /// Optional underlying exception / error that caused this one.
  final Object? cause;

  @override
  String toString() =>
      '$runtimeType(code: $code, message: $message'
      '${cause != null ? ", cause: $cause" : ""})';
}

// =============================================================================
// Concrete subtypes
// =============================================================================

/// Errors originating from HTTP / socket communication.
final class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code = 'network_error',
    super.cause,
    this.statusCode,
  });

  /// HTTP status code, if the error came from an HTTP response.
  final int? statusCode;

  /// No internet connectivity.
  factory NetworkException.noConnection() => const NetworkException(
        message: 'No internet connection.',
        code: 'network_no_connection',
      );

  /// The server returned an unexpected status code.
  factory NetworkException.badResponse(int statusCode, [String? body]) =>
      NetworkException(
        message: 'Server returned status $statusCode.',
        code: 'network_bad_response',
        statusCode: statusCode,
        cause: body,
      );

  /// The request timed out.
  factory NetworkException.timeout() => const NetworkException(
        message: 'The request timed out.',
        code: 'network_timeout',
      );
}

/// Errors from local Drift / SQLite operations.
final class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code = 'database_error',
    super.cause,
    this.table,
  });

  /// The table involved in the failed operation, if known.
  final String? table;

  factory DatabaseException.readFailed(String table, [Object? cause]) =>
      DatabaseException(
        message: 'Failed to read from table "$table".',
        code: 'database_read_failed',
        cause: cause,
        table: table,
      );

  factory DatabaseException.writeFailed(String table, [Object? cause]) =>
      DatabaseException(
        message: 'Failed to write to table "$table".',
        code: 'database_write_failed',
        cause: cause,
        table: table,
      );

  factory DatabaseException.migrationFailed([Object? cause]) =>
      DatabaseException(
        message: 'Database migration failed.',
        code: 'database_migration_failed',
        cause: cause,
      );
}

/// Errors from the flutter_tts engine.
final class TtsException extends AppException {
  const TtsException({
    required super.message,
    super.code = 'tts_error',
    super.cause,
  });

  factory TtsException.notAvailable() => const TtsException(
        message: 'Text-to-speech engine is not available on this device.',
        code: 'tts_not_available',
      );

  factory TtsException.languageNotSupported(String language) => TtsException(
        message: 'TTS language "$language" is not supported on this device.',
        code: 'tts_language_not_supported',
        cause: language,
      );

  factory TtsException.speechFailed([Object? cause]) => TtsException(
        message: 'Failed to synthesise speech.',
        code: 'tts_speech_failed',
        cause: cause,
      );
}

/// Errors from AI / prediction services.
final class AiException extends AppException {
  const AiException({
    required super.message,
    super.code = 'ai_error',
    super.cause,
  });

  factory AiException.modelUnavailable() => const AiException(
        message: 'The AI model is currently unavailable.',
        code: 'ai_model_unavailable',
      );

  factory AiException.predictionFailed([Object? cause]) => AiException(
        message: 'Failed to generate AI prediction.',
        code: 'ai_prediction_failed',
        cause: cause,
      );

  factory AiException.quotaExceeded() => const AiException(
        message: 'AI request quota exceeded. Try again later.',
        code: 'ai_quota_exceeded',
      );
}

/// Errors related to AAC symbols (loading, parsing, missing assets).
final class SymbolException extends AppException {
  const SymbolException({
    required super.message,
    super.code = 'symbol_error',
    super.cause,
    this.symbolId,
  });

  /// Identifier of the symbol that caused the error, if known.
  final String? symbolId;

  factory SymbolException.notFound(String symbolId) => SymbolException(
        message: 'Symbol "$symbolId" was not found.',
        code: 'symbol_not_found',
        symbolId: symbolId,
      );

  factory SymbolException.loadFailed(String symbolId, [Object? cause]) =>
      SymbolException(
        message: 'Failed to load symbol "$symbolId".',
        code: 'symbol_load_failed',
        cause: cause,
        symbolId: symbolId,
      );

  factory SymbolException.invalidFormat(String symbolId, [Object? cause]) =>
      SymbolException(
        message: 'Symbol "$symbolId" has an invalid format.',
        code: 'symbol_invalid_format',
        cause: cause,
        symbolId: symbolId,
      );
}

// =============================================================================
// AppResult<T> — lightweight Either / Result type
// =============================================================================

/// A discriminated union that holds either a successful [data] value or an
/// [AppException] error.
///
/// This avoids a dependency on `dartz` or `fpdart` while keeping error
/// propagation explicit in the type system.
///
/// Usage:
/// ```dart
/// // Returning a result
/// AppResult<Symbol> loadSymbol(String id) {
///   try {
///     final symbol = _repository.find(id);
///     return AppResult.ok(symbol);
///   } on DatabaseException catch (e) {
///     return AppResult.fail(e);
///   }
/// }
///
/// // Consuming a result
/// final result = await loadSymbol('greet_hello');
/// result.fold(
///   onSuccess: (symbol) => print(symbol.label),
///   onError: (err) => showError(err.message),
/// );
/// ```
final class AppResult<T> {
  const AppResult._({this.data, this.error});

  /// The successful value.  Non-null when [isSuccess] is `true`.
  final T? data;

  /// The failure exception.  Non-null when [isError] is `true`.
  final AppException? error;

  /// Creates a successful result wrapping [value].
  factory AppResult.ok(T value) => AppResult._(data: value);

  /// Creates a failed result wrapping [exception].
  factory AppResult.fail(AppException exception) =>
      AppResult._(error: exception);

  // -------------------------------------------------------------------------
  // State checks
  // -------------------------------------------------------------------------

  bool get isSuccess => error == null;
  bool get isError => error != null;

  // -------------------------------------------------------------------------
  // Unwrapping helpers
  // -------------------------------------------------------------------------

  /// Returns the data value, throwing a [StateError] if this is an error.
  T get requireData {
    if (data == null) {
      throw StateError(
        'AppResult.requireData called on an error result: $error',
      );
    }
    return data as T;
  }

  /// Returns the exception, throwing a [StateError] if this is a success.
  AppException get requireError {
    if (error == null) {
      throw StateError(
        'AppResult.requireError called on a success result.',
      );
    }
    return error!;
  }

  // -------------------------------------------------------------------------
  // Functional-style combinators
  // -------------------------------------------------------------------------

  /// Applies [onSuccess] when successful or [onError] when failed.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppException error) onError,
  }) {
    if (isSuccess) return onSuccess(data as T);
    return onError(error!);
  }

  /// Transforms the data value with [transform] if successful; passes through
  /// the error unchanged otherwise.
  AppResult<R> map<R>(R Function(T data) transform) {
    if (isSuccess) {
      return AppResult.ok(transform(data as T));
    }
    return AppResult.fail(error!);
  }

  /// Chains another fallible operation onto a successful result.
  AppResult<R> flatMap<R>(AppResult<R> Function(T data) transform) {
    if (isSuccess) return transform(data as T);
    return AppResult.fail(error!);
  }

  /// Returns [data] if successful, or [fallback] if failed.
  T getOrElse(T fallback) => isSuccess ? data as T : fallback;

  /// Returns [data] if successful, or `null` if failed.
  T? getOrNull() => isSuccess ? data as T : null;

  @override
  String toString() => isSuccess
      ? 'AppResult.ok($data)'
      : 'AppResult.fail($error)';
}

// =============================================================================
// AsyncAppResult convenience typedef
// =============================================================================

/// A [Future] that resolves to an [AppResult].
typedef AsyncAppResult<T> = Future<AppResult<T>>;

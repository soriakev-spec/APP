import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// =============================================================================
// String extensions
// =============================================================================

extension StringExtensions on String {
  /// Returns `true` when the string is empty after trimming whitespace.
  bool get isEmpty => trim().isEmpty;

  /// Capitalises the first letter and lowercases the rest.
  ///
  /// ```dart
  /// 'hOLA'.capitalize  // → 'Hola'
  /// ```
  String get capitalize {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Truncates the string to at most [maxLength] characters.
  ///
  /// When truncation occurs, [ellipsis] (default `'…'`) is appended.
  /// The total returned length never exceeds [maxLength] + [ellipsis].length.
  String truncate(int maxLength, {String ellipsis = '…'}) {
    assert(maxLength >= 0, 'maxLength must be non-negative');
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Returns `true` when the string contains only whitespace or is empty.
  bool get isBlank => trim().isEmpty;

  /// Returns `null` when the string is blank; otherwise returns `this`.
  String? get nullIfBlank => isBlank ? null : this;

  /// Removes all leading and trailing whitespace from each line, then joins
  /// with a single space — useful for normalising multi-line AAC output bar text.
  String get normalised =>
      split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).join(' ');
}

extension NullableStringExtensions on String? {
  /// `true` when the nullable string is `null` or empty (after trimming).
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  /// Returns [fallback] when this is null or empty; otherwise returns the value.
  String orDefault(String fallback) => isNullOrEmpty ? fallback : this!;
}

// =============================================================================
// BuildContext extensions
// =============================================================================

extension BuildContextExtensions on BuildContext {
  // ---- Theme convenience ----

  /// The nearest [ThemeData] above this context.
  ThemeData get theme => Theme.of(this);

  /// Shortcut to [ThemeData.colorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Shortcut to [ThemeData.textTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  // ---- Media query ----

  /// Returns the [MediaQueryData] for this context.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Logical screen width in dp (using [MediaQuery.sizeOf] for efficiency).
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Logical screen height in dp.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// `true` when [screenWidth] < 600 dp (phone).
  bool get isMobile => screenWidth < 600;

  /// `true` when 600 dp ≤ [screenWidth] < 1200 dp (tablet).
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// `true` when [screenWidth] ≥ 1200 dp (large tablet / desktop).
  bool get isDesktop => screenWidth >= 1200;

  /// `true` when [screenWidth] ≥ 600 dp (tablet or larger).
  bool get isTabletOrLarger => !isMobile;

  /// `true` when the OS reduce-motion accessibility flag is set.
  bool get reduceMotion => MediaQuery.of(this).disableAnimations;

  /// Safe area insets for this context.
  EdgeInsets get safeArea => MediaQuery.of(this).padding;

  /// Hides the current [SnackBar] (if any) and shows a new one.
  void showSnackBar(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
        ),
      );
  }

  /// Pops the current route if the navigator can pop.
  void popIfPossible([Object? result]) {
    final nav = Navigator.of(this);
    if (nav.canPop()) nav.pop(result);
  }
}

// =============================================================================
// DateTime extensions
// =============================================================================

extension DateTimeExtensions on DateTime {
  // -------------------------------------------------------------------------
  // Localisation helpers
  // -------------------------------------------------------------------------

  /// Returns a localised human-readable string for this [DateTime].
  ///
  /// Supported [locale] values: `'es'`, `'es-MX'` (default), `'en'`, `'en-US'`.
  /// Uses [intl] for formatting.
  ///
  /// Example for es-MX: `'lunes, 20 de junio de 2026'`.
  String toLocalizedString(String locale) {
    final normalised = _normaliseLocale(locale);
    try {
      final formatter = DateFormat.yMMMMEEEEd(normalised);
      return formatter.format(this);
    } catch (_) {
      // Fallback: ISO 8601 date
      return toIso8601String().substring(0, 10);
    }
  }

  /// Returns a short localised date string (e.g. `'20/06/2026'`).
  String toShortLocalizedString(String locale) {
    final normalised = _normaliseLocale(locale);
    try {
      return DateFormat.yMd(normalised).format(this);
    } catch (_) {
      return toIso8601String().substring(0, 10);
    }
  }

  /// Returns a localised time string (e.g. `'14:35'`).
  String toLocalizedTime(String locale) {
    final normalised = _normaliseLocale(locale);
    try {
      return DateFormat.Hm(normalised).format(this);
    } catch (_) {
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }
  }

  // -------------------------------------------------------------------------
  // Date comparison
  // -------------------------------------------------------------------------

  /// `true` when this [DateTime] falls on the same calendar day as [DateTime.now()].
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// `true` when this [DateTime] falls on the calendar day before today.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// `true` when this [DateTime] is in the current calendar week (Mon–Sun).
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final d = DateTime(year, month, day);
    return !d.isBefore(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day)) &&
        !d.isAfter(DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day));
  }

  // -------------------------------------------------------------------------
  // Day-of-week
  // -------------------------------------------------------------------------

  /// Returns the localised day-of-week name.
  ///
  /// [locale] follows the same convention as [toLocalizedString].
  /// Returns the full name by default; pass [abbreviated] = `true` for a 3-letter
  /// abbreviation (e.g. `'lun'` / `'Mon'`).
  String dayOfWeek(String locale, {bool abbreviated = false}) {
    final normalised = _normaliseLocale(locale);
    try {
      final formatter = abbreviated
          ? DateFormat.E(normalised)   // Mon / lun
          : DateFormat.EEEE(normalised); // Monday / lunes
      return formatter.format(this);
    } catch (_) {
      const days = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday', 'Sunday',
      ];
      return days[(weekday - 1) % 7];
    }
  }

  // -------------------------------------------------------------------------
  // Utility
  // -------------------------------------------------------------------------

  /// Returns a [DateTime] with time components zeroed out (midnight local).
  DateTime get dateOnly => DateTime(year, month, day);

  /// Returns a new [DateTime] at the given [hour] and [minute] on the same day.
  DateTime atTime(int hour, [int minute = 0]) =>
      DateTime(year, month, day, hour, minute);

  // -------------------------------------------------------------------------
  // Private helpers
  // -------------------------------------------------------------------------

  static String _normaliseLocale(String locale) {
    // intl uses underscores, BCP 47 uses hyphens.
    return locale.replaceAll('-', '_');
  }
}

// =============================================================================
// List extensions
// =============================================================================

extension ListExtensions<E> on List<E> {
  // -------------------------------------------------------------------------
  // groupBy
  // -------------------------------------------------------------------------

  /// Groups the list elements by a key extracted with [keyOf].
  ///
  /// Returns a [Map] from key → [List<E>] preserving insertion order.
  ///
  /// ```dart
  /// final byCategory = symbols.groupBy((s) => s.category);
  /// ```
  Map<K, List<E>> groupBy<K>(K Function(E element) keyOf) {
    final result = <K, List<E>>{};
    for (final element in this) {
      final key = keyOf(element);
      (result[key] ??= []).add(element);
    }
    return result;
  }

  // -------------------------------------------------------------------------
  // safeGet
  // -------------------------------------------------------------------------

  /// Returns the element at [index], or `null` if the index is out of bounds.
  ///
  /// ```dart
  /// final first = list.safeGet(0);   // null-safe
  /// final missing = list.safeGet(99); // → null
  /// ```
  E? safeGet(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  // -------------------------------------------------------------------------
  // Additional conveniences
  // -------------------------------------------------------------------------

  /// Returns a new list with duplicates removed, preserving order.
  List<E> get distinct {
    final seen = <E>{};
    return where(seen.add).toList();
  }

  /// Returns a new list with elements satisfying [test] moved to the front.
  List<E> sortedWith(Comparator<E> compare) => [...this]..sort(compare);

  /// Returns `null` if empty, otherwise returns `this`.
  List<E>? get nullIfEmpty => isEmpty ? null : this;

  /// Splits the list into chunks of at most [size] elements.
  ///
  /// ```dart
  /// [1, 2, 3, 4, 5].chunked(2) // → [[1,2],[3,4],[5]]
  /// ```
  List<List<E>> chunked(int size) {
    assert(size > 0, 'chunk size must be positive');
    final result = <List<E>>[];
    for (var i = 0; i < length; i += size) {
      result.add(sublist(i, (i + size).clamp(0, length)));
    }
    return result;
  }
}

extension NullableListExtensions<E> on List<E>? {
  /// `true` when the nullable list is `null` or has no elements.
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

// =============================================================================
// Iterable extensions
// =============================================================================

extension IterableExtensions<E> on Iterable<E> {
  /// Returns the first element that satisfies [test], or `null` if none.
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Counts elements satisfying [test].
  int countWhere(bool Function(E element) test) =>
      where(test).length;
}

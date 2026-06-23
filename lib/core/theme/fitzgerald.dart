import 'package:flutter/material.dart';
import 'app_colors.dart';

// =============================================================================
// Fitzgerald Key — AAC clinical color-coding system
//
// The Fitzgerald Key (Edith Fitzgerald, 1929) is a color-coded symbol
// classification used in AAC practice to help users understand grammatical
// categories. Habla uses the contemporary color assignments widely adopted
// by AAC software (e.g. Boardmaker, Grid 3).
// =============================================================================

/// Grammatical / semantic categories used in the Fitzgerald Key color system.
enum FitzgeraldCategory {
  /// Pronouns, names — yellow.
  people,

  /// Verbs, actions — green.
  verbs,

  /// Adjectives, adverbs, descriptors — blue.
  descriptors,

  /// Nouns, objects, places, foods — orange.
  nouns,

  /// Social / pragmatic words (greetings, politeness) — pink/rose.
  social,

  /// Function / grammatical words (prepositions, conjunctions, articles) — purple.
  function,

  /// Navigation words (more, stop, go to, home) — terracotta/brown.
  navigation,
}

/// Helpers for working with [FitzgeraldCategory] values.
abstract final class FitzgeraldHelper {
  // -------------------------------------------------------------------------
  // Color mapping
  // -------------------------------------------------------------------------

  /// Returns the Fitzgerald Key color for [category].
  static Color colorForCategory(FitzgeraldCategory category) {
    switch (category) {
      case FitzgeraldCategory.people:
        return AppColors.fitzPeople;
      case FitzgeraldCategory.verbs:
        return AppColors.fitzVerbs;
      case FitzgeraldCategory.descriptors:
        return AppColors.fitzDescriptors;
      case FitzgeraldCategory.nouns:
        return AppColors.fitzNouns;
      case FitzgeraldCategory.social:
        return AppColors.fitzSocial;
      case FitzgeraldCategory.function:
        return AppColors.fitzFunction;
      case FitzgeraldCategory.navigation:
        return AppColors.fitzNavigation;
    }
  }

  /// Returns a high-contrast foreground color (black or white) suitable for
  /// text or icons drawn on top of [colorForCategory(category)].
  static Color foregroundForCategory(FitzgeraldCategory category) {
    final bg = colorForCategory(category);
    // Use the luminance threshold from WCAG 2.1 (0.179 ≈ boundary).
    return bg.computeLuminance() > 0.35 ? Colors.black87 : Colors.white;
  }

  // -------------------------------------------------------------------------
  // Localized labels (es-MX primary; English fallback)
  // -------------------------------------------------------------------------

  /// Returns the human-readable label for [category] in [locale].
  ///
  /// Supports `es` / `es-MX` (default) and `en` / `en-US`.
  /// All other locales fall back to Spanish.
  static String labelForCategory(FitzgeraldCategory category, Locale locale) {
    final languageCode = locale.languageCode.toLowerCase();

    if (languageCode == 'en') {
      return _englishLabel(category);
    }
    // Default: Spanish (es-MX)
    return _spanishLabel(category);
  }

  static String _spanishLabel(FitzgeraldCategory category) {
    switch (category) {
      case FitzgeraldCategory.people:
        return 'Personas';
      case FitzgeraldCategory.verbs:
        return 'Verbos';
      case FitzgeraldCategory.descriptors:
        return 'Descriptores';
      case FitzgeraldCategory.nouns:
        return 'Sustantivos';
      case FitzgeraldCategory.social:
        return 'Social';
      case FitzgeraldCategory.function:
        return 'Función';
      case FitzgeraldCategory.navigation:
        return 'Navegación';
    }
  }

  static String _englishLabel(FitzgeraldCategory category) {
    switch (category) {
      case FitzgeraldCategory.people:
        return 'People';
      case FitzgeraldCategory.verbs:
        return 'Verbs';
      case FitzgeraldCategory.descriptors:
        return 'Descriptors';
      case FitzgeraldCategory.nouns:
        return 'Nouns';
      case FitzgeraldCategory.social:
        return 'Social';
      case FitzgeraldCategory.function:
        return 'Function';
      case FitzgeraldCategory.navigation:
        return 'Navigation';
    }
  }

  // -------------------------------------------------------------------------
  // String → category parsing
  // -------------------------------------------------------------------------

  /// Parses a string (case-insensitive) into a [FitzgeraldCategory].
  ///
  /// Accepts both English and Spanish labels, as well as the raw enum
  /// name (e.g. `"people"`, `"verbs"`).
  ///
  /// Returns `null` if [value] does not match any known category.
  static FitzgeraldCategory? categoryFromString(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final normalized = value.trim().toLowerCase();

    switch (normalized) {
      // English labels
      case 'people':
      case 'person':
      case 'pronoun':
      case 'pronouns':
        return FitzgeraldCategory.people;

      case 'verbs':
      case 'verb':
      case 'action':
      case 'actions':
        return FitzgeraldCategory.verbs;

      case 'descriptors':
      case 'descriptor':
      case 'adjective':
      case 'adjectives':
        return FitzgeraldCategory.descriptors;

      case 'nouns':
      case 'noun':
      case 'object':
      case 'objects':
        return FitzgeraldCategory.nouns;

      case 'social':
        return FitzgeraldCategory.social;

      case 'function':
      case 'functions':
      case 'grammatical':
        return FitzgeraldCategory.function;

      case 'navigation':
      case 'nav':
        return FitzgeraldCategory.navigation;

      // Spanish labels
      case 'personas':
      case 'persona':
        return FitzgeraldCategory.people;

      case 'verbos':
      case 'verbo':
        return FitzgeraldCategory.verbs;

      case 'descriptores':
        return FitzgeraldCategory.descriptors;

      case 'sustantivos':
      case 'sustantivo':
        return FitzgeraldCategory.nouns;

      // 'social' already covered above

      case 'función':
      case 'funcion':
        return FitzgeraldCategory.function;

      case 'navegación':
      case 'navegacion':
        return FitzgeraldCategory.navigation;

      default:
        // Last-resort: try matching the raw Dart enum name.
        for (final cat in FitzgeraldCategory.values) {
          if (cat.name == normalized) return cat;
        }
        return null;
    }
  }

  // -------------------------------------------------------------------------
  // All categories (ordered for display)
  // -------------------------------------------------------------------------

  /// All [FitzgeraldCategory] values in the canonical display order
  /// (people → verbs → descriptors → nouns → social → function → navigation).
  static List<FitzgeraldCategory> get allCategories =>
      FitzgeraldCategory.values;

  const FitzgeraldHelper._();
}

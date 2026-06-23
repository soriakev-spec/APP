import 'package:flutter/material.dart';

/// Design-system color tokens for Habla AAC.
///
/// Colors are organized into four groups:
///   1. Brand / semantic base palette
///   2. Fitzgerald Key colors (clinical AAC color-coding system)
///   3. UI state colors (error, warning, success, info)
///   4. Neutral / surface colors
abstract final class AppColors {
  // -------------------------------------------------------------------------
  // Brand palette
  // -------------------------------------------------------------------------

  /// Primary ink color — used for text and high-contrast elements.
  static const Color inkTeal = Color(0xFF143A36);

  /// Warm off-white background — the main app canvas.
  static const Color surface = Color(0xFFF4F0E8);

  /// Pure white — paper/card surfaces layered above [surface].
  static const Color white = Color(0xFFFFFFFF);

  /// AI accent — violet, used for AI-generated suggestions and assistant UI.
  static const Color aiViolet = Color(0xFF5B53C9);

  /// AI light background — subtle tint behind AI-branded elements.
  static const Color aiVioletLight = Color(0xFFEDE9FD);

  // -------------------------------------------------------------------------
  // Fitzgerald Key colors
  // Clinical color-coding system widely used in AAC practice.
  // Reference: Goossens', Crain & Elder (1992).
  // -------------------------------------------------------------------------

  /// Yellow — people / pronouns (who).
  static const Color fitzPeople = Color(0xFFFFC107);

  /// Green — verbs / actions (what doing).
  static const Color fitzVerbs = Color(0xFF4CAF50);

  /// Blue — descriptors / adjectives (what like).
  static const Color fitzDescriptors = Color(0xFF2196F3);

  /// Orange — nouns / objects (what).
  static const Color fitzNouns = Color(0xFFFF9800);

  /// Pink / rose — social words (greetings, politeness).
  static const Color fitzSocial = Color(0xFFE91E63);

  /// Purple / lilac — function / grammatical words (is, the, and …).
  static const Color fitzFunction = Color(0xFF9C27B0);

  /// Terracotta / brown — navigation words (more, stop, go to …).
  static const Color fitzNavigation = Color(0xFF795548);

  // -------------------------------------------------------------------------
  // UI state colors
  // -------------------------------------------------------------------------

  /// Error / destructive action.
  static const Color error = Color(0xFFD32F2F);

  /// Light error background (chips, banners).
  static const Color errorLight = Color(0xFFFFEBEE);

  /// Warning / caution.
  static const Color warning = Color(0xFFF57F17);

  /// Light warning background.
  static const Color warningLight = Color(0xFFFFF8E1);

  /// Success / confirmation.
  static const Color success = Color(0xFF2E7D32);

  /// Light success background.
  static const Color successLight = Color(0xFFE8F5E9);

  /// Informational / neutral.
  static const Color info = Color(0xFF0277BD);

  /// Light info background.
  static const Color infoLight = Color(0xFFE1F5FE);

  // -------------------------------------------------------------------------
  // Neutral / structural greys
  // -------------------------------------------------------------------------

  static const Color grey50  = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // -------------------------------------------------------------------------
  // Divider / border
  // -------------------------------------------------------------------------

  /// Subtle divider line drawn on [surface].
  static const Color divider = Color(0xFFDDD8CE);

  /// Slightly stronger border for cards and inputs.
  static const Color border = Color(0xFFC8C3B8);

  // -------------------------------------------------------------------------
  // Opacity helpers (semi-transparent overlays)
  // -------------------------------------------------------------------------

  /// Dark scrim for dialogs / bottom sheets.
  static const Color scrim = Color(0x80000000);

  /// Hover / pressed highlight on light surfaces.
  static const Color highlight = Color(0x1A143A36);

  // -------------------------------------------------------------------------
  // Private constructor — this class is purely static.
  // -------------------------------------------------------------------------
  const AppColors._();
}

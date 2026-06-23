import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Font family constants.
abstract final class AppFonts {
  /// Used for headings, display text, and branded titles.
  static const String bricolageGrotesque = 'BricolageGrotesque';

  /// Used for UI body text, labels, and general reading.
  static const String dmSans = 'DMSans';

  const AppFonts._();
}

/// Full [TextTheme] for the Habla design system.
///
/// Heading styles use [AppFonts.bricolageGrotesque].
/// Body / label styles use [AppFonts.dmSans].
///
/// All sizes follow the Material 3 type scale with AAC-friendly
/// minimum sizes (16 sp body baseline) for accessibility.
abstract final class AppTypography {
  // -------------------------------------------------------------------------
  // TextTheme
  // -------------------------------------------------------------------------

  static TextTheme get textTheme => const TextTheme(
        // ----- Display -----
        displayLarge: TextStyle(
          fontFamily: AppFonts.bricolageGrotesque,
          fontSize: 57,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
          height: 1.12,
          color: AppColors.inkTeal,
        ),
        displayMedium: TextStyle(
          fontFamily: AppFonts.bricolageGrotesque,
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.16,
          color: AppColors.inkTeal,
        ),
        displaySmall: TextStyle(
          fontFamily: AppFonts.bricolageGrotesque,
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.22,
          color: AppColors.inkTeal,
        ),

        // ----- Headline -----
        headlineLarge: TextStyle(
          fontFamily: AppFonts.bricolageGrotesque,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.25,
          color: AppColors.inkTeal,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppFonts.bricolageGrotesque,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.29,
          color: AppColors.inkTeal,
        ),
        headlineSmall: TextStyle(
          fontFamily: AppFonts.bricolageGrotesque,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.33,
          color: AppColors.inkTeal,
        ),

        // ----- Title -----
        titleLarge: TextStyle(
          fontFamily: AppFonts.bricolageGrotesque,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.27,
          color: AppColors.inkTeal,
        ),
        titleMedium: TextStyle(
          fontFamily: AppFonts.dmSans,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          height: 1.50,
          color: AppColors.inkTeal,
        ),
        titleSmall: TextStyle(
          fontFamily: AppFonts.dmSans,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.43,
          color: AppColors.inkTeal,
        ),

        // ----- Body -----
        bodyLarge: TextStyle(
          fontFamily: AppFonts.dmSans,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.50,
          color: AppColors.inkTeal,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppFonts.dmSans,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.43,
          color: AppColors.inkTeal,
        ),
        bodySmall: TextStyle(
          fontFamily: AppFonts.dmSans,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.33,
          color: AppColors.grey600,
        ),

        // ----- Label -----
        labelLarge: TextStyle(
          fontFamily: AppFonts.dmSans,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.43,
          color: AppColors.inkTeal,
        ),
        labelMedium: TextStyle(
          fontFamily: AppFonts.dmSans,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.33,
          color: AppColors.inkTeal,
        ),
        labelSmall: TextStyle(
          fontFamily: AppFonts.dmSans,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.45,
          color: AppColors.grey600,
        ),
      );

  const AppTypography._();
}

/// Named text styles for specific AAC UI components.
///
/// These extend the Material type scale with component-specific
/// sizes that are tuned for AAC usage (touch targets, pictogram labels, etc.).
abstract final class AppTextStyles {
  // -------------------------------------------------------------------------
  // Pictogram / symbol cell label
  // -------------------------------------------------------------------------

  /// Label shown below a pictogram cell in 4-column grids.
  /// Large enough to read at arm's length on a tablet.
  static const TextStyle symbolLabelLarge = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.2,
    color: AppColors.inkTeal,
  );

  /// Label for smaller cells (8-col+ grids).
  static const TextStyle symbolLabelMedium = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.2,
    color: AppColors.inkTeal,
  );

  /// Label for very dense grids (15+).
  static const TextStyle symbolLabelSmall = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 9,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.1,
    color: AppColors.inkTeal,
  );

  // -------------------------------------------------------------------------
  // Output / message bar
  // -------------------------------------------------------------------------

  /// Text shown in the AAC output / message bar at the top of the screen.
  static const TextStyle outputBar = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.4,
    color: AppColors.inkTeal,
  );

  /// Smaller output bar variant when many words are queued.
  static const TextStyle outputBarCompact = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.35,
    color: AppColors.inkTeal,
  );

  // -------------------------------------------------------------------------
  // Navigation / category headers
  // -------------------------------------------------------------------------

  /// Category tile header label (used in sidebar navigation).
  static const TextStyle categoryHeader = TextStyle(
    fontFamily: AppFonts.bricolageGrotesque,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.05,
    height: 1.3,
    color: AppColors.inkTeal,
  );

  // -------------------------------------------------------------------------
  // AI suggestion chip
  // -------------------------------------------------------------------------

  /// Label inside an AI-generated suggestion chip.
  static const TextStyle aiChip = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.3,
    color: AppColors.aiViolet,
  );

  // -------------------------------------------------------------------------
  // Settings / forms
  // -------------------------------------------------------------------------

  /// Primary text for list tiles and form fields.
  static const TextStyle settingsTile = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.inkTeal,
  );

  /// Secondary/subtitle text in settings tiles.
  static const TextStyle settingsTileSubtitle = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.4,
    color: AppColors.grey600,
  );

  // -------------------------------------------------------------------------
  // Section dividers
  // -------------------------------------------------------------------------

  /// All-caps section label (e.g. "VOZ", "PERFIL").
  static const TextStyle sectionLabel = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    height: 1.4,
    color: AppColors.grey500,
  );

  // -------------------------------------------------------------------------
  // Button labels
  // -------------------------------------------------------------------------

  /// Primary / filled button label.
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.2,
    color: AppColors.white,
  );

  /// Secondary / outlined button label.
  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: AppFonts.dmSans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.2,
    color: AppColors.inkTeal,
  );

  const AppTextStyles._();
}

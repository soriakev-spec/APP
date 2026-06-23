import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Entry-point for Habla design-system theming.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
/// );
/// ```
///
/// Reduce-motion support: components that animate should check
/// [AppTheme.reduceMotion] (or the extension on [BuildContext]) before
/// running animations.
abstract final class AppTheme {
  // -------------------------------------------------------------------------
  // Light theme
  // -------------------------------------------------------------------------

  static ThemeData get light {
    final colorScheme = _colorScheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      primaryTextTheme: AppTypography.textTheme,

      // Tablet-optimized: compact visual density keeps touch targets large
      // while reducing wasted whitespace on big screens.
      visualDensity: VisualDensity.compact,

      // Scaffold / canvas
      scaffoldBackgroundColor: AppColors.surface,
      canvasColor: AppColors.surface,

      // Dividers
      dividerColor: AppColors.divider,
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ---- Component themes ----
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
      dialogTheme: _dialogTheme,
      bottomSheetTheme: _bottomSheetTheme,
      navigationRailTheme: _navigationRailTheme(colorScheme),
      navigationDrawerTheme: _navigationDrawerTheme(colorScheme),
      tabBarTheme: _tabBarTheme(colorScheme),
      tooltipTheme: _tooltipTheme,
      snackBarTheme: _snackBarTheme,
      listTileTheme: _listTileTheme(colorScheme),
      iconTheme: const IconThemeData(color: AppColors.inkTeal, size: 24),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: AppColors.grey200,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // ColorScheme
  // -------------------------------------------------------------------------

  static ColorScheme get _colorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.inkTeal,
        onPrimary: AppColors.white,
        primaryContainer: Color(0xFFCCE8E4),
        onPrimaryContainer: AppColors.inkTeal,
        secondary: AppColors.aiViolet,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.aiVioletLight,
        onSecondaryContainer: AppColors.aiViolet,
        tertiary: AppColors.fitzVerbs,
        onTertiary: AppColors.white,
        tertiaryContainer: Color(0xFFD7F3D8),
        onTertiaryContainer: Color(0xFF1B5E20),
        error: AppColors.error,
        onError: AppColors.white,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.error,
        surface: AppColors.surface,
        onSurface: AppColors.inkTeal,
        surfaceContainerHighest: AppColors.white,
        onSurfaceVariant: AppColors.grey600,
        outline: AppColors.border,
        outlineVariant: AppColors.divider,
        shadow: Color(0x1A000000),
        scrim: AppColors.scrim,
        inverseSurface: AppColors.inkTeal,
        onInverseSurface: AppColors.white,
        inversePrimary: Color(0xFF8EC8C2),
      );

  // -------------------------------------------------------------------------
  // AppBar
  // -------------------------------------------------------------------------

  static AppBarTheme _appBarTheme(ColorScheme cs) => AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.inkTeal,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.scrim,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: AppColors.inkTeal,
        ),
        iconTheme: const IconThemeData(color: AppColors.inkTeal, size: 24),
        actionsIconTheme: const IconThemeData(color: AppColors.inkTeal, size: 24),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.surface,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

  // -------------------------------------------------------------------------
  // Card
  // -------------------------------------------------------------------------

  static CardThemeData get _cardTheme => CardThemeData(
        color: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.divider, width: 1),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      );

  // -------------------------------------------------------------------------
  // Buttons
  // -------------------------------------------------------------------------

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme cs) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.inkTeal,
          foregroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme cs) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.inkTeal,
          surfaceTintColor: Colors.transparent,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      );

  static TextButtonThemeData _textButtonTheme(ColorScheme cs) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.inkTeal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          minimumSize: const Size(48, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  // -------------------------------------------------------------------------
  // Input decoration
  // -------------------------------------------------------------------------

  static InputDecorationTheme _inputDecorationTheme(ColorScheme cs) =>
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.inkTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.grey400,
        ),
        labelStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.grey600,
        ),
        floatingLabelStyle: AppTypography.textTheme.bodySmall?.copyWith(
          color: AppColors.inkTeal,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: AppTypography.textTheme.bodySmall?.copyWith(
          color: AppColors.error,
        ),
      );

  // -------------------------------------------------------------------------
  // Chip
  // -------------------------------------------------------------------------

  static ChipThemeData _chipTheme(ColorScheme cs) => ChipThemeData(
        backgroundColor: AppColors.grey100,
        selectedColor: AppColors.aiVioletLight,
        labelStyle: AppTypography.textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.divider),
        ),
        elevation: 0,
        pressElevation: 0,
      );

  // -------------------------------------------------------------------------
  // Dialog
  // -------------------------------------------------------------------------

  static DialogThemeData get _dialogTheme => DialogThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shadowColor: AppColors.scrim,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: AppTypography.textTheme.headlineSmall,
        contentTextStyle: AppTypography.textTheme.bodyLarge,
      );

  // -------------------------------------------------------------------------
  // Bottom sheet
  // -------------------------------------------------------------------------

  static BottomSheetThemeData get _bottomSheetTheme => const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        clipBehavior: Clip.antiAlias,
        showDragHandle: true,
      );

  // -------------------------------------------------------------------------
  // Navigation rail (tablet sidebar)
  // -------------------------------------------------------------------------

  static NavigationRailThemeData _navigationRailTheme(ColorScheme cs) =>
      NavigationRailThemeData(
        backgroundColor: AppColors.white,
        elevation: 0,
        selectedIconTheme: const IconThemeData(color: AppColors.inkTeal, size: 24),
        unselectedIconTheme: IconThemeData(color: AppColors.grey500, size: 24),
        selectedLabelTextStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: AppColors.inkTeal,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: AppColors.grey500,
        ),
        indicatorColor: AppColors.highlight,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelType: NavigationRailLabelType.all,
        minWidth: 72,
        minExtendedWidth: 200,
      );

  // -------------------------------------------------------------------------
  // Navigation drawer
  // -------------------------------------------------------------------------

  static NavigationDrawerThemeData _navigationDrawerTheme(ColorScheme cs) =>
      NavigationDrawerThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: AppColors.scrim,
        indicatorColor: AppColors.highlight,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.textTheme.labelLarge?.copyWith(
              color: AppColors.inkTeal,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.textTheme.labelLarge?.copyWith(
            color: AppColors.grey600,
          );
        }),
      );

  // -------------------------------------------------------------------------
  // TabBar
  // -------------------------------------------------------------------------

  static TabBarThemeData _tabBarTheme(ColorScheme cs) => TabBarThemeData(
        labelColor: AppColors.inkTeal,
        unselectedLabelColor: AppColors.grey500,
        labelStyle: AppTypography.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.textTheme.labelLarge,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.inkTeal, width: 2),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.divider,
      );

  // -------------------------------------------------------------------------
  // Tooltip
  // -------------------------------------------------------------------------

  static TooltipThemeData get _tooltipTheme => TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.inkTeal.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: AppTypography.textTheme.bodySmall?.copyWith(
          color: AppColors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        waitDuration: const Duration(milliseconds: 500),
      );

  // -------------------------------------------------------------------------
  // SnackBar
  // -------------------------------------------------------------------------

  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
        backgroundColor: AppColors.inkTeal,
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.white,
        ),
        actionTextColor: AppColors.aiVioletLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
      );

  // -------------------------------------------------------------------------
  // ListTile
  // -------------------------------------------------------------------------

  static ListTileThemeData _listTileTheme(ColorScheme cs) => ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.highlight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minLeadingWidth: 24,
        minVerticalPadding: 12,
        titleTextStyle: AppTypography.textTheme.bodyLarge,
        subtitleTextStyle: AppTypography.textTheme.bodySmall,
        leadingAndTrailingTextStyle: AppTypography.textTheme.labelMedium,
        iconColor: AppColors.grey600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

  // -------------------------------------------------------------------------
  // Reduce-motion helper
  // -------------------------------------------------------------------------

  /// Returns `true` when the OS "Reduce Motion" / "Remove Animations"
  /// accessibility setting is enabled.
  ///
  /// Widgets should call this inside `build` so they react to live changes:
  /// ```dart
  /// final noMotion = AppTheme.reduceMotion(context);
  /// final duration = noMotion ? Duration.zero : const Duration(milliseconds: 300);
  /// ```
  static bool reduceMotion(BuildContext context) =>
      MediaQuery.of(context).disableAnimations;

  const AppTheme._();
}

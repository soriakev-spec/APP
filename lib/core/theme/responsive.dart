import 'package:flutter/material.dart';

// =============================================================================
// Breakpoints
// =============================================================================

/// Screen-width breakpoints for Habla's responsive layout system.
///
/// Habla primarily targets Android tablets (sw600dp+) but the layout
/// degrades gracefully on phones for development and edge-case users.
abstract final class Breakpoints {
  /// Maximum width considered "mobile" (exclusive upper bound).
  static const double mobile = 600;

  /// Minimum width for "tablet" layout (inclusive lower bound).
  static const double tablet = 600;

  /// Minimum width for "desktop" layout (two-panel + extended rail).
  static const double desktop = 1200;

  const Breakpoints._();
}

// =============================================================================
// Screen-size enum
// =============================================================================

enum ScreenSize { mobile, tablet, desktop }

/// Resolve the [ScreenSize] for a given [width].
ScreenSize _screenSizeOf(double width) {
  if (width >= Breakpoints.desktop) return ScreenSize.desktop;
  if (width >= Breakpoints.tablet) return ScreenSize.tablet;
  return ScreenSize.mobile;
}

// =============================================================================
// BuildContext extensions
// =============================================================================

extension BuildContextResponsiveExtension on BuildContext {
  /// The current logical screen width in dp.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// The current logical screen height in dp.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Resolved [ScreenSize] based on current screen width.
  ScreenSize get screenSize => _screenSizeOf(screenWidth);

  /// `true` when the available width is below the tablet breakpoint (< 600 dp).
  bool get isMobile => screenSize == ScreenSize.mobile;

  /// `true` when the available width is between 600 dp and 1200 dp (exclusive).
  bool get isTablet => screenSize == ScreenSize.tablet;

  /// `true` when the available width is 1200 dp or more.
  bool get isDesktop => screenSize == ScreenSize.desktop;

  /// `true` when the screen is tablet-sized OR desktop-sized.
  bool get isTabletOrLarger => !isMobile;
}

// =============================================================================
// Responsive widget
// =============================================================================

/// A widget that renders different layouts based on the current screen size.
///
/// Exactly one of [mobile], [tablet], or [desktop] is shown at any time.
/// If [tablet] is omitted, the [mobile] builder is used for tablet screens.
/// If [desktop] is omitted, the [tablet] (or [mobile]) builder is used.
///
/// Example:
/// ```dart
/// Responsive(
///   mobile:  (_) => const MobileHome(),
///   tablet:  (_) => const TabletHome(),
///   desktop: (_) => const DesktopHome(),
/// )
/// ```
class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;

    switch (size) {
      case ScreenSize.desktop:
        return (desktop ?? tablet ?? mobile)(context);
      case ScreenSize.tablet:
        return (tablet ?? mobile)(context);
      case ScreenSize.mobile:
        return mobile(context);
    }
  }
}

// =============================================================================
// ResponsiveValue — inline value selector
// =============================================================================

/// Returns one of three values depending on the current [ScreenSize].
///
/// Useful for picking padding, font sizes, or column counts inline without
/// a dedicated widget.
///
/// ```dart
/// final columns = responsiveValue(
///   context,
///   mobile:  4,
///   tablet:  8,
///   desktop: 12,
/// );
/// ```
T responsiveValue<T>(
  BuildContext context, {
  required T mobile,
  T? tablet,
  T? desktop,
}) {
  final size = context.screenSize;
  switch (size) {
    case ScreenSize.desktop:
      return desktop ?? tablet ?? mobile;
    case ScreenSize.tablet:
      return tablet ?? mobile;
    case ScreenSize.mobile:
      return mobile;
  }
}

// =============================================================================
// ResponsiveLayout — two-panel layout for tablets
// =============================================================================

/// A two-panel layout suitable for tablet and desktop screens.
///
/// On mobile, only [content] is displayed (the sidebar is hidden or
/// accessed via a drawer — the caller is responsible for that).
/// On tablet and desktop the [sidebar] and [content] are shown side by side.
///
/// The [sidebarWidth] defaults to 260 dp on tablet and 300 dp on desktop.
/// A [divider] can be inserted between the two panels.
///
/// Example (inside a Scaffold body):
/// ```dart
/// ResponsiveLayout(
///   sidebar: CategoryNav(),
///   content: SymbolGrid(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.sidebar,
    required this.content,
    this.sidebarWidth,
    this.showDivider = true,
    this.sidebarBackgroundColor,
  });

  final Widget sidebar;
  final Widget content;

  /// Override the sidebar width.  Defaults are 260 (tablet) and 300 (desktop).
  final double? sidebarWidth;

  /// Whether to render a 1 dp vertical divider between the two panels.
  final bool showDivider;

  /// Background color of the sidebar panel.
  /// Defaults to [Theme.of(context).colorScheme.surface].
  final Color? sidebarBackgroundColor;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      // On mobile, content fills the screen. The sidebar should be surfaced
      // via a Drawer or bottom sheet at the call site.
      return content;
    }

    final effectiveSidebarWidth = sidebarWidth ??
        (context.isDesktop ? 300.0 : 260.0);

    final bgColor = sidebarBackgroundColor ??
        Theme.of(context).colorScheme.surface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sidebar panel
        SizedBox(
          width: effectiveSidebarWidth,
          child: ColoredBox(
            color: bgColor,
            child: sidebar,
          ),
        ),

        // Optional divider
        if (showDivider)
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),

        // Content panel — fills remaining space
        Expanded(child: content),
      ],
    );
  }
}

// =============================================================================
// ResponsivePadding — padding that adapts to screen size
// =============================================================================

/// Wraps [child] with padding that scales with the screen size.
///
/// Defaults: mobile = 12, tablet = 20, desktop = 32.
class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding = 12.0,
    this.tabletPadding = 20.0,
    this.desktopPadding = 32.0,
  });

  final Widget child;
  final double mobilePadding;
  final double tabletPadding;
  final double desktopPadding;

  @override
  Widget build(BuildContext context) {
    final padding = responsiveValue(
      context,
      mobile: mobilePadding,
      tablet: tabletPadding,
      desktop: desktopPadding,
    );
    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}

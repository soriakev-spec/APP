// App shell — provides persistent navigation for Habla AAC.
// Tablet (width >= 600): fixed sidebar (AppSideNav) + content area.
// Phone  (width <  600): content area + bottom bar (AppBottomNav).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:habla/core/router/app_router.dart';
import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/state/providers/profile_provider.dart';

// ---------------------------------------------------------------------------
// AppShell
// ---------------------------------------------------------------------------

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    if (isTablet) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: Row(
          children: [
            AppSideNav(),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.divider,
            ),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: child,
      bottomNavigationBar: AppBottomNav(),
    );
  }
}

// ---------------------------------------------------------------------------
// Navigation item model
// ---------------------------------------------------------------------------

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

// All navigation destinations in display order.
const List<_NavItem> _allNavItems = [
  _NavItem(
    label: 'Inicio',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    route: AppRoutes.home,
  ),
  _NavItem(
    label: 'Comunicar',
    icon: Icons.chat_bubble_outline,
    activeIcon: Icons.chat_bubble,
    route: AppRoutes.communicate,
  ),
  _NavItem(
    label: 'Tableros',
    icon: Icons.grid_view_outlined,
    activeIcon: Icons.grid_view,
    route: AppRoutes.boards,
  ),
  _NavItem(
    label: 'IA',
    icon: Icons.auto_awesome_outlined,
    activeIcon: Icons.auto_awesome,
    route: AppRoutes.ai,
  ),
  _NavItem(
    label: 'Frases',
    icon: Icons.format_quote_outlined,
    activeIcon: Icons.format_quote,
    route: AppRoutes.phrases,
  ),
  _NavItem(
    label: 'Escenarios',
    icon: Icons.map_outlined,
    activeIcon: Icons.map,
    route: AppRoutes.scenarios,
  ),
  _NavItem(
    label: 'Actividades',
    icon: Icons.sports_esports_outlined,
    activeIcon: Icons.sports_esports,
    route: AppRoutes.activities,
  ),
  _NavItem(
    label: 'Apoyos',
    icon: Icons.support_outlined,
    activeIcon: Icons.support,
    route: AppRoutes.supports,
  ),
  _NavItem(
    label: 'Terapeuta',
    icon: Icons.medical_services_outlined,
    activeIcon: Icons.medical_services,
    route: AppRoutes.therapist,
  ),
  _NavItem(
    label: 'Familia',
    icon: Icons.family_restroom_outlined,
    activeIcon: Icons.family_restroom,
    route: AppRoutes.family,
  ),
  _NavItem(
    label: 'Reportes',
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart,
    route: AppRoutes.reports,
  ),
  _NavItem(
    label: 'Biblioteca',
    icon: Icons.library_books_outlined,
    activeIcon: Icons.library_books,
    route: AppRoutes.library,
  ),
  _NavItem(
    label: 'Ecosistema',
    icon: Icons.hub_outlined,
    activeIcon: Icons.hub,
    route: AppRoutes.ecosystem,
  ),
  _NavItem(
    label: 'Ajustes',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    route: AppRoutes.settings,
  ),
];

// Top-5 items shown directly in the bottom bar on phone.
const List<_NavItem> _bottomPrimaryItems = [
  _NavItem(
    label: 'Inicio',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    route: AppRoutes.home,
  ),
  _NavItem(
    label: 'Comunicar',
    icon: Icons.chat_bubble_outline,
    activeIcon: Icons.chat_bubble,
    route: AppRoutes.communicate,
  ),
  _NavItem(
    label: 'Tableros',
    icon: Icons.grid_view_outlined,
    activeIcon: Icons.grid_view,
    route: AppRoutes.boards,
  ),
  _NavItem(
    label: 'IA',
    icon: Icons.auto_awesome_outlined,
    activeIcon: Icons.auto_awesome,
    route: AppRoutes.ai,
  ),
  _NavItem(
    label: 'Ajustes',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    route: AppRoutes.settings,
  ),
];

// Items that appear in the "Más" drawer on phone.
const List<_NavItem> _drawerItems = [
  _NavItem(
    label: 'Frases',
    icon: Icons.format_quote_outlined,
    activeIcon: Icons.format_quote,
    route: AppRoutes.phrases,
  ),
  _NavItem(
    label: 'Escenarios',
    icon: Icons.map_outlined,
    activeIcon: Icons.map,
    route: AppRoutes.scenarios,
  ),
  _NavItem(
    label: 'Actividades',
    icon: Icons.sports_esports_outlined,
    activeIcon: Icons.sports_esports,
    route: AppRoutes.activities,
  ),
  _NavItem(
    label: 'Apoyos',
    icon: Icons.support_outlined,
    activeIcon: Icons.support,
    route: AppRoutes.supports,
  ),
  _NavItem(
    label: 'Terapeuta',
    icon: Icons.medical_services_outlined,
    activeIcon: Icons.medical_services,
    route: AppRoutes.therapist,
  ),
  _NavItem(
    label: 'Familia',
    icon: Icons.family_restroom_outlined,
    activeIcon: Icons.family_restroom,
    route: AppRoutes.family,
  ),
  _NavItem(
    label: 'Reportes',
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart,
    route: AppRoutes.reports,
  ),
  _NavItem(
    label: 'Biblioteca',
    icon: Icons.library_books_outlined,
    activeIcon: Icons.library_books,
    route: AppRoutes.library,
  ),
  _NavItem(
    label: 'Ecosistema',
    icon: Icons.hub_outlined,
    activeIcon: Icons.hub,
    route: AppRoutes.ecosystem,
  ),
];

// ---------------------------------------------------------------------------
// AppSideNav — tablet sidebar
// ---------------------------------------------------------------------------

class AppSideNav extends ConsumerWidget {
  const AppSideNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final profile = ref.watch(currentProfileDataProvider);

    return Container(
      width: 220,
      color: AppColors.inkTeal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Logo / brand ----
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.aiViolet,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.record_voice_over,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Habla',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ---- Nav items ----
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              itemCount: _allNavItems.length,
              itemBuilder: (context, index) {
                final item = _allNavItems[index];
                final isActive = _isRouteActive(location, item.route);
                return _SideNavTile(
                  item: item,
                  isActive: isActive,
                  onTap: () => context.go(item.route),
                );
              },
            ),
          ),

          // ---- Profile switcher at bottom ----
          const Divider(color: AppColors.divider, height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              onTap: () => context.go(AppRoutes.settingsProfiles),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.aiViolet,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          profile?.avatarEmoji ?? '🧑',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            profile?.name ?? 'Sin perfil',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            profile?.diagnosis ?? '',
                            style: TextStyle(
                              color: AppColors.white.withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.swap_horiz,
                      color: AppColors.white.withValues(alpha: 0.6),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(top: false, child: const SizedBox(height: 4)),
        ],
      ),
    );
  }
}

class _SideNavTile extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _SideNavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: isActive
            ? AppColors.aiViolet.withValues(alpha: 0.25)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          hoverColor: AppColors.white.withValues(alpha: 0.06),
          splashColor: AppColors.aiViolet.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  color: isActive
                      ? AppColors.aiViolet
                      : AppColors.white.withValues(alpha: 0.75),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: TextStyle(
                    color: isActive
                        ? AppColors.white
                        : AppColors.white.withValues(alpha: 0.75),
                    fontSize: 14,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: 'DMSans',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AppBottomNav — phone bottom navigation bar
// ---------------------------------------------------------------------------

class AppBottomNav extends ConsumerWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;

    // Compute which primary tab is selected (-1 = none, opens drawer).
    int selectedIndex = _bottomPrimaryItems
        .indexWhere((item) => _isRouteActive(location, item.route));

    return NavigationBar(
      backgroundColor: AppColors.inkTeal,
      indicatorColor: AppColors.aiViolet.withValues(alpha: 0.3),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
      onDestinationSelected: (index) {
        if (index < _bottomPrimaryItems.length) {
          context.go(_bottomPrimaryItems[index].route);
        }
      },
      destinations: [
        ..._bottomPrimaryItems.map(
          (item) => NavigationDestination(
            icon: Icon(
              item.icon,
              color: AppColors.white.withValues(alpha: 0.65),
            ),
            selectedIcon: Icon(item.activeIcon, color: AppColors.white),
            label: item.label,
          ),
        ),
        // "Más" pseudo-destination that opens a bottom sheet drawer.
        NavigationDestination(
          icon: Icon(Icons.more_horiz, color: AppColors.white.withValues(alpha: 0.65)),
          selectedIcon: const Icon(Icons.more_horiz, color: AppColors.white),
          label: 'Más',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// "Más" bottom-sheet drawer (phone only)
// ---------------------------------------------------------------------------

void showMoreDrawer(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.inkTeal,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _MoreDrawer(),
  );
}

class _MoreDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.1,
              ),
              itemCount: _drawerItems.length,
              itemBuilder: (context, index) {
                final item = _drawerItems[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go(item.route);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, color: AppColors.white, size: 28),
                        const SizedBox(height: 6),
                        Text(
                          item.label,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontFamily: 'DMSans',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Route-matching helper
// ---------------------------------------------------------------------------

/// Returns true if [currentLocation] should be considered active for [route].
/// Matches exact and prefix (for sub-routes), but avoids false positives
/// (e.g. /home should not match /home/foo if /home/foo is a different item).
bool _isRouteActive(String currentLocation, String route) {
  // Strip path parameters from the pattern (e.g. ':id' → any segment).
  if (currentLocation == route) return true;
  if (currentLocation.startsWith('$route/')) return true;
  return false;
}

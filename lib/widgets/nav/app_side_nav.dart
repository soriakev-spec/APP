import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/state/providers/profile_provider.dart';

// ---------------------------------------------------------------------------
// Nav item model
// ---------------------------------------------------------------------------

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

const List<_NavItem> _navItems = [
  _NavItem(label: 'Inicio', icon: Icons.home_rounded, route: '/home'),
  _NavItem(label: 'Comunicar', icon: Icons.chat_bubble_rounded, route: '/communicate'),
  _NavItem(label: 'Tableros', icon: Icons.grid_view_rounded, route: '/boards'),
  _NavItem(label: 'IA', icon: Icons.auto_awesome_rounded, route: '/ai'),
  _NavItem(label: 'Frases', icon: Icons.format_quote_rounded, route: '/phrases'),
  _NavItem(label: 'Escenarios', icon: Icons.theater_comedy_rounded, route: '/scenarios'),
  _NavItem(label: 'Actividades', icon: Icons.school_rounded, route: '/activities'),
  _NavItem(label: 'Apoyos', icon: Icons.support_rounded, route: '/supports'),
  _NavItem(label: 'Terapeuta', icon: Icons.bar_chart_rounded, route: '/therapist'),
  _NavItem(label: 'Familia', icon: Icons.family_restroom_rounded, route: '/family'),
  _NavItem(label: 'Reportes', icon: Icons.description_rounded, route: '/reports'),
  _NavItem(label: 'Biblioteca', icon: Icons.photo_library_rounded, route: '/library'),
  _NavItem(label: 'Ecosistema', icon: Icons.hub_rounded, route: '/ecosystem'),
  _NavItem(label: 'Ajustes', icon: Icons.settings_rounded, route: '/settings'),
];

// ---------------------------------------------------------------------------
// AppSideNav
// ---------------------------------------------------------------------------

/// Persistent sidebar navigation for Habla AAC.
///
/// Renders a full-height column with the Habla brand at the top, scrollable
/// nav items, and the active profile section at the bottom.
///
/// Usage — wrap in a [Row] alongside the main content area:
/// ```dart
/// Row(
///   children: [
///     AppSideNav(currentRoute: '/home'),
///     Expanded(child: child),
///   ],
/// )
/// ```
class AppSideNav extends ConsumerWidget {
  const AppSideNav({
    super.key,
    required this.currentRoute,
  });

  final String currentRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileDataProvider);

    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          right: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Column(
        children: [
          // ------------------------------------------------------------------
          // Brand header
          // ------------------------------------------------------------------
          const _BrandHeader(),

          const Divider(height: 1),

          // ------------------------------------------------------------------
          // Nav items (scrollable)
          // ------------------------------------------------------------------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                final isActive = currentRoute == item.route ||
                    currentRoute.startsWith('${item.route}/');
                return _NavTile(
                  item: item,
                  isActive: isActive,
                  onTap: () => context.go(item.route),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // ------------------------------------------------------------------
          // Profile section
          // ------------------------------------------------------------------
          _ProfileSection(profile: profile),

          // ------------------------------------------------------------------
          // Version
          // ------------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'v1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey400,
                    fontSize: 10,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Brand header
// ---------------------------------------------------------------------------

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.inkTeal,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'H',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Habla',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.inkTeal,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Nav tile
// ---------------------------------------------------------------------------

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isActive ? AppColors.inkTeal.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isActive ? AppColors.inkTeal : AppColors.grey500,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isActive ? AppColors.inkTeal : AppColors.grey600,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isActive)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.inkTeal,
                      shape: BoxShape.circle,
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
// Profile section
// ---------------------------------------------------------------------------

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.profile});

  final ProfileEntity? profile;

  String _diagnosisLabel(String diagnosis) {
    switch (diagnosis) {
      case 'autism':
        return 'Autismo';
      case 'aphasia':
        return 'Afasia';
      case 'als':
        return 'ELA';
      case 'cerebral_palsy':
        return 'P. Cerebral';
      case 'down_syndrome':
        return 'S. Down';
      case 'child':
        return 'Niño';
      case 'adult_general':
        return 'Adulto';
      default:
        return diagnosis;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const SizedBox(height: 8);
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.inkTeal.withValues(alpha: 0.1),
                child: Text(
                  profile!.avatarEmoji ?? '🧩',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile!.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.inkTeal,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.aiVioletLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _diagnosisLabel(profile!.diagnosis),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.aiViolet,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/profiles'),
              icon: const Icon(Icons.swap_horiz_rounded, size: 14),
              label: const Text('Cambiar perfil'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                minimumSize: const Size(0, 32),
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/state/providers/communicate_provider.dart';

// ---------------------------------------------------------------------------
// Category definitions
// ---------------------------------------------------------------------------

class _Category {
  final String id;
  final String label;
  final IconData icon;

  const _Category({
    required this.id,
    required this.label,
    required this.icon,
  });
}

const List<_Category> _kCategories = [
  _Category(id: 'Inicio', label: 'Inicio', icon: Icons.home_outlined),
  _Category(id: 'Sugeridas', label: 'Sugeridas', icon: Icons.star_outline),
  _Category(id: 'Comida', label: 'Comida', icon: Icons.restaurant_outlined),
  _Category(id: 'Acciones', label: 'Acciones', icon: Icons.directions_run),
  _Category(id: 'Gente', label: 'Gente', icon: Icons.people_outline),
  _Category(id: 'Lugares', label: 'Lugares', icon: Icons.place_outlined),
  _Category(id: 'Sentir', label: 'Sentir', icon: Icons.favorite_outline),
  _Category(id: 'Charla', label: 'Charla', icon: Icons.chat_bubble_outline),
  _Category(id: 'Necesidades', label: 'Necesidades', icon: Icons.volunteer_activism_outlined),
  _Category(id: 'Objetos', label: 'Objetos', icon: Icons.category_outlined),
  _Category(id: 'Rutinas', label: 'Rutinas', icon: Icons.schedule_outlined),
  _Category(id: 'Cuerpo', label: 'Cuerpo', icon: Icons.accessibility_new_outlined),
];

// ---------------------------------------------------------------------------
// CategoryTabs
// ---------------------------------------------------------------------------

class CategoryTabs extends ConsumerWidget {
  final VoidCallback? onSearchTap;

  const CategoryTabs({super.key, this.onSearchTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeCategoryProvider);
    final notifier = ref.read(activeCategoryProvider.notifier);

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Scrollable category tabs
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              itemCount: _kCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final cat = _kCategories[index];
                final isSelected = cat.id == active;
                return _CategoryTab(
                  category: cat,
                  isSelected: isSelected,
                  onTap: () => notifier.state = cat.id,
                );
              },
            ),
          ),

          // Divider before search
          Container(
            width: 1,
            height: 32,
            color: AppColors.divider,
          ),

          // Search tab
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _SearchTab(
              isActive: active == '_search',
              onTap: () {
                notifier.state = '_search';
                onSearchTap?.call();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual category tab
// ---------------------------------------------------------------------------

class _CategoryTab extends StatelessWidget {
  final _Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.inkTeal : AppColors.grey100,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: AppColors.divider, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 14,
              color: isSelected ? AppColors.white : AppColors.grey600,
            ),
            const SizedBox(width: 5),
            Text(
              category.label,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search icon tab
// ---------------------------------------------------------------------------

class _SearchTab extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _SearchTab({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.inkTeal.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.search,
          size: 20,
          color: isActive ? AppColors.inkTeal : AppColors.grey500,
        ),
      ),
    );
  }
}

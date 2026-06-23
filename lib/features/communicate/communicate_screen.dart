import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:habla/core/router/app_router.dart';
import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/core/theme/app_typography.dart';
import 'package:habla/state/providers/communicate_provider.dart';
import 'package:habla/state/providers/profile_provider.dart';
import 'package:habla/state/providers/board_provider.dart';
import 'package:habla/state/providers/settings_provider.dart';
import 'package:habla/features/communicate/widgets/message_bar.dart';
import 'package:habla/features/communicate/widgets/category_tabs.dart';
import 'package:habla/features/communicate/widgets/aac_grid.dart';

// ---------------------------------------------------------------------------
// CommunicateScreen
// ---------------------------------------------------------------------------

class CommunicateScreen extends ConsumerWidget {
  const CommunicateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileDataProvider);
    final gridSize = ref.watch(currentGridSizeProvider);
    final disposition = ref.watch(currentDispositionProvider);
    final vocabulary = ref.watch(vocabularyForActiveBoardProvider);
    final settings = ref.watch(appSettingsProvider);
    final messageBar = ref.read(messageBarProvider.notifier);

    // Filter vocabulary by active category
    final activeCategory = ref.watch(activeCategoryProvider);
    final filteredVocab = _filterVocab(vocabulary, activeCategory);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _CommunicateAppBar(
        profileName: profile?.name ?? 'Habla',
        gridSize: gridSize,
        disposition: disposition,
        onGridSizeChanged: (size) {
          ref.read(currentGridSizeProvider.notifier).state = size;
        },
        onDispositionChanged: (d) {
          ref.read(currentDispositionProvider.notifier).state = d;
        },
      ),
      body: Column(
        children: [
          // Message bar
          const MessageBar(),

          // Category tabs
          CategoryTabs(
            onSearchTap: () => context.push(AppRoutes.communicateSearch),
          ),

          // Vocabulary grid or disposition stub
          Expanded(
            child: _DispositionView(
              disposition: disposition,
              vocabulary: filteredVocab,
              gridSize: gridSize,
              onTap: (item) {
                // Add word to message bar
                messageBar.addWord(item.label);
                // Auditory feedback: speak word immediately if setting enabled
                if (settings.auditoryFeedback) {
                  messageBar.speakWord(item.label);
                }
                // Increment usage
                ref
                    .read(vocabularyForActiveBoardProvider.notifier)
                    .incrementUsage(item.id);
              },
              onLongPress: (item) =>
                  _showItemContextMenu(context, ref, item),
            ),
          ),
        ],
      ),
    );
  }

  List<VocabularyItemEntity> _filterVocab(
    List<VocabularyItemEntity> vocab,
    String? activeCategory,
  ) {
    if (activeCategory == null || activeCategory == 'Inicio') return vocab;
    if (activeCategory == 'Sugeridas') {
      return vocab.where((v) => v.isFavorite).toList();
    }
    if (activeCategory == '_search') return vocab;

    // Map Spanish tab labels to JSON category IDs (English)
    const tabToCategory = {
      'Comida':      'food',
      'Acciones':    'actions',
      'Gente':       'people',
      'Lugares':     'places',
      'Sentir':      'feelings',
      'Charla':      'chat',
      'Necesidades': 'needs',
      'Objetos':     'objects',
      'Rutinas':     'routines',
      'Cuerpo':      'body',
    };
    final target = tabToCategory[activeCategory];
    if (target == null) return vocab;
    return vocab.where((v) => v.category == target).toList();
  }

  void _showItemContextMenu(
    BuildContext context,
    WidgetRef ref,
    VocabularyItemEntity item,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _ItemContextMenu(
        item: item,
        onToggleFavorite: () {
          ref
              .read(vocabularyForActiveBoardProvider.notifier)
              .toggleFavorite(item.id);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AppBar
// ---------------------------------------------------------------------------

class _CommunicateAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String profileName;
  final int gridSize;
  final String disposition;
  final ValueChanged<int> onGridSizeChanged;
  final ValueChanged<String> onDispositionChanged;

  static const List<int> _gridSizes = [4, 8, 15, 30, 60, 90];

  const _CommunicateAppBar({
    required this.profileName,
    required this.gridSize,
    required this.disposition,
    required this.onGridSizeChanged,
    required this.onDispositionChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          // Profile icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.inkTeal.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              size: 18,
              color: AppColors.inkTeal,
            ),
          ),
          const SizedBox(width: 8),
          // Profile name
          Flexible(
            child: Text(
              profileName,
              style: AppTypography.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        // Grid size selector
        _GridSizeDropdown(
          value: gridSize,
          options: _gridSizes,
          onChanged: onGridSizeChanged,
        ),
        const SizedBox(width: 4),

        // Disposition switcher
        _DispositionSwitcher(
          current: disposition,
          onChanged: onDispositionChanged,
        ),
        const SizedBox(width: 4),

        // Settings button
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Configuración',
          onPressed: () => context.push(AppRoutes.settings),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Grid size dropdown
// ---------------------------------------------------------------------------

class _GridSizeDropdown extends StatelessWidget {
  final int value;
  final List<int> options;
  final ValueChanged<int> onChanged;

  const _GridSizeDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isDense: true,
          style: AppTypography.textTheme.labelMedium?.copyWith(
            color: AppColors.inkTeal,
            fontWeight: FontWeight.w600,
          ),
          icon: const Icon(Icons.expand_more, size: 16, color: AppColors.inkTeal),
          items: options
              .map(
                (s) => DropdownMenuItem<int>(
                  value: s,
                  child: Text('$s botones'),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Disposition switcher (3 icon toggle)
// ---------------------------------------------------------------------------

class _DispositionSwitcher extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;

  const _DispositionSwitcher({
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DispositionBtn(
            icon: Icons.grid_view_rounded,
            tooltip: 'Pictogramas',
            isActive: current == 'pictograms',
            isFirst: true,
            onTap: () => onChanged('pictograms'),
          ),
          _DispositionBtn(
            icon: Icons.image_outlined,
            tooltip: 'Escena visual',
            isActive: current == 'visual_scene',
            onTap: () => onChanged('visual_scene'),
          ),
          _DispositionBtn(
            icon: Icons.keyboard_outlined,
            tooltip: 'Teclado',
            isActive: current == 'keyboard',
            isLast: true,
            onTap: () => onChanged('keyboard'),
          ),
        ],
      ),
    );
  }
}

class _DispositionBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _DispositionBtn({
    required this.icon,
    required this.tooltip,
    required this.isActive,
    this.isFirst = false,
    this.isLast = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.inkTeal
                : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: isFirst ? const Radius.circular(7) : Radius.zero,
              right: isLast ? const Radius.circular(7) : Radius.zero,
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isActive ? AppColors.white : AppColors.grey500,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Disposition view router
// ---------------------------------------------------------------------------

class _DispositionView extends StatelessWidget {
  final String disposition;
  final List<VocabularyItemEntity> vocabulary;
  final int gridSize;
  final void Function(VocabularyItemEntity) onTap;
  final void Function(VocabularyItemEntity)? onLongPress;

  const _DispositionView({
    required this.disposition,
    required this.vocabulary,
    required this.gridSize,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    switch (disposition) {
      case 'visual_scene':
        return const _ComingSoonOverlay(label: 'Escena Visual');
      case 'keyboard':
        return const _ComingSoonOverlay(label: 'Teclado con predicción');
      default:
        return AacGrid(
          items: vocabulary,
          gridSize: gridSize,
          onTap: onTap,
          onLongPress: onLongPress,
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Coming Soon overlay stub
// ---------------------------------------------------------------------------

class _ComingSoonOverlay extends StatelessWidget {
  final String label;

  const _ComingSoonOverlay({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.aiVioletLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.aiViolet.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome,
                    color: AppColors.aiViolet, size: 20),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'BricolageGrotesque',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.aiViolet,
                      ),
                    ),
                    const Text(
                      'Próximamente',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.aiViolet,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Item context menu (long press bottom sheet)
// ---------------------------------------------------------------------------

class _ItemContextMenu extends StatelessWidget {
  final VocabularyItemEntity item;
  final VoidCallback onToggleFavorite;

  const _ItemContextMenu({
    required this.item,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              item.isFavorite ? Icons.star : Icons.star_outline,
              color: item.isFavorite ? Colors.amber : AppColors.grey600,
            ),
            title: Text(
              item.isFavorite ? 'Quitar de favoritos' : 'Añadir a favoritos',
            ),
            onTap: onToggleFavorite,
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: AppColors.grey600),
            title: const Text('Editar símbolo'),
            onTap: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Editor de símbolos — próximamente')),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

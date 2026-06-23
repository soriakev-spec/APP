import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/core/theme/app_typography.dart';
import 'package:habla/core/theme/fitzgerald.dart';
import 'package:habla/state/providers/board_provider.dart';
import 'package:habla/state/providers/communicate_provider.dart';
import 'package:habla/state/providers/settings_provider.dart';
import 'package:habla/widgets/aac_button/aac_button.dart';

// ---------------------------------------------------------------------------
// VocabularySearchScreen
// ---------------------------------------------------------------------------

class VocabularySearchScreen extends ConsumerStatefulWidget {
  const VocabularySearchScreen({super.key});

  @override
  ConsumerState<VocabularySearchScreen> createState() =>
      _VocabularySearchScreenState();
}

class _VocabularySearchScreenState
    extends ConsumerState<VocabularySearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  FitzgeraldCategory? _fitzFilter;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text != _query) {
        setState(() => _query = _controller.text);
        ref.read(searchQueryProvider.notifier).state = _controller.text;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<VocabularyItemEntity> _applyFilters(
      List<VocabularyItemEntity> all) {
    var result = all;

    // Text filter
    if (_query.isNotEmpty) {
      final lower = _query.toLowerCase();
      result = result
          .where((v) =>
              v.label.toLowerCase().contains(lower) ||
              v.message.toLowerCase().contains(lower) ||
              v.category.toLowerCase().contains(lower))
          .toList();
    }

    // Fitzgerald filter
    if (_fitzFilter != null) {
      final catString = _fitzFilter!.name;
      result = result
          .where((v) =>
              v.fitzgerald.toLowerCase() == catString.toLowerCase())
          .toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final vocabulary = ref.watch(vocabularyForActiveBoardProvider);
    final settings = ref.watch(appSettingsProvider);
    final messageBar = ref.read(messageBarProvider.notifier);
    final filtered = _applyFilters(vocabulary);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _SearchBar(controller: _controller),
        actions: [
          if (_query.isNotEmpty || _fitzFilter != null)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Borrar filtros',
              onPressed: () {
                _controller.clear();
                setState(() {
                  _query = '';
                  _fitzFilter = null;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Fitzgerald category filter chips
          _FitzFilterRow(
            selected: _fitzFilter,
            onSelect: (cat) =>
                setState(() => _fitzFilter = _fitzFilter == cat ? null : cat),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Text(
                  '${filtered.length} resultado${filtered.length == 1 ? '' : 's'}',
                  style: AppTypography.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Grid results
          Expanded(
            child: filtered.isEmpty
                ? const _EmptySearchState()
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return AacButton(
                        key: ValueKey(item.id),
                        item: item,
                        onTap: () {
                          messageBar.addWord(item.label);
                          if (settings.auditoryFeedback) {
                            messageBar.speakWord(item.label);
                          }
                          ref
                              .read(vocabularyForActiveBoardProvider.notifier)
                              .incrementUsage(item.id);
                          Navigator.of(context).pop();
                        },
                        onLongPress: () {
                          ref
                              .read(vocabularyForActiveBoardProvider.notifier)
                              .toggleFavorite(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                item.isFavorite
                                    ? 'Eliminado de favoritos'
                                    : 'Añadido a favoritos',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search input
// ---------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Buscar símbolos...',
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: AppColors.grey100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.inkTeal, width: 1.5),
        ),
      ),
      style: AppTypography.textTheme.bodyLarge,
      textInputAction: TextInputAction.search,
    );
  }
}

// ---------------------------------------------------------------------------
// Fitzgerald filter chips row
// ---------------------------------------------------------------------------

class _FitzFilterRow extends StatelessWidget {
  final FitzgeraldCategory? selected;
  final ValueChanged<FitzgeraldCategory> onSelect;

  const _FitzFilterRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: FitzgeraldCategory.values.map((cat) {
          final isSelected = selected == cat;
          final color = FitzgeraldHelper.colorForCategory(cat);
          final label = FitzgeraldHelper.labelForCategory(
            cat,
            const Locale('es'),
          );
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onSelect(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.2)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? color
                        : AppColors.divider,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? color : AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 56, color: AppColors.grey300),
          const SizedBox(height: 16),
          const Text(
            'Sin resultados',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Prueba con otra búsqueda o cambia los filtros',
            style: TextStyle(fontSize: 13, color: AppColors.grey400),
          ),
        ],
      ),
    );
  }
}

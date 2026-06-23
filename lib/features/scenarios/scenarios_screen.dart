import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:habla/core/router/app_router.dart';
import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/core/theme/app_typography.dart';
import 'package:habla/state/providers/scenarios_provider.dart';

// ---------------------------------------------------------------------------
// ScenariosScreen
// ---------------------------------------------------------------------------

class ScenariosScreen extends ConsumerStatefulWidget {
  const ScenariosScreen({super.key});

  @override
  ConsumerState<ScenariosScreen> createState() => _ScenariosScreenState();
}

class _ScenariosScreenState extends ConsumerState<ScenariosScreen> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final asyncScenarios = ref.watch(scenariosProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Text(
          'Escenarios de Comunicación',
          style: AppTypography.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: asyncScenarios.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AppColors.grey400),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar escenarios',
                  style: AppTypography.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: const TextStyle(color: AppColors.grey500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        data: (scenarios) {
          final filtered = _selectedCategory == null
              ? scenarios
              : scenarios
                  .where((s) => s.category == _selectedCategory)
                  .toList();

          return Column(
            children: [
              _CategoryFilterBar(
                selected: _selectedCategory,
                onSelect: (cat) => setState(() {
                  _selectedCategory = _selectedCategory == cat ? null : cat;
                }),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          'Sin escenarios en esta categoría',
                          style: const TextStyle(color: AppColors.grey500),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.05,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final s = filtered[i];
                          return _ScenarioCard(
                            scenario: s,
                            onTap: () => context
                                .push(AppRoutes.scenarioDetailPath(s.id)),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category filter bar
// ---------------------------------------------------------------------------

class _CategoryFilterBar extends StatelessWidget {
  final String? selected;
  final void Function(String) onSelect;

  const _CategoryFilterBar({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final entries = scenarioCategoryMeta.entries.toList();
    return Container(
      color: AppColors.white,
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = entries[i].key;
          final meta = entries[i].value;
          final isSelected = selected == cat;
          return FilterChip(
            selected: isSelected,
            label: Text(meta.$1),
            avatar: Icon(
              meta.$2,
              size: 15,
              color: isSelected ? Colors.white : meta.$3,
            ),
            backgroundColor: AppColors.grey100,
            selectedColor: meta.$3,
            showCheckmark: false,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.grey800,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected ? meta.$3 : AppColors.border,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            onSelected: (_) => onSelect(cat),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scenario card
// ---------------------------------------------------------------------------

class _ScenarioCard extends StatelessWidget {
  final ScenarioEntity scenario;
  final VoidCallback onTap;

  const _ScenarioCard({required this.scenario, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final meta = scenarioCategoryMeta[scenario.category] ??
        ('?', Icons.help_outline, AppColors.grey500);
    final color = meta.$3;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colored header with category icon
            Container(
              height: 76,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Center(
                child: Icon(meta.$2, size: 40, color: color),
              ),
            ),
            // Title and phrase count
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      scenario.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkTeal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 11, color: color),
                        const SizedBox(width: 4),
                        Text(
                          '${scenario.totalPhrases} frases',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

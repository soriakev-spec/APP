import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/state/providers/communicate_provider.dart';
import 'package:habla/state/providers/scenarios_provider.dart';

// ---------------------------------------------------------------------------
// ScenarioDetailScreen — entry point from router
// ---------------------------------------------------------------------------

class ScenarioDetailScreen extends ConsumerWidget {
  final String scenarioId;

  const ScenarioDetailScreen({required this.scenarioId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncScenarios = ref.watch(scenariosProvider);

    return asyncScenarios.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Escenario')),
        body: Center(child: Text('Error: $e')),
      ),
      data: (scenarios) {
        final matches = scenarios.where((s) => s.id == scenarioId);
        final scenario = matches.isEmpty ? null : matches.first;
        if (scenario == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Escenario')),
            body: const Center(child: Text('Escenario no encontrado')),
          );
        }
        return _ScenarioDetailView(scenario: scenario);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Detail view with section tabs
// ---------------------------------------------------------------------------

class _ScenarioDetailView extends ConsumerStatefulWidget {
  final ScenarioEntity scenario;

  const _ScenarioDetailView({required this.scenario});

  @override
  ConsumerState<_ScenarioDetailView> createState() =>
      _ScenarioDetailViewState();
}

class _ScenarioDetailViewState extends ConsumerState<_ScenarioDetailView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<String> _sectionKeys;

  @override
  void initState() {
    super.initState();
    _sectionKeys = widget.scenario.sections.keys.toList();
    _tabController = TabController(length: _sectionKeys.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catMeta = scenarioCategoryMeta[widget.scenario.category] ??
        ('?', Icons.help_outline, AppColors.grey500);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.inkTeal),
        title: Row(
          children: [
            Icon(catMeta.$2, color: catMeta.$3, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.scenario.title,
                style: const TextStyle(
                  color: AppColors.inkTeal,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.inkTeal,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.inkTeal,
          tabAlignment: TabAlignment.start,
          tabs: _sectionKeys.map((key) {
            final m = scenarioSectionMeta[key] ??
                (key, Icons.list, AppColors.grey500);
            return Tab(
              height: 48,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(m.$2, size: 14, color: m.$3),
                  const SizedBox(width: 4),
                  Text(m.$1, style: const TextStyle(fontSize: 12)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _sectionKeys.map((key) {
          final phrases = widget.scenario.sections[key] ?? [];
          final m = scenarioSectionMeta[key] ??
              (key, Icons.list, AppColors.grey500);
          return _PhraseList(
            phrases: phrases,
            accentColor: m.$3,
            onSpeak: (phrase) => ref.read(ttsEngineProvider).speak(phrase),
            onAddToBar: (phrase) =>
                ref.read(messageBarProvider.notifier).addWord(phrase),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Phrase list for each section tab
// ---------------------------------------------------------------------------

class _PhraseList extends StatelessWidget {
  final List<String> phrases;
  final Color accentColor;
  final void Function(String) onSpeak;
  final void Function(String) onAddToBar;

  const _PhraseList({
    required this.phrases,
    required this.accentColor,
    required this.onSpeak,
    required this.onAddToBar,
  });

  @override
  Widget build(BuildContext context) {
    if (phrases.isEmpty) {
      return const Center(
        child: Text(
          'Sin frases en esta sección',
          style: TextStyle(color: AppColors.grey500),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: phrases.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final phrase = phrases[i];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(
              phrase,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.inkTeal,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: 'Añadir al mensaje',
                  child: IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.grey600,
                    onPressed: () => onAddToBar(phrase),
                  ),
                ),
                Tooltip(
                  message: 'Escuchar',
                  child: IconButton(
                    icon: const Icon(Icons.volume_up),
                    color: accentColor,
                    onPressed: () => onSpeak(phrase),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

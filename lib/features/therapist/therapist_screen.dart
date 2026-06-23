import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/state/providers/profile_provider.dart';
import 'package:habla/widgets/dialogs/confirm_dialog.dart';
import 'package:habla/widgets/dialogs/input_dialog.dart';

// ---------------------------------------------------------------------------
// Dummy data models
// ---------------------------------------------------------------------------

class _Goal {
  _Goal({
    required this.id,
    required this.title,
    required this.progress,
    required this.target,
    required this.current,
  });

  final String id;
  final String title;
  final double progress;
  final int target;
  final int current;
}

class _Recommendation {
  _Recommendation({
    required this.id,
    required this.text,
    this.applied = false,
    this.discarded = false,
  });

  final String id;
  final String text;
  final bool applied;
  final bool discarded;
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class _TherapistState {
  const _TherapistState({
    required this.goals,
    required this.recommendations,
    required this.dateRangeLabel,
  });

  final List<_Goal> goals;
  final List<_Recommendation> recommendations;
  final String dateRangeLabel;

  _TherapistState copyWith({
    List<_Goal>? goals,
    List<_Recommendation>? recommendations,
    String? dateRangeLabel,
  }) {
    return _TherapistState(
      goals: goals ?? this.goals,
      recommendations: recommendations ?? this.recommendations,
      dateRangeLabel: dateRangeLabel ?? this.dateRangeLabel,
    );
  }
}

class _TherapistNotifier extends StateNotifier<_TherapistState> {
  _TherapistNotifier()
      : super(const _TherapistState(
          dateRangeLabel: 'Últimas 4 semanas',
          goals: [],
          recommendations: [],
        )) {
    state = _TherapistState(
      dateRangeLabel: 'Últimas 4 semanas',
      goals: [
        _Goal(id: '1', title: 'Usar 50 palabras nuevas', progress: 0.72, target: 50, current: 36),
        _Goal(id: '2', title: 'Comunicar en 5 sesiones', progress: 0.60, target: 5, current: 3),
        _Goal(id: '3', title: 'Frases de 2+ palabras', progress: 0.45, target: 20, current: 9),
        _Goal(id: '4', title: 'Rutinas completadas', progress: 0.90, target: 10, current: 9),
      ],
      recommendations: [
        _Recommendation(
          id: 'r1',
          text: 'Introducir vocabulario de emociones: "feliz", "triste", "enojado". El perfil usa principalmente sustantivos.',
        ),
        _Recommendation(
          id: 'r2',
          text: 'Aumentar el tiempo de espera a 5 segundos. El patrón de uso indica que el usuario necesita más tiempo para seleccionar.',
        ),
        _Recommendation(
          id: 'r3',
          text: 'Agregar tablero de "Comida favorita". 80% de las comunicaciones del mediodía no tienen contexto de comida.',
        ),
      ],
    );
  }

  void applyRecommendation(String id) {
    final updated = state.recommendations.map((r) {
      if (r.id == id) return _Recommendation(id: r.id, text: r.text, applied: true);
      return r;
    }).toList();
    state = state.copyWith(recommendations: updated);
  }

  void discardRecommendation(String id) {
    final updated = state.recommendations.map((r) {
      if (r.id == id) return _Recommendation(id: r.id, text: r.text, discarded: true);
      return r;
    }).toList();
    state = state.copyWith(recommendations: updated);
  }

  void updateGoalTitle(String id, String newTitle) {
    final updated = state.goals.map((g) {
      if (g.id == id) {
        return _Goal(id: g.id, title: newTitle, progress: g.progress, target: g.target, current: g.current);
      }
      return g;
    }).toList();
    state = state.copyWith(goals: updated);
  }

  void deleteGoal(String id) {
    final updated = state.goals.where((g) => g.id != id).toList();
    state = state.copyWith(goals: updated);
  }

  void setDateRange(String label) {
    state = state.copyWith(dateRangeLabel: label);
  }
}

final _therapistProvider =
    StateNotifierProvider<_TherapistNotifier, _TherapistState>(
  (_) => _TherapistNotifier(),
);

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class TherapistScreen extends ConsumerWidget {
  const TherapistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileDataProvider);
    final state = ref.watch(_therapistProvider);
    final notifier = ref.read(_therapistProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _Header(
              profileName: profile?.name ?? 'Perfil',
              dateRangeLabel: state.dateRangeLabel,
              onDateRangeChanged: notifier.setDateRange,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _KpiRow(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gráficas',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _VocabularyLineChart()),
                      const SizedBox(width: 12),
                      Expanded(child: _DailyUsageBarChart()),
                      const SizedBox(width: 12),
                      Expanded(child: _VocabularyDonutChart()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Metas',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => InputDialog(
                              title: 'Nueva meta',
                              hint: 'Describe la meta...',
                              confirmLabel: 'Agregar',
                              onConfirm: (value) {},
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Nueva meta'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...state.goals.map((goal) => _GoalCard(
                        goal: goal,
                        onEdit: () => showDialog(
                          context: context,
                          builder: (_) => InputDialog(
                            title: 'Editar meta',
                            initialValue: goal.title,
                            confirmLabel: 'Guardar',
                            onConfirm: (value) => notifier.updateGoalTitle(goal.id, value),
                          ),
                        ),
                        onDelete: () => showDialog(
                          context: context,
                          builder: (_) => ConfirmDialog(
                            title: 'Eliminar meta',
                            message: '¿Eliminar "${goal.title}"? Esta acción no se puede deshacer.',
                            confirmLabel: 'Eliminar',
                            confirmColor: AppColors.error,
                            onConfirm: () => notifier.deleteGoal(goal.id),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.aiViolet),
                      const SizedBox(width: 6),
                      Text('Recomendaciones IA',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...state.recommendations
                      .where((r) => !r.applied && !r.discarded)
                      .map((r) => _RecommendationCard(
                            recommendation: r,
                            onApply: () => showDialog(
                              context: context,
                              builder: (_) => ConfirmDialog(
                                title: 'Aplicar recomendación',
                                message: '¿Deseas aplicar esta recomendación de IA?',
                                confirmLabel: 'Aplicar',
                                onConfirm: () => notifier.applyRecommendation(r.id),
                              ),
                            ),
                            onDiscard: () => notifier.discardRecommendation(r.id),
                          )),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              child: ElevatedButton.icon(
                onPressed: () => context.go('/reports'),
                icon: const Icon(Icons.description_rounded),
                label: const Text('Exportar reporte completo'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.profileName,
    required this.dateRangeLabel,
    required this.onDateRangeChanged,
  });

  final String profileName;
  final String dateRangeLabel;
  final void Function(String) onDateRangeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const ranges = [
      'Última semana',
      'Últimas 2 semanas',
      'Últimas 4 semanas',
      'Últimos 3 meses',
    ];

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Panel del Terapeuta',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkTeal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Perfil: $profileName',
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey600),
              ),
            ],
          ),
          const Spacer(),
          DropdownButton<String>(
            value: dateRangeLabel,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(10),
            items: ranges.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
            onChanged: (v) {
              if (v != null) onDateRangeChanged(v);
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// KPI row
// ---------------------------------------------------------------------------

class _KpiRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            label: 'Total palabras',
            value: '1,248',
            icon: Icons.record_voice_over_rounded,
            color: AppColors.inkTeal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            label: 'Sesiones esta semana',
            value: '7',
            icon: Icons.calendar_today_rounded,
            color: AppColors.fitzVerbs,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            label: 'Palabras nuevas',
            value: '36',
            icon: Icons.star_rounded,
            color: AppColors.fitzNouns,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiProgressCard(
            label: 'Metas cumplidas',
            fraction: 0.75,
            subtitle: '3 de 4 metas',
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkTeal,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiProgressCard extends StatelessWidget {
  const _KpiProgressCard({
    required this.label,
    required this.fraction,
    required this.subtitle,
  });

  final String label;
  final double fraction;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flag_rounded, size: 22, color: AppColors.aiViolet),
                const Spacer(),
                Text(
                  '${(fraction * 100).round()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.aiViolet,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 6,
                backgroundColor: AppColors.aiVioletLight,
                valueColor: const AlwaysStoppedAnimation(AppColors.aiViolet),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkTeal,
                  ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vocabulary growth line chart
// ---------------------------------------------------------------------------

class _VocabularyLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const spots = [
      FlSpot(0, 820),
      FlSpot(1, 940),
      FlSpot(2, 1050),
      FlSpot(3, 1248),
    ];
    const weekLabels = ['S-3', 'S-2', 'S-1', 'Hoy'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crecimiento vocabulario',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => const FlLine(
                      color: AppColors.divider,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (v, meta) => Text(
                          v.round().toString(),
                          style: const TextStyle(fontSize: 9, color: AppColors.grey500),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, meta) {
                          final idx = v.round();
                          if (idx < 0 || idx >= weekLabels.length) return const SizedBox();
                          return Text(
                            weekLabels[idx],
                            style: const TextStyle(fontSize: 10, color: AppColors.grey500),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppColors.inkTeal,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.inkTeal.withValues(alpha: 0.08),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: 3,
                  minY: 700,
                  maxY: 1400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Daily usage bar chart
// ---------------------------------------------------------------------------

class _DailyUsageBarChart extends StatefulWidget {
  @override
  State<_DailyUsageBarChart> createState() => _DailyUsageBarChartState();
}

class _DailyUsageBarChartState extends State<_DailyUsageBarChart> {
  int? _touchedIndex;

  final List<double> _data = [42, 78, 55, 90, 63, 88, 71];
  final List<String> _days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Uso diario (últimos 7 días)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${_data[groupIndex].round()} palabras',
                          const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                    touchCallback: (event, response) {
                      setState(() {
                        _touchedIndex =
                            response?.spot?.touchedBarGroupIndex;
                      });
                    },
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => const FlLine(
                      color: AppColors.divider,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (v, meta) => Text(
                          v.round().toString(),
                          style: const TextStyle(fontSize: 9, color: AppColors.grey500),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, meta) {
                          final idx = v.round();
                          if (idx < 0 || idx >= _days.length) return const SizedBox();
                          return Text(
                            _days[idx],
                            style: const TextStyle(fontSize: 11, color: AppColors.grey500),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(_data.length, (i) {
                    final isTouched = i == _touchedIndex;
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: _data[i],
                          color: isTouched ? AppColors.fitzNouns : AppColors.inkTeal,
                          width: 18,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }),
                  maxY: 110,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Donut chart
// ---------------------------------------------------------------------------

class _VocabularyDonutChart extends StatefulWidget {
  @override
  State<_VocabularyDonutChart> createState() => _VocabularyDonutChartState();
}

class _VocabularyDonutChartState extends State<_VocabularyDonutChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vocabulario central vs periférico',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            setState(() {
                              _touchedIndex = response
                                  ?.touchedSection?.touchedSectionIndex;
                            });
                          },
                        ),
                        sections: [
                          PieChartSectionData(
                            value: 68,
                            title: '68%',
                            color: AppColors.inkTeal,
                            radius: _touchedIndex == 0 ? 64 : 56,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: 32,
                            title: '32%',
                            color: AppColors.aiViolet,
                            radius: _touchedIndex == 1 ? 64 : 56,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        sectionsSpace: 3,
                        centerSpaceRadius: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _LegendDot(color: AppColors.inkTeal, label: 'Central'),
                      SizedBox(height: 8),
                      _LegendDot(color: AppColors.aiViolet, label: 'Periférico'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey700)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Goal card
// ---------------------------------------------------------------------------

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.onEdit,
    required this.onDelete,
  });

  final _Goal goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Color _progressColor(double v) {
    if (v >= 0.8) return AppColors.success;
    if (v >= 0.5) return AppColors.fitzNouns;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final pct = (goal.progress * 100).round();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  onPressed: onEdit,
                  visualDensity: VisualDensity.compact,
                  color: AppColors.grey500,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  onPressed: onDelete,
                  visualDensity: VisualDensity.compact,
                  color: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: goal.progress,
                      minHeight: 8,
                      backgroundColor: AppColors.grey200,
                      valueColor:
                          AlwaysStoppedAnimation(_progressColor(goal.progress)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$pct%  (${goal.current}/${goal.target})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey600,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recommendation card
// ---------------------------------------------------------------------------

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
    required this.onApply,
    required this.onDiscard,
  });

  final _Recommendation recommendation;
  final VoidCallback onApply;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.aiViolet,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'IA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(recommendation.text, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.aiViolet,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Aplicar'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onDiscard,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(80, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Descartar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

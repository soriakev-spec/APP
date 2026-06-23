import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/state/providers/profile_provider.dart';
import 'package:habla/widgets/dialogs/confirm_dialog.dart';

// ---------------------------------------------------------------------------
// Dummy data
// ---------------------------------------------------------------------------

class _PendingChange {
  const _PendingChange({required this.id, required this.title, required this.description});

  final String id;
  final String title;
  final String description;
}

class _FamilyState {
  const _FamilyState({
    required this.weeklyGoals,
    required this.pendingChanges,
  });

  final List<({String id, String label, bool done})> weeklyGoals;
  final List<_PendingChange> pendingChanges;

  _FamilyState copyWith({
    List<({String id, String label, bool done})>? weeklyGoals,
    List<_PendingChange>? pendingChanges,
  }) {
    return _FamilyState(
      weeklyGoals: weeklyGoals ?? this.weeklyGoals,
      pendingChanges: pendingChanges ?? this.pendingChanges,
    );
  }
}

class _FamilyNotifier extends StateNotifier<_FamilyState> {
  _FamilyNotifier()
      : super(const _FamilyState(
          weeklyGoals: [],
          pendingChanges: [],
        )) {
    state = _FamilyState(
      weeklyGoals: [
        (id: '1', label: 'Practicar rutina de mañana', done: true),
        (id: '2', label: 'Usar tablero de emociones', done: false),
        (id: '3', label: 'Actividad de vocabulario de colores', done: true),
        (id: '4', label: 'Historia social "En el supermercado"', done: false),
      ],
      pendingChanges: [
        const _PendingChange(
          id: 'c1',
          title: 'Nuevo tablero: Pasatiempos',
          description: 'IA sugiere agregar un tablero con vocabulario de pasatiempos basado en los patrones de comunicación de esta semana.',
        ),
        const _PendingChange(
          id: 'c2',
          title: 'Reorganizar tablero Principal',
          description: 'Mover las palabras más usadas a la primera fila para reducir el tiempo de acceso.',
        ),
      ],
    );
  }

  void toggleGoal(String id) {
    final updated = state.weeklyGoals.map((g) {
      if (g.id == id) return (id: g.id, label: g.label, done: !g.done);
      return g;
    }).toList();
    state = state.copyWith(weeklyGoals: updated);
  }

  void approveChange(String id) {
    final updated = state.pendingChanges.where((c) => c.id != id).toList();
    state = state.copyWith(pendingChanges: updated);
  }

  void rejectChange(String id) {
    final updated = state.pendingChanges.where((c) => c.id != id).toList();
    state = state.copyWith(pendingChanges: updated);
  }
}

final _familyProvider =
    StateNotifierProvider<_FamilyNotifier, _FamilyState>((_) => _FamilyNotifier());

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  static const _newWordsToday = ['agua', 'jugar', 'más', 'rojo', 'perro'];
  static const _newWordsWeek = ['feliz', 'grande', 'correr', 'libro', 'música', 'azul', 'comer'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileDataProvider);
    final state = ref.watch(_familyProvider);
    final notifier = ref.read(_familyProvider.notifier);
    final theme = Theme.of(context);
    final name = profile?.name ?? 'Tu familiar';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Centro Familiar',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.inkTeal,
                        ),
                      ),
                      Text(
                        'Seguimiento diario de $name',
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey600),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.family_restroom_rounded, color: AppColors.inkTeal, size: 32),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Today summary
                _TodaySummaryCard(name: name, wordsCount: 47),
                const SizedBox(height: 16),

                // Words learned today
                _SectionTitle(title: 'Qué aprendió hoy'),
                const SizedBox(height: 10),
                _WordChips(words: _newWordsToday, chipColor: AppColors.inkTeal),
                const SizedBox(height: 20),

                // Words this week
                _SectionTitle(title: 'Palabras nuevas esta semana'),
                const SizedBox(height: 10),
                _WordChips(words: _newWordsWeek, chipColor: AppColors.fitzVerbs),
                const SizedBox(height: 20),

                // Weekly goals
                _SectionTitle(title: 'Metas semanales'),
                const SizedBox(height: 10),
                Card(
                  child: Column(
                    children: state.weeklyGoals
                        .map((goal) => CheckboxListTile(
                              title: Text(goal.label),
                              value: goal.done,
                              activeColor: AppColors.inkTeal,
                              onChanged: (_) => notifier.toggleGoal(goal.id),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Automatic recommendations
                _SectionTitle(title: 'Recomendaciones automáticas'),
                const SizedBox(height: 10),
                _RecommendationCard(
                  icon: Icons.schedule_rounded,
                  color: AppColors.fitzNouns,
                  text: 'Practicar el tablero de rutinas por la tarde (15:00 - 16:00) según el horario configurado.',
                ),
                const SizedBox(height: 8),
                _RecommendationCard(
                  icon: Icons.auto_awesome_rounded,
                  color: AppColors.aiViolet,
                  text: 'Esta semana es buen momento para introducir vocabulario de sentimientos. El perfil usa muy pocas palabras emocionales.',
                ),
                const SizedBox(height: 20),

                // Pending changes
                if (state.pendingChanges.isNotEmpty) ...[
                  _SectionTitle(title: 'Cambios pendientes de aprobación'),
                  const SizedBox(height: 10),
                  ...state.pendingChanges.map((change) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PendingChangeCard(
                          change: change,
                          onApprove: () => showDialog(
                            context: context,
                            builder: (_) => ConfirmDialog(
                              title: 'Aprobar cambio',
                              message: '¿Confirmar "${change.title}"?',
                              confirmLabel: 'Aprobar',
                              onConfirm: () => notifier.approveChange(change.id),
                            ),
                          ),
                          onReject: () => showDialog(
                            context: context,
                            builder: (_) => ConfirmDialog(
                              title: 'Rechazar cambio',
                              message: '¿Rechazar "${change.title}"?',
                              confirmLabel: 'Rechazar',
                              confirmColor: AppColors.error,
                              onConfirm: () => notifier.rejectChange(change.id),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 20),
                ],

                // Notifications
                _SectionTitle(title: 'Notificaciones'),
                const SizedBox(height: 10),
                Card(
                  child: Column(
                    children: [
                      _NotificationTile(
                        icon: Icons.check_circle_rounded,
                        color: AppColors.success,
                        title: 'Meta completada',
                        subtitle: '$name completó la rutina de mañana',
                        time: 'Hace 2h',
                      ),
                      const Divider(height: 1),
                      _NotificationTile(
                        icon: Icons.emoji_events_rounded,
                        color: AppColors.fitzNouns,
                        title: 'Nuevo logro',
                        subtitle: 'Primera frase de 3 palabras: "quiero más leche"',
                        time: 'Ayer',
                      ),
                      const Divider(height: 1),
                      _NotificationTile(
                        icon: Icons.info_rounded,
                        color: AppColors.info,
                        title: 'Sesión programada',
                        subtitle: 'Sesión con la terapeuta mañana a las 10:00',
                        time: 'Hace 1 día',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Chat with therapist
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Chat con terapeuta'),
                        content: const Text('Esta función estará disponible próximamente. Permite comunicarte directamente con el terapeuta de manera segura.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_rounded),
                  label: const Text('Chat con terapeuta'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.inkTeal,
          ),
    );
  }
}

class _TodaySummaryCard extends StatelessWidget {
  const _TodaySummaryCard({required this.name, required this.wordsCount});

  final String name;
  final int wordsCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.inkTeal.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chat_bubble_rounded, color: AppColors.inkTeal, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen de hoy',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.grey600,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: 'Hoy $name comunicó ',
                          style: const TextStyle(color: AppColors.grey700),
                        ),
                        TextSpan(
                          text: '$wordsCount palabras',
                          style: const TextStyle(
                            color: AppColors.inkTeal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _StatBadge(label: '5 nuevas', color: AppColors.fitzVerbs),
                      const SizedBox(width: 8),
                      _StatBadge(label: '3 frases', color: AppColors.aiViolet),
                      const SizedBox(width: 8),
                      _StatBadge(label: '2 rutinas', color: AppColors.fitzNouns),
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

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _WordChips extends StatelessWidget {
  const _WordChips({required this.words, required this.chipColor});

  final List<String> words;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: words.map((word) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: chipColor.withValues(alpha: 0.1),
            border: Border.all(color: chipColor.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            word,
            style: TextStyle(color: chipColor, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        );
      }).toList(),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingChangeCard extends StatelessWidget {
  const _PendingChangeCard({
    required this.change,
    required this.onApprove,
    required this.onReject,
  });

  final _PendingChange change;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pending_rounded, color: AppColors.warning, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    change.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(change.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey600)),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Aprobar'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    foregroundColor: AppColors.error,
                    minimumSize: const Size(80, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Rechazar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: Text(time, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey500)),
    );
  }
}

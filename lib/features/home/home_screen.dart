import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:habla/core/router/app_router.dart';
import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/core/theme/app_typography.dart';
import 'package:habla/state/providers/profile_provider.dart';
import 'package:habla/state/providers/board_provider.dart';

// ---------------------------------------------------------------------------
// HomeScreen
// ---------------------------------------------------------------------------

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileDataProvider);
    
    final activeBoard = ref.watch(activeBoardForProfileProvider);
    final vocab = ref.watch(vocabularyForActiveBoardProvider);

    final name = profile?.name ?? 'Usuario';
    final recentWords =
        vocab.take(5).map((v) => v.label).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top spacing
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Greeting header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _GreetingHeader(greeting: _greeting(), name: name),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Practice streak card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _PracticeStreakCard(streakDays: 3),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Quick access grid (2×2)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acceso rápido',
                      style: AppTypography.textTheme.titleSmall?.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _QuickAccessGrid(),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // "Continúa donde quedaste" card
            if (activeBoard != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _ContinueCard(
                    boardName: activeBoard.name,
                    onTap: () => context.push(AppRoutes.communicate),
                  ),
                ),
              ),
            if (activeBoard != null)
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Weekly goals
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _WeeklyGoalsCard(
                  wordsUsed: vocab.length,
                  goal: 100,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Recent words
            if (recentWords.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _RecentWordsCard(words: recentWords),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Greeting header
// ---------------------------------------------------------------------------

class _GreetingHeader extends StatelessWidget {
  final String greeting;
  final String name;

  const _GreetingHeader({required this.greeting, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.textTheme.headlineMedium,
            children: [
              TextSpan(text: '$greeting, '),
              TextSpan(
                text: name,
                style: const TextStyle(
                  color: AppColors.inkTeal,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const TextSpan(text: '!'),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _dateString(),
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  String _dateString() {
    final now = DateTime.now();
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    const days = [
      'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'
    ];
    final weekday = days[now.weekday - 1];
    final month = months[now.month - 1];
    return '${weekday[0].toUpperCase()}${weekday.substring(1)}, ${now.day} de $month';
  }
}

// ---------------------------------------------------------------------------
// Practice streak card
// ---------------------------------------------------------------------------

class _PracticeStreakCard extends StatelessWidget {
  final int streakDays;

  const _PracticeStreakCard({required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.inkTeal, Color(0xFF1E5C56)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.orange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streakDays ${streakDays == 1 ? 'día' : 'días'} seguidos',
                  style: const TextStyle(
                    fontFamily: 'BricolageGrotesque',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Racha de práctica',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick access grid
// ---------------------------------------------------------------------------

class _QuickAccessGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _QuickCard(
          icon: Icons.record_voice_over_rounded,
          label: 'Comunicar',
          color: AppColors.inkTeal,
          onTap: () => context.push(AppRoutes.communicate),
        ),
        _QuickCard(
          icon: Icons.format_quote_rounded,
          label: 'Frases',
          color: AppColors.fitzVerbs,
          onTap: () => context.push(AppRoutes.phrases),
        ),
        _QuickCard(
          icon: Icons.star_rounded,
          label: 'Actividades',
          color: AppColors.fitzNouns,
          onTap: () => context.push(AppRoutes.activities),
        ),
        _QuickCard(
          icon: Icons.dashboard_rounded,
          label: 'Tableros',
          color: AppColors.fitzDescriptors,
          onTap: () => context.push(AppRoutes.boards),
        ),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Continue where you left off
// ---------------------------------------------------------------------------

class _ContinueCard extends StatelessWidget {
  final String boardName;
  final VoidCallback onTap;

  const _ContinueCard({required this.boardName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.aiVioletLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.aiViolet,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Continúa donde quedaste',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    boardName,
                    style: AppTypography.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Weekly goals
// ---------------------------------------------------------------------------

class _WeeklyGoalsCard extends StatelessWidget {
  final int wordsUsed;
  final int goal;

  const _WeeklyGoalsCard({required this.wordsUsed, required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = (wordsUsed / goal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flag_rounded,
                color: AppColors.inkTeal,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Metas semanales',
                style: AppTypography.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Communication goal
          _GoalRow(
            label: 'Palabras comunicadas',
            current: wordsUsed,
            goal: goal,
            progress: progress,
            color: AppColors.inkTeal,
          ),
          const SizedBox(height: 12),

          // Practice sessions stub
          _GoalRow(
            label: 'Sesiones de práctica',
            current: 3,
            goal: 5,
            progress: 0.6,
            color: AppColors.fitzVerbs,
          ),
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  final String label;
  final int current;
  final int goal;
  final double progress;
  final Color color;

  const _GoalRow({
    required this.label,
    required this.current,
    required this.goal,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.textTheme.bodyMedium),
            Text(
              '$current / $goal',
              style: AppTypography.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.grey200,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Recent words
// ---------------------------------------------------------------------------

class _RecentWordsCard extends StatelessWidget {
  final List<String> words;

  const _RecentWordsCard({required this.words});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: AppColors.grey600, size: 18),
              const SizedBox(width: 8),
              Text('Palabras usadas esta semana',
                  style: AppTypography.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: words
                .map(
                  (w) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.inkTeal.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.inkTeal.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      w,
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/core/theme/app_typography.dart';
import 'package:habla/state/providers/communicate_provider.dart';
import 'package:habla/features/communicate/widgets/message_history_dialog.dart';

// ---------------------------------------------------------------------------
// MessageBar
// ---------------------------------------------------------------------------

class MessageBar extends ConsumerWidget {
  const MessageBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(messageBarProvider);
    final notifier = ref.read(messageBarProvider.notifier);

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ---- Scrollable word chips ----
          Expanded(
            child: state.words.isEmpty
                ? const _PlaceholderText()
                : _WordChipList(
                    words: state.words,
                    onDeleteWord: (i) {
                      final updated = List<String>.from(state.words)
                        ..removeAt(i);
                      // Rebuild state with new word list via addWord trick:
                      notifier.clearAll();
                      for (final w in updated) {
                        notifier.addWord(w);
                      }
                    },
                  ),
          ),

          // ---- Divider ----
          Container(
            width: 1,
            height: 40,
            color: AppColors.divider,
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),

          // ---- Fixed action buttons ----
          _ActionButtons(
            hasWords: state.words.isNotEmpty,
            isAiExpanding: state.isExpanded,
            onSpeak: () => notifier.speak(),
            onBackspace: notifier.removeLastWord,
            onClear: notifier.clearAll,
            onAiExpand: () => notifier.expandWithAi(),
            onGrammar: () {
              notifier.applyGrammar();
            },
            onFavorites: () => notifier.addToFavorites(),
            onHistory: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => const MessageHistoryDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Placeholder
// ---------------------------------------------------------------------------

class _PlaceholderText extends StatelessWidget {
  const _PlaceholderText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Toca los símbolos para comunicar...',
        style: AppTextStyles.outputBarCompact.copyWith(
          color: AppColors.grey400,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Word chip list
// ---------------------------------------------------------------------------

class _WordChipList extends StatelessWidget {
  final List<String> words;
  final void Function(int) onDeleteWord;

  const _WordChipList({
    required this.words,
    required this.onDeleteWord,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: words.length,
      separatorBuilder: (_, __) => const SizedBox(width: 6),
      itemBuilder: (context, index) {
        return _WordChip(
          word: words[index],
          onDelete: () => onDeleteWord(index),
        );
      },
    );
  }
}

class _WordChip extends StatelessWidget {
  final String word;
  final VoidCallback onDelete;

  const _WordChip({required this.word, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.inkTeal.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.inkTeal.withValues(alpha: 0.25),
          ),
        ),
        child: Text(
          word,
          style: AppTextStyles.outputBarCompact.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action buttons strip
// ---------------------------------------------------------------------------

class _ActionButtons extends StatelessWidget {
  final bool hasWords;
  final bool isAiExpanding;
  final VoidCallback onSpeak;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onAiExpand;
  final VoidCallback onGrammar;
  final VoidCallback onFavorites;
  final VoidCallback onHistory;

  const _ActionButtons({
    required this.hasWords,
    required this.isAiExpanding,
    required this.onSpeak,
    required this.onBackspace,
    required this.onClear,
    required this.onAiExpand,
    required this.onGrammar,
    required this.onFavorites,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SpeakButton(enabled: hasWords, onTap: onSpeak),
          const SizedBox(width: 2),
          _BarIconButton(
            icon: Icons.backspace_outlined,
            tooltip: 'Borrar última',
            enabled: hasWords,
            onTap: onBackspace,
          ),
          _BarIconButton(
            icon: Icons.clear,
            tooltip: 'Borrar todo',
            enabled: hasWords,
            onTap: onClear,
          ),
          _AiExpandButton(
            isLoading: isAiExpanding,
            enabled: hasWords,
            onTap: onAiExpand,
          ),
          _BarIconButton(
            icon: Icons.spellcheck,
            tooltip: 'Gramática',
            enabled: hasWords,
            onTap: onGrammar,
          ),
          _BarIconButton(
            icon: Icons.star_outline,
            tooltip: 'Guardar en favoritos',
            onTap: onFavorites,
          ),
          _BarIconButton(
            icon: Icons.history,
            tooltip: 'Historial',
            onTap: onHistory,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Speak button (large, teal)
// ---------------------------------------------------------------------------

class _SpeakButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _SpeakButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: enabled ? AppColors.inkTeal : AppColors.grey300,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: Icon(
              Icons.volume_up_rounded,
              color: enabled ? AppColors.white : AppColors.grey500,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AI expand button (violet)
// ---------------------------------------------------------------------------

class _AiExpandButton extends StatelessWidget {
  final bool isLoading;
  final bool enabled;
  final VoidCallback onTap;

  const _AiExpandButton({
    required this.isLoading,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: enabled
            ? AppColors.aiViolet.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: (enabled && !isLoading) ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.aiViolet,
                    ),
                  )
                : Icon(
                    Icons.auto_awesome,
                    size: 18,
                    color: enabled
                        ? AppColors.aiViolet
                        : AppColors.grey400,
                  ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Generic icon button for the bar
// ---------------------------------------------------------------------------

class _BarIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool enabled;
  final VoidCallback onTap;

  const _BarIconButton({
    required this.icon,
    required this.tooltip,
    this.enabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon),
        iconSize: 20,
        color: enabled ? AppColors.inkTeal : AppColors.grey400,
        onPressed: enabled ? onTap : null,
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
      ),
    );
  }
}

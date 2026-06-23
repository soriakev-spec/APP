import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/state/providers/communicate_provider.dart';

// ---------------------------------------------------------------------------
// MessageHistoryDialog — draggable bottom sheet
// ---------------------------------------------------------------------------

class MessageHistoryDialog extends ConsumerWidget {
  const MessageHistoryDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(messageHistoryProvider);
    final historyNotifier = ref.read(messageHistoryProvider.notifier);
    final ttsEngine = ref.read(ttsEngineProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.88,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Drag handle
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

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.history_rounded,
                    color: AppColors.inkTeal,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Historial de mensajes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  if (history.isNotEmpty)
                    TextButton.icon(
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('Borrar todo'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        historyNotifier.clearAll();
                        Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 16),

            // List or empty state
            Expanded(
              child: history.isEmpty
                  ? const _EmptyState()
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final entry = history[index];
                        return _HistoryEntryTile(
                          entry: entry,
                          onSpeak: () => ttsEngine.speak(entry.text),
                          onCopy: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copiado: ${entry.text}'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Single history entry tile
// ---------------------------------------------------------------------------

class _HistoryEntryTile extends StatelessWidget {
  final MessageHistoryEntry entry;
  final VoidCallback onSpeak;
  final VoidCallback onCopy;

  const _HistoryEntryTile({
    required this.entry,
    required this.onSpeak,
    required this.onCopy,
  });

  IconData get _sourceIcon {
    switch (entry.source) {
      case 'typed':
        return Icons.keyboard_outlined;
      case 'phrase':
        return Icons.format_quote_outlined;
      case 'ai_expanded':
        return Icons.auto_awesome;
      default:
        return Icons.grid_view_outlined;
    }
  }

  Color get _sourceColor {
    switch (entry.source) {
      case 'ai_expanded':
        return AppColors.aiViolet;
      case 'typed':
        return AppColors.grey600;
      default:
        return AppColors.inkTeal;
    }
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'ahora mismo';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours} h';
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$min';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Source icon badge
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _sourceColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(_sourceIcon, size: 14, color: _sourceColor),
            ),
            const SizedBox(width: 10),

            // Text and timestamp
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.text,
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.inkTeal,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(entry.timestamp),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionBtn(
                  icon: Icons.volume_up_outlined,
                  tooltip: 'Reproducir',
                  color: AppColors.inkTeal,
                  onTap: onSpeak,
                ),
                _ActionBtn(
                  icon: Icons.copy_outlined,
                  tooltip: 'Copiar',
                  color: AppColors.grey500,
                  onTap: onCopy,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 17, color: color),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history_toggle_off_rounded,
            size: 56,
            color: AppColors.grey300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Sin mensajes aún',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Los mensajes hablados aparecerán aquí',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }
}

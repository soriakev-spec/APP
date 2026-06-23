import 'package:flutter/material.dart';

import 'package:habla/core/theme/app_colors.dart';

/// A reusable in-app confirmation dialog.
///
/// Shows an [AlertDialog] with a message and two buttons — confirm and cancel.
/// Call via [showDialog]:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => ConfirmDialog(
///     title: 'Eliminar',
///     message: '¿Deseas eliminar este elemento?',
///     confirmLabel: 'Eliminar',
///     confirmColor: AppColors.error,
///     onConfirm: () { /* action */ },
///   ),
/// );
/// ```
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
    this.confirmColor,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color? confirmColor;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveConfirmColor = confirmColor ?? AppColors.inkTeal;

    return AlertDialog(
      title: Text(title, style: theme.textTheme.titleLarge),
      content: Text(message, style: theme.textTheme.bodyLarge),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelLabel,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.grey600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveConfirmColor,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

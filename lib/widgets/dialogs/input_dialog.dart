import 'package:flutter/material.dart';

import 'package:habla/core/theme/app_colors.dart';

/// A reusable in-app text-input dialog.
///
/// Shows an [AlertDialog] with a [TextFormField] and confirm/cancel buttons.
/// The [validator] is run on submit; if it returns a non-null string the
/// submit is blocked and the error is shown.
///
/// Example:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => InputDialog(
///     title: 'Nuevo nombre',
///     hint: 'Escribe un nombre',
///     confirmLabel: 'Guardar',
///     onConfirm: (value) { /* use value */ },
///   ),
/// );
/// ```
class InputDialog extends StatefulWidget {
  const InputDialog({
    super.key,
    required this.title,
    this.hint,
    this.initialValue,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
    this.validator,
    required this.onConfirm,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String title;
  final String? hint;
  final String? initialValue;
  final String confirmLabel;
  final String cancelLabel;
  final String? Function(String?)? validator;
  final void Function(String) onConfirm;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop();
      widget.onConfirm(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.title, style: theme.textTheme.titleLarge),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hint,
          ),
          validator: widget.validator ??
              (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              },
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            widget.cancelLabel,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.grey600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

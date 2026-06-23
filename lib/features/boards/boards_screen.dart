// Boards screen — manage tableros for the current profile.
// Shows a grid of BoardCard widgets with search, import, create and activation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../state/providers/board_provider.dart';
import '../../state/providers/profile_provider.dart';

// ---------------------------------------------------------------------------
// BoardsScreen
// ---------------------------------------------------------------------------

class BoardsScreen extends ConsumerStatefulWidget {
  const BoardsScreen({super.key});

  @override
  ConsumerState<BoardsScreen> createState() => _BoardsScreenState();
}

class _BoardsScreenState extends ConsumerState<BoardsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileDataProvider);
    final boards = ref.watch(boardsForCurrentProfileProvider);

    final filtered = _query.isEmpty
        ? boards
        : boards
            .where((b) =>
                b.name.toLowerCase().contains(_query.toLowerCase()) ||
                (b.description ?? '').toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableros de ${profile?.name ?? 'Perfil'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file_outlined),
            tooltip: 'Importar tablero',
            onPressed: () => _showImportDialog(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar tableros…',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? _buildEmpty(context)
          : Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(builder: (ctx, constraints) {
                final crossAxis = constraints.maxWidth > 900
                    ? 3
                    : (constraints.maxWidth > 600 ? 2 : 1);
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxis,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) => BoardCard(board: filtered[i]),
                );
              }),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/boards/create'),
        icon: const Icon(Icons.add),
        label: const Text('Crear tablero'),
        backgroundColor: AppColors.inkTeal,
        foregroundColor: AppColors.white,
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.dashboard_outlined, size: 64, color: AppColors.grey300),
          const SizedBox(height: 16),
          Text(
            'No hay tableros',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea uno para empezar.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/boards/create'),
            icon: const Icon(Icons.add),
            label: const Text('Crear tablero'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Importar tablero'),
        content: const Text(
          'Selecciona un archivo JSON de tablero exportado previamente desde Habla.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Función de importación próximamente')),
              );
            },
            child: const Text('Seleccionar archivo'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BoardCard
// ---------------------------------------------------------------------------

class BoardCard extends ConsumerWidget {
  const BoardCard({super.key, required this.board});

  final BoardEntity board;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/editor/${board.id}'),
      onLongPress: () => _showContextSheet(context, ref),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      board.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (board.isActive) ...[
                    const SizedBox(width: 6),
                    _ActiveBadge(),
                  ],
                  _BoardMenu(board: board),
                ],
              ),

              // Description
              if ((board.description ?? '').isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  board.description!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.grey600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const Spacer(),

              // Chips
              Wrap(
                spacing: 6,
                children: [
                  _Chip(
                    label: '${board.buttonCount} botones',
                    icon: Icons.grid_view_rounded,
                  ),
                  _Chip(
                    label: _vocabTypeLabel(board.vocabularyType),
                    icon: Icons.label_outline,
                    bgColor: cs.secondaryContainer,
                    fgColor: cs.onSecondaryContainer,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _vocabTypeLabel(String type) {
    const labels = {
      'core_first': 'Core First',
      'aphasia': 'Afasia',
      'als': 'ELA',
      'blank': 'En blanco',
    };
    return labels[type] ?? 'Personalizado';
  }

  void _showContextSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _BoardContextSheet(board: board),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
      ),
      child: Text(
        'Activo',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.icon,
    this.bgColor,
    this.fgColor,
  });

  final String label;
  final IconData icon;
  final Color? bgColor;
  final Color? fgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fgColor ?? AppColors.grey600),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: fgColor ?? AppColors.grey700),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Board 3-dot popup menu
// ---------------------------------------------------------------------------

enum _BoardAction { activate, edit, duplicate, rename, export, assign, delete }

class _BoardMenu extends ConsumerWidget {
  const _BoardMenu({required this.board});

  final BoardEntity board;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_BoardAction>(
      icon: const Icon(Icons.more_vert, size: 20),
      onSelected: (action) => _handleAction(context, ref, action),
      itemBuilder: (ctx) => [
        if (!board.isActive)
          const PopupMenuItem(
            value: _BoardAction.activate,
            child: ListTile(
              dense: true,
              leading: Icon(Icons.check_circle_outline),
              title: Text('Activar'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        const PopupMenuItem(
          value: _BoardAction.edit,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.edit_outlined),
            title: Text('Editar'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: _BoardAction.duplicate,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.copy_outlined),
            title: Text('Duplicar'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: _BoardAction.rename,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.drive_file_rename_outline),
            title: Text('Renombrar'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: _BoardAction.export,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.upload_outlined),
            title: Text('Exportar'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: _BoardAction.assign,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.person_outline),
            title: Text('Asignar a perfil'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: _BoardAction.delete,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.delete_outline, color: AppColors.error),
            title: Text('Eliminar', style: TextStyle(color: AppColors.error)),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  void _handleAction(BuildContext ctx, WidgetRef ref, _BoardAction action) {
    final notifier = ref.read(boardsForCurrentProfileProvider.notifier);
    switch (action) {
      case _BoardAction.activate:
        notifier.activate(board.id);
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
              content:
                  Text('"${board.name}" ahora es el tablero activo')),
        );
      case _BoardAction.edit:
        ctx.push('/editor/${board.id}');
      case _BoardAction.duplicate:
        notifier.duplicate(board.id);
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('"${board.name}" duplicado')),
        );
      case _BoardAction.rename:
        _showRenameDialog(ctx, ref);
      case _BoardAction.export:
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Exportación próximamente')),
        );
      case _BoardAction.assign:
        _showAssignDialog(ctx, ref);
      case _BoardAction.delete:
        _showDeleteDialog(ctx, ref);
    }
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController(text: board.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Renombrar tablero'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nombre del tablero'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isNotEmpty) {
                ref.read(boardsForCurrentProfileProvider.notifier).update(
                      board.copyWith(
                          name: name, updatedAt: DateTime.now()),
                    );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(BuildContext context, WidgetRef ref) {
    final profiles = ref.read(allProfilesProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Asignar a perfil'),
        content: SizedBox(
          width: 320,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: profiles.length,
            itemBuilder: (_, i) {
              final p = profiles[i];
              return ListTile(
                leading: Text(p.avatarEmoji ?? '👤',
                    style: const TextStyle(fontSize: 24)),
                title: Text(p.name),
                onTap: () {
                  ref
                      .read(boardsForCurrentProfileProvider.notifier)
                      .update(board.copyWith(
                          profileId: p.id, updatedAt: DateTime.now()));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Tablero asignado a ${p.name}')),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tablero'),
        content: Text(
            '¿Eliminar "${board.name}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              ref
                  .read(boardsForCurrentProfileProvider.notifier)
                  .delete(board.id);
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Long-press context sheet
// ---------------------------------------------------------------------------

class _BoardContextSheet extends ConsumerWidget {
  const _BoardContextSheet({required this.board});

  final BoardEntity board;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.open_in_new_outlined),
            title: const Text('Abrir en editor'),
            onTap: () {
              Navigator.pop(context);
              context.push('/editor/${board.id}');
            },
          ),
          if (!board.isActive)
            ListTile(
              leading: const Icon(Icons.check_circle_outline,
                  color: AppColors.success),
              title: const Text('Activar tablero'),
              onTap: () {
                ref
                    .read(boardsForCurrentProfileProvider.notifier)
                    .activate(board.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          '"${board.name}" ahora es el tablero activo')),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.copy_outlined),
            title: const Text('Duplicar'),
            onTap: () {
              ref
                  .read(boardsForCurrentProfileProvider.notifier)
                  .duplicate(board.id);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: AppColors.error),
            title: const Text('Eliminar',
                style: TextStyle(color: AppColors.error)),
            onTap: () {
              ref
                  .read(boardsForCurrentProfileProvider.notifier)
                  .delete(board.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

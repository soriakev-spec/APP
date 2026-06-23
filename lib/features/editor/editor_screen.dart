// Board editor screen — full drag-reorder grid editor with inspector panel.
// Tablet: side inspector + main grid. Phone: AppBar tabs for inspector panels.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/responsive.dart';
import '../../state/providers/board_provider.dart';

// ---------------------------------------------------------------------------
// Editor state
// ---------------------------------------------------------------------------

class EditorState {
  final BoardEntity? board;
  final List<VocabularyItemEntity> items;
  final String? selectedItemId;
  final List<List<VocabularyItemEntity>> undoStack;
  final List<List<VocabularyItemEntity>> redoStack;
  final bool isDirty;
  final bool isReorderMode;
  final bool isBatchSelect;
  final Set<String> selectedIds;

  const EditorState({
    this.board,
    this.items = const [],
    this.selectedItemId,
    this.undoStack = const [],
    this.redoStack = const [],
    this.isDirty = false,
    this.isReorderMode = false,
    this.isBatchSelect = false,
    this.selectedIds = const {},
  });

  bool get canUndo => undoStack.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;

  VocabularyItemEntity? get selectedItem =>
      selectedItemId == null
          ? null
          : items.where((i) => i.id == selectedItemId).firstOrNull;

  EditorState copyWith({
    BoardEntity? board,
    List<VocabularyItemEntity>? items,
    Object? selectedItemId = _editorSentinel,
    List<List<VocabularyItemEntity>>? undoStack,
    List<List<VocabularyItemEntity>>? redoStack,
    bool? isDirty,
    bool? isReorderMode,
    bool? isBatchSelect,
    Set<String>? selectedIds,
  }) {
    return EditorState(
      board: board ?? this.board,
      items: items ?? this.items,
      selectedItemId: selectedItemId == _editorSentinel
          ? this.selectedItemId
          : selectedItemId as String?,
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
      isDirty: isDirty ?? this.isDirty,
      isReorderMode: isReorderMode ?? this.isReorderMode,
      isBatchSelect: isBatchSelect ?? this.isBatchSelect,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }
}

const Object _editorSentinel = Object();

// ---------------------------------------------------------------------------
// EditorNotifier
// ---------------------------------------------------------------------------

class EditorNotifier extends StateNotifier<EditorState> {
  final String boardId;
  final Ref _ref;

  EditorNotifier({required this.boardId, required Ref ref})
      : _ref = ref,
        super(const EditorState()) {
    _init();
  }

  void _init() {
    final boards = _ref.read(boardsForCurrentProfileProvider);
    final board = boards.where((b) => b.id == boardId).firstOrNull;
    final items = _ref.read(vocabularyForActiveBoardProvider);
    state = state.copyWith(board: board, items: items);
  }

  void selectItem(String? id) {
    state = state.copyWith(
      selectedItemId: id ?? _editorSentinel,
      isBatchSelect: false,
    );
  }

  void updateItem(VocabularyItemEntity item) {
    _pushUndo();
    state = state.copyWith(
      items: state.items.map((i) => i.id == item.id ? item : i).toList(),
      isDirty: true,
    );
  }

  void addItem(VocabularyItemEntity item) {
    _pushUndo();
    state = state.copyWith(
      items: [...state.items, item],
      isDirty: true,
    );
  }

  void deleteItem(String id) {
    _pushUndo();
    state = state.copyWith(
      items: state.items.where((i) => i.id != id).toList(),
      selectedItemId: _editorSentinel,
      isDirty: true,
    );
  }

  void deleteSelectedItems() {
    if (state.selectedIds.isEmpty) return;
    _pushUndo();
    state = state.copyWith(
      items:
          state.items.where((i) => !state.selectedIds.contains(i.id)).toList(),
      selectedIds: {},
      isDirty: true,
    );
  }

  void moveItem(int oldIndex, int newIndex) {
    _pushUndo();
    final list = [...state.items];
    final item = list.removeAt(oldIndex);
    final idx = newIndex > oldIndex ? newIndex - 1 : newIndex;
    list.insert(idx, item);
    state = state.copyWith(
      items: list
          .asMap()
          .entries
          .map((e) => e.value.copyWith(sortOrder: e.key))
          .toList(),
      isDirty: true,
    );
  }

  void undo() {
    if (!state.canUndo) return;
    final stack = [...state.undoStack];
    final snapshot = stack.removeLast();
    state = state.copyWith(
      items: snapshot,
      undoStack: stack,
      redoStack: [state.items, ...state.redoStack],
      isDirty: true,
    );
  }

  void redo() {
    if (!state.canRedo) return;
    final stack = [...state.redoStack];
    final snapshot = stack.removeAt(0);
    state = state.copyWith(
      items: snapshot,
      redoStack: stack,
      undoStack: [...state.undoStack, state.items],
      isDirty: true,
    );
  }

  Future<void> save() async {
    if (state.board != null) {
      await _ref
          .read(boardsForCurrentProfileProvider.notifier)
          .update(state.board!.copyWith(updatedAt: DateTime.now()));
    }
    state = state.copyWith(isDirty: false);
  }

  void toggleReorderMode() {
    state = state.copyWith(
      isReorderMode: !state.isReorderMode,
      isBatchSelect: false,
      selectedIds: {},
    );
  }

  void toggleBatchSelect() {
    state = state.copyWith(
      isBatchSelect: !state.isBatchSelect,
      isReorderMode: false,
      selectedIds: {},
    );
  }

  void toggleBatchItem(String id) {
    final ids = {...state.selectedIds};
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    state = state.copyWith(selectedIds: ids);
  }

  void renameBoardInline(String name) {
    if (state.board == null || name.trim().isEmpty) return;
    state = state.copyWith(
      board:
          state.board!.copyWith(name: name.trim(), updatedAt: DateTime.now()),
      isDirty: true,
    );
  }

  void _pushUndo() {
    final stack = [...state.undoStack, state.items];
    final trimmed =
        stack.length > 30 ? stack.sublist(stack.length - 30) : stack;
    state = state.copyWith(undoStack: trimmed, redoStack: []);
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final editorBoardIdProvider = StateProvider<String>((ref) => '');

final editorBoardProvider =
    StateNotifierProvider<EditorNotifier, EditorState>((ref) {
  final boardId = ref.watch(editorBoardIdProvider);
  return EditorNotifier(boardId: boardId, ref: ref);
});

// Inspector tab enum
enum _InspectorTab { content, style, action }

// ---------------------------------------------------------------------------
// EditorScreen
// ---------------------------------------------------------------------------

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key, required this.boardId});

  final String boardId;

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  _InspectorTab _inspectorTab = _InspectorTab.content;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(editorBoardIdProvider.notifier).state = widget.boardId;
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final edState = ref.watch(editorBoardProvider);
    final board = edState.board;
    final isWide = context.isTabletOrLarger;

    return Scaffold(
      appBar: _buildAppBar(context, edState, board),
      body: Column(
        children: [
          _EditorToolbar(editorState: edState),
          const Divider(height: 1),
          Expanded(
            child: isWide
                ? _buildTabletLayout(edState)
                : _buildPhoneLayout(edState),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(
      BuildContext context, EditorState edState, BoardEntity? board) {
    return AppBar(
      title: _InlineBoardNameField(
        key: ValueKey(board?.id),
        initialName: board?.name ?? 'Tablero sin título',
        onChanged: (v) =>
            ref.read(editorBoardProvider.notifier).renameBoardInline(v),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.undo),
          tooltip: 'Deshacer',
          onPressed: edState.canUndo
              ? () => ref.read(editorBoardProvider.notifier).undo()
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.redo),
          tooltip: 'Rehacer',
          onPressed: edState.canRedo
              ? () => ref.read(editorBoardProvider.notifier).redo()
              : null,
        ),
        IconButton(
          icon: Icon(
            Icons.save_outlined,
            color:
                edState.isDirty ? AppColors.inkTeal : AppColors.grey400,
          ),
          tooltip: 'Guardar',
          onPressed: edState.isDirty
              ? () async {
                  await ref.read(editorBoardProvider.notifier).save();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tablero guardado')),
                    );
                  }
                }
              : null,
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (v) => _handleAppBarMenu(context, v),
          itemBuilder: (ctx) => const [
            PopupMenuItem(value: 'templates', child: Text('Plantillas')),
            PopupMenuItem(value: 'theme', child: Text('Tema del tablero')),
            PopupMenuItem(value: 'export', child: Text('Exportar')),
          ],
        ),
      ],
    );
  }

  Widget _buildTabletLayout(EditorState edState) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: _InspectorPanel(
            editorState: edState,
            currentTab: _inspectorTab,
            onTabChanged: (t) => setState(() => _inspectorTab = t),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: _EditorGrid(editorState: edState)),
      ],
    );
  }

  Widget _buildPhoneLayout(EditorState edState) {
    return Column(
      children: [
        TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(text: 'Contenido'),
            Tab(text: 'Estilo'),
            Tab(text: 'Acción'),
          ],
          onTap: (i) =>
              setState(() => _inspectorTab = _InspectorTab.values[i]),
        ),
        Expanded(child: _EditorGrid(editorState: edState)),
      ],
    );
  }

  void _handleAppBarMenu(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action — próximamente')),
    );
  }
}

// ---------------------------------------------------------------------------
// Inline board name field
// ---------------------------------------------------------------------------

class _InlineBoardNameField extends StatefulWidget {
  const _InlineBoardNameField({
    super.key,
    required this.initialName,
    required this.onChanged,
  });

  final String initialName;
  final ValueChanged<String> onChanged;

  @override
  State<_InlineBoardNameField> createState() => _InlineBoardNameFieldState();
}

class _InlineBoardNameFieldState extends State<_InlineBoardNameField> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.inkTeal,
            fontWeight: FontWeight.w600,
          ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.inkTeal, width: 2),
        ),
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      onChanged: widget.onChanged,
    );
  }
}

// ---------------------------------------------------------------------------
// Editor Toolbar
// ---------------------------------------------------------------------------

class _EditorToolbar extends ConsumerWidget {
  const _EditorToolbar({required this.editorState});

  final EditorState editorState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(editorBoardProvider.notifier);

    return Container(
      height: 48,
      color: AppColors.grey50,
      child: Row(
        children: [
          const SizedBox(width: 8),
          _TBtn(
            icon: Icons.add,
            label: 'Agregar',
            onPressed: () => _addNewItem(ref),
          ),
          const SizedBox(width: 4),
          _TBtn(
            icon: Icons.delete_outline,
            label: 'Eliminar',
            onPressed: editorState.selectedItemId != null
                ? () => notifier.deleteItem(editorState.selectedItemId!)
                : editorState.selectedIds.isNotEmpty
                    ? () => notifier.deleteSelectedItems()
                    : null,
          ),
          const SizedBox(width: 4),
          _TBtn(
            icon: Icons.edit_outlined,
            label: 'Editar',
            onPressed: editorState.selectedItem != null
                ? () => _editSelectedItem(context, editorState.selectedItem!)
                : null,
          ),
          const Spacer(),
          _TBtn(
            icon: Icons.select_all,
            label: 'Multi',
            isActive: editorState.isBatchSelect,
            onPressed: () => notifier.toggleBatchSelect(),
          ),
          const SizedBox(width: 4),
          _TBtn(
            icon: Icons.swap_vert,
            label: 'Reordenar',
            isActive: editorState.isReorderMode,
            onPressed: () => notifier.toggleReorderMode(),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  void _addNewItem(WidgetRef ref) {
    final item = VocabularyItemEntity(
      id: const Uuid().v4(),
      label: 'Nueva palabra',
      message: 'Nueva palabra',
      category: 'nouns',
      fitzgerald: 'nouns',
      isCore: false,
      sortOrder: ref.read(editorBoardProvider).items.length,
      usageCount: 0,
      isFavorite: false,
    );
    ref.read(editorBoardProvider.notifier).addItem(item);
    ref.read(editorBoardProvider.notifier).selectItem(item.id);
  }

  void _editSelectedItem(BuildContext context, VocabularyItemEntity item) {
    showDialog(
      context: context,
      builder: (_) => _ItemEditDialog(item: item),
    );
  }
}

class _TBtn extends StatelessWidget {
  const _TBtn({
    required this.icon,
    required this.label,
    this.onPressed,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.inkTeal;
    final inactiveColor =
        onPressed != null ? AppColors.grey700 : AppColors.grey400;
    final color = isActive ? activeColor : inactiveColor;

    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
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
// Editor Grid
// ---------------------------------------------------------------------------

class _EditorGrid extends ConsumerWidget {
  const _EditorGrid({required this.editorState});

  final EditorState editorState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = editorState.items;
    final cols = _cols(editorState.board?.buttonCount ?? 15);

    if (editorState.isReorderMode) {
      return ReorderableListView.builder(
        buildDefaultDragHandles: false,
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (ctx, i) => ReorderableDragStartListener(
          key: ValueKey(items[i].id),
          index: i,
          child: EditorButton(
            item: items[i],
            isSelected: editorState.selectedItemId == items[i].id,
            isBatchSelected: editorState.selectedIds.contains(items[i].id),
            isReorderMode: true,
            onTap: () =>
                ref.read(editorBoardProvider.notifier).selectItem(items[i].id),
            onLongPress: () =>
                _showItemSheet(context, items[i], ref),
          ),
        ),
        onReorder: (oldIdx, newIdx) =>
            ref.read(editorBoardProvider.notifier).moveItem(oldIdx, newIdx),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, i) => EditorButton(
        key: ValueKey(items[i].id),
        item: items[i],
        isSelected: editorState.selectedItemId == items[i].id ||
            editorState.selectedIds.contains(items[i].id),
        isBatchSelected: editorState.selectedIds.contains(items[i].id),
        isReorderMode: false,
        onTap: () {
          if (editorState.isBatchSelect) {
            ref
                .read(editorBoardProvider.notifier)
                .toggleBatchItem(items[i].id);
          } else {
            ref.read(editorBoardProvider.notifier).selectItem(items[i].id);
          }
        },
        onLongPress: () => _showItemSheet(context, items[i], ref),
      ),
    );
  }

  int _cols(int buttonCount) {
    if (buttonCount <= 4) return 2;
    if (buttonCount <= 8) return 4;
    if (buttonCount <= 15) return 5;
    if (buttonCount <= 30) return 6;
    if (buttonCount <= 60) return 8;
    return 10;
  }

  void _showItemSheet(
      BuildContext context, VocabularyItemEntity item, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder: (_) => _ItemEditDialog(item: item),
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: AppColors.error),
              title: const Text('Eliminar',
                  style: TextStyle(color: AppColors.error)),
              onTap: () {
                ref.read(editorBoardProvider.notifier).deleteItem(item.id);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EditorButton widget
// ---------------------------------------------------------------------------

class EditorButton extends ConsumerWidget {
  const EditorButton({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isBatchSelected,
    required this.isReorderMode,
    required this.onTap,
    required this.onLongPress,
  });

  final VocabularyItemEntity item;
  final bool isSelected;
  final bool isBatchSelected;
  final bool isReorderMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fitzColor = _fitzColor(item.fitzgerald);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: fitzColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.inkTeal
                : (isBatchSelected
                    ? AppColors.aiViolet
                    : fitzColor.withValues(alpha: 0.5)),
            width: isSelected || isBatchSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.inkTeal.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Fitzgerald color bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: fitzColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                ),
              ),
            ),

            // Symbol / icon
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 10, 4, 22),
                child: item.symbolPath != null
                    ? Image.asset(
                        item.symbolPath!,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.grey400,
                        ),
                      )
                    : Icon(
                        _categoryIcon(item.category),
                        size: 24,
                        color: fitzColor.withValues(alpha: 0.8),
                      ),
              ),
            ),

            // Label
            Positioned(
              left: 4,
              right: 4,
              bottom: 4,
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: AppColors.grey800,
                    ),
              ),
            ),

            // Batch check
            if (isBatchSelected)
              const Positioned(
                top: 6,
                right: 6,
                child: Icon(Icons.check_circle,
                    size: 16, color: AppColors.aiViolet),
              ),

            // Reorder handle
            if (isReorderMode)
              const Positioned(
                bottom: 4,
                right: 4,
                child: Icon(Icons.drag_indicator,
                    size: 14, color: AppColors.grey400),
              ),

            // Selected edit hint
            if (isSelected && !isReorderMode && !isBatchSelected)
              const Positioned(
                top: 6,
                right: 6,
                child: Icon(Icons.edit, size: 14, color: AppColors.inkTeal),
              ),
          ],
        ),
      ),
    );
  }

  Color _fitzColor(String fitz) {
    switch (fitz) {
      case 'people':
        return AppColors.fitzPeople;
      case 'verbs':
        return AppColors.fitzVerbs;
      case 'descriptors':
        return AppColors.fitzDescriptors;
      case 'social':
        return AppColors.fitzSocial;
      case 'function':
        return AppColors.fitzFunction;
      case 'navigation':
        return AppColors.fitzNavigation;
      default:
        return AppColors.fitzNouns;
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'people':
        return Icons.person_outline;
      case 'verbs':
        return Icons.directions_run;
      case 'descriptors':
        return Icons.palette_outlined;
      case 'social':
        return Icons.waving_hand_outlined;
      case 'function':
        return Icons.functions;
      case 'navigation':
        return Icons.explore_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}

// ---------------------------------------------------------------------------
// Inspector Panel (tablet side panel)
// ---------------------------------------------------------------------------

class _InspectorPanel extends ConsumerWidget {
  const _InspectorPanel({
    required this.editorState,
    required this.currentTab,
    required this.onTabChanged,
  });

  final EditorState editorState;
  final _InspectorTab currentTab;
  final ValueChanged<_InspectorTab> onTabChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = editorState.selectedItem;

    return Column(
      children: [
        // Tab bar
        Container(
          color: AppColors.grey50,
          child: Row(
            children: _InspectorTab.values.map((tab) {
              final label = switch (tab) {
                _InspectorTab.content => 'Contenido',
                _InspectorTab.style => 'Estilo',
                _InspectorTab.action => 'Acción',
              };
              final isActive = currentTab == tab;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(tab),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isActive
                              ? AppColors.inkTeal
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                            color: isActive
                                ? AppColors.inkTeal
                                : AppColors.grey500,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 1),

        // Panel body
        Expanded(
          child: item == null
              ? _emptyInspector(context)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: switch (currentTab) {
                    _InspectorTab.content =>
                      _ContentInspector(item: item, ref: ref),
                    _InspectorTab.style =>
                      _StyleInspector(item: item),
                    _InspectorTab.action =>
                      _ActionInspector(item: item),
                  },
                ),
        ),
      ],
    );
  }

  Widget _emptyInspector(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.touch_app_outlined,
                size: 40, color: AppColors.grey300),
            const SizedBox(height: 12),
            Text(
              'Selecciona un botón\npara editar sus propiedades',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content Inspector
// ---------------------------------------------------------------------------

class _ContentInspector extends StatefulWidget {
  const _ContentInspector({required this.item, required this.ref});

  final VocabularyItemEntity item;
  final WidgetRef ref;

  @override
  State<_ContentInspector> createState() => _ContentInspectorState();
}

class _ContentInspectorState extends State<_ContentInspector> {
  late TextEditingController _labelCtrl;
  late TextEditingController _messageCtrl;
  late String _fitzgerald;
  late String _category;

  @override
  void initState() {
    super.initState();
    _labelCtrl = TextEditingController(text: widget.item.label);
    _messageCtrl = TextEditingController(text: widget.item.message);
    _fitzgerald = widget.item.fitzgerald;
    _category = widget.item.category;
  }

  @override
  void didUpdateWidget(_ContentInspector old) {
    super.didUpdateWidget(old);
    if (old.item.id != widget.item.id) {
      _labelCtrl.text = widget.item.label;
      _messageCtrl.text = widget.item.message;
      setState(() {
        _fitzgerald = widget.item.fitzgerald;
        _category = widget.item.category;
      });
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.ref.read(editorBoardProvider.notifier).updateItem(
          widget.item.copyWith(
            label: _labelCtrl.text.trim(),
            message: _messageCtrl.text.trim(),
            category: _category,
            fitzgerald: _fitzgerald,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    const categories = [
      'people', 'verbs', 'descriptors', 'nouns', 'social', 'function',
      'navigation'
    ];
    const catLabels = {
      'people': 'Personas',
      'verbs': 'Verbos',
      'descriptors': 'Descriptores',
      'nouns': 'Sustantivos',
      'social': 'Social',
      'function': 'Función',
      'navigation': 'Navegación',
    };
    const fitzColors = {
      'people': AppColors.fitzPeople,
      'verbs': AppColors.fitzVerbs,
      'descriptors': AppColors.fitzDescriptors,
      'nouns': AppColors.fitzNouns,
      'social': AppColors.fitzSocial,
      'function': AppColors.fitzFunction,
      'navigation': AppColors.fitzNavigation,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label('Etiqueta'),
        TextField(
          controller: _labelCtrl,
          decoration:
              const InputDecoration(hintText: 'Etiqueta visible en botón'),
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 14),

        _Label('Mensaje (TTS)'),
        TextField(
          controller: _messageCtrl,
          decoration:
              const InputDecoration(hintText: 'Texto que se pronunciará'),
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 14),

        _Label('Símbolo'),
        OutlinedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Selector de símbolo próximamente')),
          ),
          icon: const Icon(Icons.image_outlined),
          label: const Text('Cambiar símbolo'),
        ),
        const SizedBox(height: 14),

        _Label('Categoría'),
        DropdownButtonFormField<String>(
          value: categories.contains(_category) ? _category : 'nouns',
          decoration: const InputDecoration(isDense: true),
          items: categories
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(catLabels[c] ?? c),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _category = v);
            _save();
          },
        ),
        const SizedBox(height: 14),

        _Label('Color Fitzgerald'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((fitz) {
            final color = fitzColors[fitz] ?? AppColors.fitzNouns;
            final isActive = _fitzgerald == fitz;
            return Tooltip(
              message: catLabels[fitz] ?? fitz,
              child: GestureDetector(
                onTap: () {
                  setState(() => _fitzgerald = fitz);
                  _save();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive
                          ? AppColors.inkTeal
                          : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: 6,
                            )
                          ]
                        : null,
                  ),
                  child: isActive
                      ? const Icon(Icons.check, size: 16,
                          color: Colors.white)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Style Inspector
// ---------------------------------------------------------------------------

class _StyleInspector extends StatefulWidget {
  const _StyleInspector({required this.item});

  final VocabularyItemEntity item;

  @override
  State<_StyleInspector> createState() => _StyleInspectorState();
}

class _StyleInspectorState extends State<_StyleInspector> {
  double _textSize = 10;
  double _iconSize = 24;
  Color _bgColor = AppColors.grey100;

  final _bgOptions = <Color>[
    AppColors.grey100,
    Colors.white,
    AppColors.fitzPeople.withValues(alpha: 0.2),
    AppColors.fitzVerbs.withValues(alpha: 0.2),
    AppColors.fitzNouns.withValues(alpha: 0.2),
    AppColors.fitzDescriptors.withValues(alpha: 0.2),
    AppColors.fitzSocial.withValues(alpha: 0.2),
    AppColors.fitzFunction.withValues(alpha: 0.2),
    AppColors.aiVioletLight,
    AppColors.successLight,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label('Color de fondo'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _bgOptions.map((c) {
            final isActive = _bgColor == c;
            return GestureDetector(
              onTap: () => setState(() => _bgColor = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        isActive ? AppColors.inkTeal : AppColors.grey300,
                    width: isActive ? 2.5 : 1,
                  ),
                ),
                child: isActive
                    ? const Icon(Icons.check,
                        size: 16, color: AppColors.inkTeal)
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        _Label('Tamaño de texto'),
        _SliderRow(
          value: _textSize,
          min: 8,
          max: 20,
          divisions: 12,
          onChanged: (v) => setState(() => _textSize = v),
        ),
        const SizedBox(height: 12),

        _Label('Tamaño de ícono'),
        _SliderRow(
          value: _iconSize,
          min: 16,
          max: 56,
          divisions: 20,
          onChanged: (v) => setState(() => _iconSize = v),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Action Inspector
// ---------------------------------------------------------------------------

class _ActionInspector extends StatefulWidget {
  const _ActionInspector({required this.item});

  final VocabularyItemEntity item;

  @override
  State<_ActionInspector> createState() => _ActionInspectorState();
}

class _ActionInspectorState extends State<_ActionInspector> {
  String _actionType = 'speak';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label('Tipo de acción'),
        RadioListTile<String>(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('Pronunciar texto'),
          value: 'speak',
          groupValue: _actionType,
          activeColor: AppColors.inkTeal,
          onChanged: (v) => setState(() => _actionType = v!),
        ),
        RadioListTile<String>(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('Abrir tablero'),
          value: 'board_link',
          groupValue: _actionType,
          activeColor: AppColors.inkTeal,
          onChanged: (v) => setState(() => _actionType = v!),
        ),
        RadioListTile<String>(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('Acción personalizada'),
          value: 'custom',
          groupValue: _actionType,
          activeColor: AppColors.inkTeal,
          onChanged: (v) => setState(() => _actionType = v!),
        ),
        const SizedBox(height: 16),

        if (_actionType == 'board_link') ...[
          _Label('Tablero destino'),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Selector de tablero próximamente')),
            ),
            icon: const Icon(Icons.dashboard_outlined),
            label: const Text('Seleccionar tablero'),
          ),
        ],

        if (_actionType == 'speak') ...[
          _Label('Probar'),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Pronunciando: ${widget.item.message}')),
            ),
            icon: const Icon(Icons.volume_up_outlined),
            label: const Text('Probar pronunciación'),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Item edit dialog
// ---------------------------------------------------------------------------

class _ItemEditDialog extends ConsumerStatefulWidget {
  const _ItemEditDialog({required this.item});

  final VocabularyItemEntity item;

  @override
  ConsumerState<_ItemEditDialog> createState() => _ItemEditDialogState();
}

class _ItemEditDialogState extends ConsumerState<_ItemEditDialog> {
  late TextEditingController _labelCtrl;
  late TextEditingController _messageCtrl;

  @override
  void initState() {
    super.initState();
    _labelCtrl = TextEditingController(text: widget.item.label);
    _messageCtrl = TextEditingController(text: widget.item.message);
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar botón'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _labelCtrl,
            decoration: const InputDecoration(labelText: 'Etiqueta'),
            autofocus: true,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageCtrl,
            decoration: const InputDecoration(labelText: 'Mensaje (TTS)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(editorBoardProvider.notifier).updateItem(
                  widget.item.copyWith(
                    label: _labelCtrl.text.trim(),
                    message: _messageCtrl.text.trim(),
                  ),
                );
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.grey600,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppColors.inkTeal,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 32,
          child: Text(
            '${value.round()}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

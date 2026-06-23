// Create board screen — form to create a new tablero.
// Supports vocabulary type selection, grid size, profile assignment.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../state/providers/board_provider.dart';
import '../../state/providers/profile_provider.dart';

// ---------------------------------------------------------------------------
// Vocabulary type config
// ---------------------------------------------------------------------------

class _VocabType {
  final String key;
  final String label;
  final String description;
  final IconData icon;
  final int estimatedItems;

  const _VocabType({
    required this.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.estimatedItems,
  });
}

const _vocabTypes = [
  _VocabType(
    key: 'core_first',
    label: 'Core First',
    description: 'Vocabulario de alta frecuencia basado en lenguaje nuclear.',
    icon: Icons.star_outlined,
    estimatedItems: 120,
  ),
  _VocabType(
    key: 'aphasia',
    label: 'Afasia',
    description: 'Diseñado para personas con afasia post-ACV.',
    icon: Icons.favorite_outline,
    estimatedItems: 80,
  ),
  _VocabType(
    key: 'als',
    label: 'ELA',
    description: 'Optimizado para acceso rápido en esclerosis lateral.',
    icon: Icons.accessibility_new_outlined,
    estimatedItems: 60,
  ),
  _VocabType(
    key: 'blank',
    label: 'En blanco',
    description: 'Tablero vacío para construir desde cero.',
    icon: Icons.crop_square_outlined,
    estimatedItems: 0,
  ),
  _VocabType(
    key: 'custom',
    label: 'Personalizado',
    description: 'Selección manual de vocabulario personalizado.',
    icon: Icons.tune_outlined,
    estimatedItems: 0,
  ),
];

const _gridSizes = [4, 8, 15, 30, 60, 90];

// ---------------------------------------------------------------------------
// CreateBoardScreen
// ---------------------------------------------------------------------------

class CreateBoardScreen extends ConsumerStatefulWidget {
  const CreateBoardScreen({super.key});

  @override
  ConsumerState<CreateBoardScreen> createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends ConsumerState<CreateBoardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _selectedVocabType = 'core_first';
  int _selectedGridSize = 15;
  String? _selectedProfileId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileId = ref.read(currentProfileIdProvider);
      if (profileId != null) {
        setState(() => _selectedProfileId = profileId);
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  _VocabType get _currentVocabType =>
      _vocabTypes.firstWhere((v) => v.key == _selectedVocabType);

  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(allProfilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo tablero'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: LayoutBuilder(builder: (ctx, constraints) {
          final isWide = constraints.maxWidth > 700;
          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildForm(profiles)),
                const VerticalDivider(width: 1),
                SizedBox(
                  width: 300,
                  child: _buildPreview(),
                ),
              ],
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildForm(profiles),
                const SizedBox(height: 16),
                _buildPreview(),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: ElevatedButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Crear tablero'),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(List<ProfileEntity> profiles) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nombre del tablero *',
              hintText: 'ej. Mi tablero de comunicación',
            ),
            textCapitalization: TextCapitalization.sentences,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
          ),
          const SizedBox(height: 16),

          // Description
          TextFormField(
            controller: _descCtrl,
            decoration: const InputDecoration(
              labelText: 'Descripción (opcional)',
              hintText: 'ej. Para comunicación en casa',
            ),
            textCapitalization: TextCapitalization.sentences,
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Vocabulary type
          Text('Tipo de vocabulario',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...(_vocabTypes.map((vt) => _VocabTypeOption(
                type: vt,
                isSelected: _selectedVocabType == vt.key,
                onTap: () => setState(() => _selectedVocabType = vt.key),
              ))),
          const SizedBox(height: 24),

          // Grid size
          Text('Tamaño de cuadrícula',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _gridSizes
                .map((size) => ChoiceChip(
                      label: Text('$size'),
                      selected: _selectedGridSize == size,
                      onSelected: (_) =>
                          setState(() => _selectedGridSize = size),
                      selectedColor: AppColors.inkTeal,
                      labelStyle: TextStyle(
                        color: _selectedGridSize == size
                            ? Colors.white
                            : AppColors.grey700,
                        fontWeight: FontWeight.w500,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),

          // Profile assignment
          Text('Asignar a perfil',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedProfileId,
            decoration: const InputDecoration(
              hintText: 'Seleccionar perfil…',
            ),
            items: profiles
                .map((p) => DropdownMenuItem(
                      value: p.id,
                      child: Row(
                        children: [
                          Text(p.avatarEmoji ?? '👤',
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(p.name),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedProfileId = v),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final vt = _currentVocabType;
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.grey50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vista previa',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),

          // Grid preview
          AspectRatio(
            aspectRatio: 1.4,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              padding: const EdgeInsets.all(8),
              child: _GridPreview(size: _selectedGridSize),
            ),
          ),
          const SizedBox(height: 16),

          // Info card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(vt.icon, size: 20, color: AppColors.inkTeal),
                    const SizedBox(width: 8),
                    Text(vt.label,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(vt.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.grey600)),
                if (vt.estimatedItems > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '≈ ${vt.estimatedItems} palabras incluidas',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '$_selectedGridSize botones por vista',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.grey500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final profileId = _selectedProfileId ??
        ref.read(currentProfileIdProvider) ??
        ref.read(allProfilesProvider).firstOrNull?.id ??
        '';

    final now = DateTime.now();
    final board = BoardEntity(
      id: const Uuid().v4(),
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      profileId: profileId,
      isActive: false,
      vocabularyType: _selectedVocabType,
      buttonCount: _selectedGridSize,
      createdAt: now,
      updatedAt: now,
    );

    await ref.read(boardsForCurrentProfileProvider.notifier).create(board);

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tablero "${board.name}" creado')),
      );
      context.pop();
    }
  }
}

// ---------------------------------------------------------------------------
// _VocabTypeOption
// ---------------------------------------------------------------------------

class _VocabTypeOption extends StatelessWidget {
  const _VocabTypeOption({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final _VocabType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.inkTeal.withValues(alpha: 0.08) : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.inkTeal : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              type.icon,
              size: 22,
              color: isSelected ? AppColors.inkTeal : AppColors.grey500,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.inkTeal
                              : AppColors.grey800,
                        ),
                  ),
                  Text(
                    type.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.grey500,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.inkTeal, size: 20),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _GridPreview — shows a mini grid of boxes
// ---------------------------------------------------------------------------

class _GridPreview extends StatelessWidget {
  const _GridPreview({required this.size});

  final int size;

  @override
  Widget build(BuildContext context) {
    final cols = _cols(size);
    final rows = (size / cols).ceil();
    final totalCells = rows * cols;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: totalCells,
      itemBuilder: (_, i) => Container(
        decoration: BoxDecoration(
          color: i < size ? AppColors.grey200 : AppColors.grey100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: i < size ? AppColors.grey300 : AppColors.grey100,
          ),
        ),
      ),
    );
  }

  int _cols(int size) {
    if (size <= 4) return 2;
    if (size <= 8) return 4;
    if (size <= 15) return 5;
    if (size <= 30) return 6;
    if (size <= 60) return 8;
    return 10;
  }
}

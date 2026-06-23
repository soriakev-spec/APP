import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/core/theme/app_typography.dart';
import 'package:habla/state/providers/profile_provider.dart';

// ---------------------------------------------------------------------------
// Diagnosis labels
// ---------------------------------------------------------------------------

const Map<String, String> _diagnosisLabels = {
  'autism': 'Autismo',
  'aphasia': 'Afasia',
  'als': 'ELA',
  'cerebral_palsy': 'Parálisis Cerebral',
  'down_syndrome': 'Síndrome de Down',
  'child': 'Niño general',
  'adult_general': 'Adulto general',
};

const Map<String, String> _dispositionLabels = {
  'pictograms': 'Pictogramas',
  'visual_scene': 'Escena visual',
  'keyboard': 'Teclado',
};

const List<String> _avatarEmojis = [
  '🧩', '💬', '🖐️', '⭐', '🌟', '🧒', '🧑', '👩', '👨', '🦋',
  '🌈', '🎨', '🐬', '🌺', '⚡', '🎯', '🎵', '🌙', '☀️', '🦁',
];

// ---------------------------------------------------------------------------
// ProfilesScreen
// ---------------------------------------------------------------------------

class ProfilesScreen extends ConsumerWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(allProfilesProvider);
    final currentId = ref.watch(currentProfileIdProvider);
    

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Perfiles'),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, ref),
        backgroundColor: AppColors.inkTeal,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo perfil'),
      ),
      body: profiles.isEmpty
          ? const _EmptyState()
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];
                final isActive = profile.isDefault ||
                    profile.id == (currentId ?? profiles.first.id);
                return ProfileCard(
                  profile: profile,
                  isActive: isActive,
                  onTap: () {
                    ref
                        .read(profilesNotifierProvider.notifier)
                        .setActiveProfile(profile.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Perfil activo: ${profile.name}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  onLongPress: () =>
                      _showProfileMenu(context, ref, profile),
                );
              },
            ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => CreateProfileDialog(
        onCreated: (profile) {
          ref.read(profilesNotifierProvider.notifier).createProfile(profile);
        },
      ),
    );
  }

  void _showProfileMenu(
    BuildContext context,
    WidgetRef ref,
    ProfileEntity profile,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _ProfileContextMenu(
        profile: profile,
        onEdit: () {
          Navigator.of(ctx).pop();
          // Show edit dialog (reuse create dialog with pre-filled values)
          showDialog(
            context: context,
            builder: (_) => CreateProfileDialog(
              initialProfile: profile,
              onCreated: (updated) {
                ref
                    .read(profilesNotifierProvider.notifier)
                    .updateProfile(updated.copyWith(id: profile.id));
              },
            ),
          );
        },
        onDuplicate: () {
          Navigator.of(ctx).pop();
          ref
              .read(profilesNotifierProvider.notifier)
              .duplicateProfile(profile.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Perfil "${profile.name}" duplicado')),
          );
        },
        onExport: () {
          Navigator.of(ctx).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Exportación de perfil — próximamente')),
          );
        },
        onDelete: () {
          Navigator.of(ctx).pop();
          showDialog(
            context: context,
            builder: (_) => DeleteProfileConfirmDialog(
              profile: profile,
              onConfirm: () {
                ref
                    .read(profilesNotifierProvider.notifier)
                    .deleteProfile(profile.id);
              },
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ProfileCard
// ---------------------------------------------------------------------------

class ProfileCard extends StatelessWidget {
  final ProfileEntity profile;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.isActive,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppColors.inkTeal : AppColors.divider,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.inkTeal.withValues(alpha: 0.15),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.inkTeal.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        profile.avatarEmoji ?? '🧑',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  if (isActive)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: AppColors.inkTeal,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                profile.name,
                style: AppTypography.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Diagnosis chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Text(
                  _diagnosisLabels[profile.diagnosis] ?? profile.diagnosis,
                  style: const TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 11,
                    color: AppColors.grey600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // Active badge
              if (isActive)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.inkTeal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Activo',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 11,
                      color: AppColors.inkTeal,
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
// CreateProfileDialog
// ---------------------------------------------------------------------------

class CreateProfileDialog extends StatefulWidget {
  final ProfileEntity? initialProfile;
  final void Function(ProfileEntity) onCreated;

  const CreateProfileDialog({
    super.key,
    this.initialProfile,
    required this.onCreated,
  });

  @override
  State<CreateProfileDialog> createState() => _CreateProfileDialogState();
}

class _CreateProfileDialogState extends State<CreateProfileDialog> {
  late TextEditingController _nameController;
  late String _diagnosis;
  late String _disposition;
  late int _gridSize;
  late String _language;
  late String _avatar;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    _nameController = TextEditingController(text: p?.name ?? '');
    _diagnosis = p?.diagnosis ?? 'child';
    _disposition = p?.disposition ?? 'pictograms';
    _gridSize = p?.gridSize ?? 15;
    _language = p?.language ?? 'es-MX';
    _avatar = p?.avatarEmoji ?? '🧒';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialProfile != null;

    return AlertDialog(
      title: Text(isEditing ? 'Editar perfil' : 'Nuevo perfil'),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar picker
            Center(
              child: GestureDetector(
                onTap: _pickAvatar,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: Text(
                      _avatar,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                'Toca para cambiar',
                style: TextStyle(fontSize: 11, color: AppColors.grey400),
              ),
            ),
            const SizedBox(height: 16),

            // Name field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del perfil',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Diagnosis selector
            _SectionLabel('Diagnóstico'),
            const SizedBox(height: 8),
            _DropdownField<String>(
              value: _diagnosis,
              items: _diagnosisLabels.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _diagnosis = v!),
            ),
            const SizedBox(height: 16),

            // Disposition selector
            _SectionLabel('Modo de comunicación'),
            const SizedBox(height: 8),
            _DropdownField<String>(
              value: _disposition,
              items: _dispositionLabels.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _disposition = v!),
            ),
            const SizedBox(height: 16),

            // Grid size slider
            _SectionLabel('Tamaño de cuadrícula: $_gridSize botones'),
            Slider(
              value: _gridSize.toDouble(),
              min: 4,
              max: 90,
              divisions: 5,
              label: '$_gridSize',
              activeColor: AppColors.inkTeal,
              onChanged: (v) {
                final snapped = _snapGridSize(v.round());
                setState(() => _gridSize = snapped);
              },
            ),

            // Language selector
            _SectionLabel('Idioma'),
            const SizedBox(height: 8),
            _DropdownField<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'es-MX', child: Text('Español (México)')),
                DropdownMenuItem(value: 'es-ES', child: Text('Español (España)')),
                DropdownMenuItem(value: 'en-US', child: Text('English (US)')),
                DropdownMenuItem(value: 'pt-BR', child: Text('Português (Brasil)')),
              ],
              onChanged: (v) => setState(() => _language = v!),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) return;
            final now = DateTime.now();
            final profile = ProfileEntity(
              id: widget.initialProfile?.id ?? const Uuid().v4(),
              name: name,
              avatarEmoji: _avatar,
              diagnosis: _diagnosis,
              disposition: _disposition,
              gridSize: _gridSize,
              language: _language,
              vocabularyType: 'core_first',
              isDefault: widget.initialProfile?.isDefault ?? false,
              createdAt: widget.initialProfile?.createdAt ?? now,
              updatedAt: now,
            );
            widget.onCreated(profile);
            Navigator.of(context).pop();
          },
          child: Text(isEditing ? 'Guardar' : 'Crear'),
        ),
      ],
    );
  }

  int _snapGridSize(int value) {
    const options = [4, 8, 15, 30, 60, 90];
    return options.reduce((a, b) =>
        (value - a).abs() < (value - b).abs() ? a : b);
  }

  void _pickAvatar() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Elige un avatar'),
        content: SizedBox(
          width: 300,
          child: GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: _avatarEmojis.map((emoji) {
              return GestureDetector(
                onTap: () {
                  setState(() => _avatar = emoji);
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _avatar == emoji
                        ? AppColors.inkTeal.withValues(alpha: 0.1)
                        : AppColors.grey100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _avatar == emoji
                          ? AppColors.inkTeal
                          : AppColors.divider,
                    ),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DeleteProfileConfirmDialog
// ---------------------------------------------------------------------------

class DeleteProfileConfirmDialog extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onConfirm;

  const DeleteProfileConfirmDialog({
    super.key,
    required this.profile,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning_rounded, color: AppColors.error, size: 24),
          SizedBox(width: 10),
          Text('Eliminar perfil'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: AppTypography.textTheme.bodyLarge,
              children: [
                const TextSpan(text: '¿Seguro que deseas eliminar el perfil '),
                TextSpan(
                  text: '"${profile.name}"',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: '?'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Se eliminará de forma permanente:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          ...[
            'Todos los tableros de este perfil',
            'Vocabulario personalizado',
            'Historial de mensajes',
            'Frases guardadas',
            'Datos de uso y progreso',
          ].map(
            (item) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.remove_circle_outline,
                    size: 14,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.error),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Esta acción no se puede deshacer.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Profile context menu
// ---------------------------------------------------------------------------

class _ProfileContextMenu extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onExport;
  final VoidCallback onDelete;

  const _ProfileContextMenu({
    required this.profile,
    required this.onEdit,
    required this.onDuplicate,
    required this.onExport,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
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

          // Profile name header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  profile.avatarEmoji ?? '🧑',
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 10),
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const Divider(height: 16),

          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Editar perfil'),
            onTap: onEdit,
          ),
          ListTile(
            leading: const Icon(Icons.copy_outlined),
            title: const Text('Duplicar perfil'),
            onTap: onDuplicate,
          ),
          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: const Text('Exportar perfil'),
            onTap: onExport,
          ),
          if (!profile.isDefault)
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
              ),
              title: const Text(
                'Eliminar perfil',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: onDelete,
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small helpers
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.textTheme.labelMedium?.copyWith(
        color: AppColors.grey600,
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          style: AppTypography.textTheme.bodyMedium,
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
          Icon(Icons.person_off_outlined, size: 64, color: AppColors.grey300),
          const SizedBox(height: 16),
          const Text(
            'Sin perfiles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crea un perfil para empezar a comunicar',
            style: TextStyle(fontSize: 13, color: AppColors.grey400),
          ),
        ],
      ),
    );
  }
}

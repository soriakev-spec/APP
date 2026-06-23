import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/state/providers/profile_provider.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class _ReportsState {
  const _ReportsState({
    required this.sections,
    required this.startDate,
    required this.endDate,
  });

  final Map<String, bool> sections;
  final DateTime startDate;
  final DateTime endDate;

  _ReportsState copyWith({
    Map<String, bool>? sections,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _ReportsState(
      sections: sections ?? this.sections,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class _ReportsNotifier extends StateNotifier<_ReportsState> {
  _ReportsNotifier()
      : super(_ReportsState(
          sections: {
            'Resumen ejecutivo': true,
            'Vocabulario': true,
            'Progreso': true,
            'Gráficas': false,
            'Metas': true,
            'Recomendaciones': false,
          },
          startDate: DateTime.now().subtract(const Duration(days: 28)),
          endDate: DateTime.now(),
        ));

  void toggleSection(String key) {
    final updated = Map<String, bool>.from(state.sections);
    updated[key] = !(updated[key] ?? false);
    state = state.copyWith(sections: updated);
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }
}

final _reportsProvider =
    StateNotifierProvider<_ReportsNotifier, _ReportsState>((_) => _ReportsNotifier());

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileDataProvider);
    final state = ref.watch(_reportsProvider);
    final notifier = ref.read(_reportsProvider.notifier);
    final theme = Theme.of(context);
    final fmt = DateFormat('dd MMM yyyy', 'es');

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generador de Reportes',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.inkTeal,
                        ),
                      ),
                      Text(
                        profile?.name ?? 'Perfil',
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey600),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.description_rounded, color: AppColors.inkTeal, size: 32),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Date range
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Período del reporte',
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _DateButton(
                                label: 'Desde',
                                date: state.startDate,
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: state.startDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    notifier.setDateRange(picked, state.endDate);
                                  }
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.arrow_forward_rounded, color: AppColors.grey400),
                            ),
                            Expanded(
                              child: _DateButton(
                                label: 'Hasta',
                                date: state.endDate,
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: state.endDate,
                                    firstDate: state.startDate,
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    notifier.setDateRange(state.startDate, picked);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Section toggles
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Secciones a incluir',
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        ...state.sections.entries.map((entry) => SwitchListTile(
                              title: Text(entry.key),
                              value: entry.value,
                              activeThumbColor: AppColors.inkTeal,
                              onChanged: (_) => notifier.toggleSection(entry.key),
                              contentPadding: EdgeInsets.zero,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Preview
                Text('Vista previa',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                _ReportPreview(
                  profileName: profile?.name ?? 'Perfil',
                  startDate: fmt.format(state.startDate),
                  endDate: fmt.format(state.endDate),
                  sections: state.sections,
                ),
                const SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showExportPdfDialog(context),
                        icon: const Icon(Icons.picture_as_pdf_rounded),
                        label: const Text('Exportar PDF'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Compartiendo reporte...')),
                          );
                        },
                        icon: const Icon(Icons.share_rounded),
                        label: const Text('Compartir'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copia de seguridad en la nube completada')),
                    );
                  },
                  icon: const Icon(Icons.cloud_upload_rounded),
                  label: const Text('Copia de seguridad en la nube'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
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

  void _showExportPdfDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.picture_as_pdf_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text('Exportar PDF'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('El reporte se generará con las secciones seleccionadas.'),
            SizedBox(height: 12),
            _InfoRow(icon: Icons.check_rounded, text: 'Formato profesional A4'),
            _InfoRow(icon: Icons.check_rounded, text: 'Gráficas en alta resolución'),
            _InfoRow(icon: Icons.check_rounded, text: 'Logo institucional incluido'),
            _InfoRow(icon: Icons.check_rounded, text: 'Compatible con lectores de PDF'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generando PDF...')),
              );
            },
            child: const Text('Generar PDF'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.success),
          const SizedBox(width: 8),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Date button
// ---------------------------------------------------------------------------

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.grey500),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(fontSize: 10, color: AppColors.grey500)),
                  Text(fmt.format(date),
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inkTeal)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Report preview
// ---------------------------------------------------------------------------

class _ReportPreview extends StatelessWidget {
  const _ReportPreview({
    required this.profileName,
    required this.startDate,
    required this.endDate,
    required this.sections,
  });

  final String profileName;
  final String startDate;
  final String endDate;
  final Map<String, bool> sections;

  @override
  Widget build(BuildContext context) {
    final enabledSections = sections.entries.where((e) => e.value).map((e) => e.key).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Document header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.inkTeal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('H',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Habla AAC',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.inkTeal,
                            )),
                    Text('Reporte de progreso',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey600,
                            )),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),

            // Profile and date
            Text('Perfil: $profileName',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            Text('Período: $startDate — $endDate',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey600)),

            const SizedBox(height: 16),

            // Enabled sections preview
            if (enabledSections.isEmpty)
              const Text('Selecciona al menos una sección para vista previa.')
            else
              ...enabledSections.map((section) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(section,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.inkTeal,
                                )),
                        const SizedBox(height: 4),
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.grey200,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 6,
                          width: double.infinity * 0.7,
                          decoration: BoxDecoration(
                            color: AppColors.grey200,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 6,
                          width: 120,
                          decoration: BoxDecoration(
                            color: AppColors.grey200,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

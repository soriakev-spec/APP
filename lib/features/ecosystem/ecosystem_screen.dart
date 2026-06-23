import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:habla/core/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

class _Automation {
  const _Automation({
    required this.id,
    required this.trigger,
    required this.action,
    this.enabled = true,
  });

  final String id;
  final String trigger;
  final String action;
  final bool enabled;
}

class _Integration {
  const _Integration({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  final String id;
  final String name;
  final IconData icon;
  final String description;
}

class _MarketplaceItem {
  const _MarketplaceItem({
    required this.id,
    required this.name,
    required this.author,
    required this.rating,
    required this.downloads,
    required this.price,
    required this.type,
  });

  final String id;
  final String name;
  final String author;
  final double rating;
  final int downloads;
  final String price;
  final String type;
}

class _Milestone {
  const _Milestone({
    required this.id,
    required this.date,
    required this.description,
    required this.category,
    required this.color,
  });

  final String id;
  final String date;
  final String description;
  final String category;
  final Color color;
}

// ---------------------------------------------------------------------------
// Dummy data
// ---------------------------------------------------------------------------

const _automations = [
  _Automation(
    id: 'a1',
    trigger: 'Si es 8:00am',
    action: 'Mostrar rutina de mañana',
  ),
  _Automation(
    id: 'a2',
    trigger: 'Si la ubicación es "escuela"',
    action: 'Activar tablero escolar',
  ),
  _Automation(
    id: 'a3',
    trigger: 'Si es viernes 15:00',
    action: 'Enviar resumen semanal a familia',
  ),
  _Automation(
    id: 'a4',
    trigger: 'Si la batería < 20%',
    action: 'Mostrar aviso de batería baja',
    enabled: false,
  ),
];

const _integrations = [
  _Integration(id: 'i1', name: 'Google Calendar', icon: Icons.calendar_today_rounded, description: 'Sincronizar citas y rutinas'),
  _Integration(id: 'i2', name: 'Alexa', icon: Icons.mic_rounded, description: 'Control por voz con Amazon Alexa'),
  _Integration(id: 'i3', name: 'WhatsApp', icon: Icons.message_rounded, description: 'Compartir frases por WhatsApp'),
  _Integration(id: 'i4', name: 'HomeKit', icon: Icons.home_rounded, description: 'Automatización del hogar de Apple'),
  _Integration(id: 'i5', name: 'Email', icon: Icons.email_rounded, description: 'Enviar reportes por correo'),
  _Integration(id: 'i6', name: 'Zapier', icon: Icons.hub_rounded, description: 'Conectar con miles de apps'),
];

const _marketplace = [
  _MarketplaceItem(id: 'm1', name: 'Tablero Escolar Completo', author: 'Habla Team', rating: 4.8, downloads: 1240, price: 'Gratis', type: 'Tablero'),
  _MarketplaceItem(id: 'm2', name: 'Pack Emociones Básicas', author: 'Terapeuta Laura M.', rating: 4.9, downloads: 2100, price: 'Gratis', type: 'Pack de frases'),
  _MarketplaceItem(id: 'm3', name: 'Actividades de Navidad', author: 'Comunidad Habla', rating: 4.5, downloads: 830, price: 'Gratis', type: 'Actividades'),
  _MarketplaceItem(id: 'm4', name: 'Vocabulario Médico', author: 'Dr. Ramírez AAC', rating: 4.7, downloads: 560, price: 'Premium', type: 'Tablero'),
  _MarketplaceItem(id: 'm5', name: 'Rutinas Adultos ELA', author: 'Habla Team', rating: 4.6, downloads: 450, price: 'Premium', type: 'Tablero'),
  _MarketplaceItem(id: 'm6', name: 'Juegos de Vocabulario', author: 'Educa AAC', rating: 4.4, downloads: 980, price: 'Gratis', type: 'Actividades'),
];

const _milestones = [
  _Milestone(id: 'ms1', date: '15 ene 2024', description: 'Primera palabra comunicada: "más"', category: 'Hito', color: AppColors.inkTeal),
  _Milestone(id: 'ms2', date: '3 feb 2024', description: 'Primeras 10 palabras activas en vocabulario', category: 'Vocabulario', color: AppColors.fitzVerbs),
  _Milestone(id: 'ms3', date: '20 feb 2024', description: 'Primera frase de 2 palabras: "quiero agua"', category: 'Frases', color: AppColors.fitzNouns),
  _Milestone(id: 'ms4', date: '8 mar 2024', description: 'Uso independiente del dispositivo por primera vez', category: 'Autonomía', color: AppColors.aiViolet),
  _Milestone(id: 'ms5', date: '22 mar 2024', description: '50 palabras en vocabulario activo', category: 'Vocabulario', color: AppColors.fitzVerbs),
  _Milestone(id: 'ms6', date: '10 abr 2024', description: 'Primera frase de 3 palabras: "yo quiero jugar"', category: 'Frases', color: AppColors.fitzNouns),
  _Milestone(id: 'ms7', date: '5 may 2024', description: 'Comunicación espontánea sin indicación', category: 'Autonomía', color: AppColors.aiViolet),
];

// ---------------------------------------------------------------------------
// Automation state
// ---------------------------------------------------------------------------

final _automationEnabledProvider =
    StateProvider<Map<String, bool>>((_) => {
  for (final a in _automations) a.id: a.enabled,
});

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class EcosystemScreen extends ConsumerStatefulWidget {
  const EcosystemScreen({super.key});

  @override
  ConsumerState<EcosystemScreen> createState() => _EcosystemScreenState();
}

class _EcosystemScreenState extends ConsumerState<EcosystemScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ecosistema',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkTeal,
                  ),
                ),
                const SizedBox(height: 12),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: const [
                    Tab(text: 'Automatizaciones'),
                    Tab(text: 'Integraciones'),
                    Tab(text: 'Marketplace'),
                    Tab(text: 'Línea de tiempo'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _AutomationsTab(),
                _IntegrationsTab(),
                _MarketplaceTab(),
                _TimelineTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Automations tab
// ---------------------------------------------------------------------------

class _AutomationsTab extends ConsumerWidget {
  const _AutomationsTab();

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nueva automatización'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('El creador visual de automatizaciones estará disponible próximamente.'),
            SizedBox(height: 8),
            Text(
              'Podrás crear reglas del tipo:\n"Si [condición] → Entonces [acción]"',
              style: TextStyle(color: AppColors.grey600),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabledMap = ref.watch(_automationEnabledProvider);
    final notifier = ref.read(_automationEnabledProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        backgroundColor: AppColors.inkTeal,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _automations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final auto = _automations[index];
          final isEnabled = enabledMap[auto.id] ?? auto.enabled;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _IfThenRow(prefix: 'SI', text: auto.trigger, color: AppColors.inkTeal),
                            const SizedBox(height: 6),
                            _IfThenRow(prefix: 'ENTONCES', text: auto.action, color: AppColors.fitzVerbs),
                          ],
                        ),
                      ),
                      Switch(
                        value: isEnabled,
                        activeColor: AppColors.inkTeal,
                        onChanged: (v) {
                          notifier.update((state) => {...state, auto.id: v});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ejecutando: ${auto.action}')),
                          );
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 16),
                        label: const Text('Ejecutar ahora'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: const Size(0, 32),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _IfThenRow extends StatelessWidget {
  const _IfThenRow({required this.prefix, required this.text, required this.color});

  final String prefix;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(prefix,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700, color: color)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Integrations tab
// ---------------------------------------------------------------------------

class _IntegrationsTab extends StatelessWidget {
  const _IntegrationsTab();

  void _showConnectDialog(BuildContext context, _Integration integration) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(integration.icon, color: AppColors.inkTeal),
            const SizedBox(width: 8),
            Text('Conectar ${integration.name}'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(integration.description),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.schedule_rounded, color: AppColors.warning, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Próximamente disponible',
                      style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.w600),
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
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: _integrations.length,
      itemBuilder: (context, index) {
        final integration = _integrations[index];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showConnectDialog(context, integration),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(integration.icon, size: 36, color: AppColors.inkTeal),
                  const SizedBox(height: 8),
                  Text(
                    integration.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Próximamente',
                      style: TextStyle(
                          fontSize: 9,
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Marketplace tab
// ---------------------------------------------------------------------------

class _MarketplaceTab extends StatefulWidget {
  const _MarketplaceTab();

  @override
  State<_MarketplaceTab> createState() => _MarketplaceTabState();
}

class _MarketplaceTabState extends State<_MarketplaceTab> {
  String _filter = 'Todos';

  static const _filters = ['Todos', 'Gratis', 'Premium', 'Tableros', 'Actividades'];

  @override
  Widget build(BuildContext context) {
    final filtered = _marketplace.where((item) {
      if (_filter == 'Todos') return true;
      if (_filter == 'Gratis') return item.price == 'Gratis';
      if (_filter == 'Premium') return item.price == 'Premium';
      return item.type.toLowerCase().contains(_filter.toLowerCase());
    }).toList();

    return Column(
      children: [
        // Filter row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: _filters.map((f) {
              final selected = f == _filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(f),
                  selected: selected,
                  onSelected: (_) => setState(() => _filter = f),
                  selectedColor: AppColors.inkTeal.withValues(alpha: 0.12),
                  checkmarkColor: AppColors.inkTeal,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.inkTeal : AppColors.grey600,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];
              return _MarketplaceCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class _MarketplaceCard extends StatelessWidget {
  const _MarketplaceCard({required this.item});

  final _MarketplaceItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail placeholder
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.inkTeal.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  item.type == 'Tablero'
                      ? Icons.grid_view_rounded
                      : item.type == 'Actividades'
                          ? Icons.school_rounded
                          : Icons.format_quote_rounded,
                  color: AppColors.inkTeal,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Price badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: item.price == 'Gratis' ? AppColors.successLight : AppColors.aiVioletLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.price,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: item.price == 'Gratis' ? AppColors.success : AppColors.aiViolet,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            Text(
              item.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              item.author,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grey500, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 12, color: AppColors.fitzNouns),
                const SizedBox(width: 2),
                Text(item.rating.toString(),
                    style: const TextStyle(fontSize: 10, color: AppColors.grey600)),
                const SizedBox(width: 6),
                const Icon(Icons.download_rounded, size: 11, color: AppColors.grey400),
                const SizedBox(width: 2),
                Text('${item.downloads}',
                    style: const TextStyle(fontSize: 10, color: AppColors.grey400)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Descargando "${item.name}"...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  minimumSize: const Size(0, 28),
                  textStyle: const TextStyle(fontSize: 11),
                ),
                child: const Text('Descargar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Language timeline tab
// ---------------------------------------------------------------------------

class _TimelineTab extends StatelessWidget {
  const _TimelineTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _milestones.length,
      itemBuilder: (context, index) {
        final milestone = _milestones[index];
        final isLast = index == _milestones.length - 1;
        return _TimelineItem(
          milestone: milestone,
          isLast: isLast,
        );
      },
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.milestone, required this.isLast});

  final _Milestone milestone;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: milestone.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [BoxShadow(color: milestone.color.withValues(alpha: 0.4), blurRadius: 6)],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.divider,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: milestone.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              milestone.category,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: milestone.color,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            milestone.date,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.grey500,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(milestone.description, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

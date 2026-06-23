import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/widgets/dialogs/input_dialog.dart';

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

class _Symbol {
  const _Symbol({required this.id, required this.name, this.imageUrl});

  final String id;
  final String name;
  final String? imageUrl;
}

class _Collection {
  const _Collection({required this.id, required this.name, required this.count});

  final String id;
  final String name;
  final int count;
}

// ---------------------------------------------------------------------------
// Dummy data provider
// ---------------------------------------------------------------------------

final _symbolSearchQueryProvider = StateProvider<String>((_) => '');

final _symbolResultsProvider = Provider<List<_Symbol>>((ref) {
  final query = ref.watch(_symbolSearchQueryProvider);
  if (query.isEmpty) {
    return const [
      _Symbol(id: '1', name: 'comer'),
      _Symbol(id: '2', name: 'beber'),
      _Symbol(id: '3', name: 'dormir'),
      _Symbol(id: '4', name: 'jugar'),
      _Symbol(id: '5', name: 'ir'),
      _Symbol(id: '6', name: 'ver'),
      _Symbol(id: '7', name: 'querer'),
      _Symbol(id: '8', name: 'ayudar'),
      _Symbol(id: '9', name: 'más'),
      _Symbol(id: '10', name: 'no'),
      _Symbol(id: '11', name: 'sí'),
      _Symbol(id: '12', name: 'parar'),
    ];
  }
  return [
    _Symbol(id: 'q1', name: query),
    _Symbol(id: 'q2', name: '$query 2'),
    _Symbol(id: 'q3', name: '$query 3'),
  ];
});

final _favoritesProvider = StateProvider<Set<String>>((_) => {'1', '4', '9'});

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    Tab(text: 'ARASAAC'),
    Tab(text: 'Fotos'),
    Tab(icon: Icon(Icons.gif_box_rounded, size: 18)),
    Tab(icon: Icon(Icons.videocam_rounded, size: 18)),
    Tab(icon: Icon(Icons.music_note_rounded, size: 18)),
    Tab(icon: Icon(Icons.star_rounded, size: 18)),
    Tab(text: 'Colecciones'),
    Tab(text: 'Recientes'),
    Tab(text: 'Más usados'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAIGenerationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome_rounded, color: AppColors.aiViolet),
            SizedBox(width: 8),
            Text('Generación IA de símbolos'),
          ],
        ),
        content: const Text(
          'La generación de símbolos con Inteligencia Artificial estará disponible próximamente.\n\nPodrás crear símbolos personalizados con solo describir lo que necesitas.',
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Biblioteca de Medios',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkTeal,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _showAIGenerationDialog,
                      icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                      label: const Text('Generar con IA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.aiViolet,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        minimumSize: const Size(0, 40),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: _tabs,
                ),
              ],
            ),
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ArasaacTab(onGenerateAI: _showAIGenerationDialog),
                _PhotosTab(onGenerateAI: _showAIGenerationDialog),
                _MediaStubTab(label: 'GIF', icon: Icons.gif_box_rounded, onGenerateAI: _showAIGenerationDialog),
                _MediaStubTab(label: 'Video', icon: Icons.videocam_rounded, onGenerateAI: _showAIGenerationDialog),
                _MediaStubTab(label: 'Audio', icon: Icons.music_note_rounded, onGenerateAI: _showAIGenerationDialog),
                _FavoritesTab(onGenerateAI: _showAIGenerationDialog),
                _CollectionsTab(onGenerateAI: _showAIGenerationDialog),
                _RecentlyUsedTab(onGenerateAI: _showAIGenerationDialog),
                _MostUsedTab(onGenerateAI: _showAIGenerationDialog),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ARASAAC tab
// ---------------------------------------------------------------------------

class _ArasaacTab extends ConsumerStatefulWidget {
  const _ArasaacTab({required this.onGenerateAI});

  final VoidCallback onGenerateAI;

  @override
  ConsumerState<_ArasaacTab> createState() => _ArasaacTabState();
}

class _ArasaacTabState extends ConsumerState<_ArasaacTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSymbolSheet(BuildContext context, _Symbol symbol) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _SymbolPlaceholder(name: symbol.name, size: 80),
                  const SizedBox(height: 12),
                  Text(symbol.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.grid_view_rounded, color: AppColors.inkTeal),
              title: const Text('Usar en tablero'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${symbol.name}" agregado al tablero')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_rounded, color: AppColors.fitzNouns),
              title: const Text('Agregar a colección'),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (_) => InputDialog(
                    title: 'Agregar a colección',
                    hint: 'Nombre de la colección',
                    confirmLabel: 'Agregar',
                    onConfirm: (name) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Agregado a "$name"')),
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_rounded, color: AppColors.fitzNouns),
              title: const Text('Marcar favorito'),
              onTap: () {
                Navigator.of(context).pop();
                ref.read(_favoritesProvider.notifier).update((s) => {...s, symbol.id});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${symbol.name}" marcado como favorito')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final symbols = ref.watch(_symbolResultsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Buscar en ARASAAC...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: (v) {
              ref.read(_symbolSearchQueryProvider.notifier).state = v;
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: symbols.length,
            itemBuilder: (context, index) {
              final symbol = symbols[index];
              return GestureDetector(
                onTap: () => _showSymbolSheet(context, symbol),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: _SymbolPlaceholder(name: symbol.name, size: 60)),
                        const SizedBox(height: 6),
                        Text(
                          symbol.name,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Photos tab
// ---------------------------------------------------------------------------

class _PhotosTab extends StatelessWidget {
  const _PhotosTab({required this.onGenerateAI});

  final VoidCallback onGenerateAI;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Abriendo galería...')),
          );
        },
        backgroundColor: AppColors.inkTeal,
        child: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_library_rounded, size: 64, color: AppColors.grey300),
            const SizedBox(height: 16),
            Text(
              'Toca + para agregar fotos',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onGenerateAI,
              icon: const Icon(Icons.auto_awesome_rounded, size: 16),
              label: const Text('Generar con IA'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Media stub tab
// ---------------------------------------------------------------------------

class _MediaStubTab extends StatelessWidget {
  const _MediaStubTab({
    required this.label,
    required this.icon,
    required this.onGenerateAI,
  });

  final String label;
  final IconData icon;
  final VoidCallback onGenerateAI;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.grey300),
          const SizedBox(height: 16),
          Text(
            'Sin $label todavía',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onGenerateAI,
            icon: const Icon(Icons.auto_awesome_rounded, size: 16),
            label: const Text('Generar con IA'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Favorites tab
// ---------------------------------------------------------------------------

class _FavoritesTab extends ConsumerWidget {
  const _FavoritesTab({required this.onGenerateAI});

  final VoidCallback onGenerateAI;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(_favoritesProvider);
    const allSymbols = [
      _Symbol(id: '1', name: 'comer'),
      _Symbol(id: '2', name: 'beber'),
      _Symbol(id: '3', name: 'dormir'),
      _Symbol(id: '4', name: 'jugar'),
      _Symbol(id: '9', name: 'más'),
    ];
    final favSymbols = allSymbols.where((s) => favorites.contains(s.id)).toList();

    if (favSymbols.isEmpty) {
      return _MediaStubTab(label: 'favoritos', icon: Icons.star_rounded, onGenerateAI: onGenerateAI);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: favSymbols.length,
      itemBuilder: (context, index) {
        final s = favSymbols[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _SymbolPlaceholder(name: s.name, size: 60)),
                const SizedBox(height: 6),
                Text(s.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Collections tab
// ---------------------------------------------------------------------------

class _CollectionsTab extends StatelessWidget {
  const _CollectionsTab({required this.onGenerateAI});

  final VoidCallback onGenerateAI;

  static const _collections = [
    _Collection(id: '1', name: 'Rutinas del hogar', count: 12),
    _Collection(id: '2', name: 'Alimentos', count: 28),
    _Collection(id: '3', name: 'Animales', count: 34),
    _Collection(id: '4', name: 'Emociones', count: 8),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _collections.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final col = _collections[index];
        return Card(
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.inkTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.folder_rounded, color: AppColors.inkTeal),
            ),
            title: Text(col.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${col.count} símbolos'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.grey400),
            onTap: () {},
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Recently used tab
// ---------------------------------------------------------------------------

class _RecentlyUsedTab extends StatelessWidget {
  const _RecentlyUsedTab({required this.onGenerateAI});

  final VoidCallback onGenerateAI;

  static const _recent = [
    _Symbol(id: 'r1', name: 'agua'),
    _Symbol(id: 'r2', name: 'jugar'),
    _Symbol(id: 'r3', name: 'más'),
    _Symbol(id: 'r4', name: 'no'),
    _Symbol(id: 'r5', name: 'comer'),
    _Symbol(id: 'r6', name: 'música'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: _recent.length,
      itemBuilder: (context, index) {
        final s = _recent[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _SymbolPlaceholder(name: s.name, size: 60)),
                const SizedBox(height: 6),
                Text(s.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Most used tab
// ---------------------------------------------------------------------------

class _MostUsedTab extends StatelessWidget {
  const _MostUsedTab({required this.onGenerateAI});

  final VoidCallback onGenerateAI;

  static const _mostUsed = [
    (symbol: _Symbol(id: 'm1', name: 'más'), count: 142),
    (symbol: _Symbol(id: 'm2', name: 'no'), count: 118),
    (symbol: _Symbol(id: 'm3', name: 'quiero'), count: 97),
    (symbol: _Symbol(id: 'm4', name: 'jugar'), count: 84),
    (symbol: _Symbol(id: 'm5', name: 'comer'), count: 76),
    (symbol: _Symbol(id: 'm6', name: 'agua'), count: 65),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _mostUsed.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = _mostUsed[index];
        final fraction = item.count / _mostUsed.first.count;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text('${index + 1}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: index == 0
                            ? AppColors.fitzNouns
                            : AppColors.grey400)),
                const SizedBox(width: 12),
                _SymbolPlaceholder(name: item.symbol.name, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.symbol.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: fraction,
                          minHeight: 6,
                          backgroundColor: AppColors.grey200,
                          valueColor: const AlwaysStoppedAnimation(AppColors.inkTeal),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text('${item.count}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: AppColors.grey600)),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Symbol placeholder widget
// ---------------------------------------------------------------------------

class _SymbolPlaceholder extends StatelessWidget {
  const _SymbolPlaceholder({required this.name, required this.size});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.inkTeal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w700,
            color: AppColors.inkTeal.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

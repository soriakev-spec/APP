// Phrases screen — library of phrases for the current profile.
// Tabs: Explorar | Favoritas | Frecuentes | Sugeridas IA | Mis frases | Constructor

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/phrase.dart';
import '../../state/providers/profile_provider.dart';
import '../../state/providers/communicate_provider.dart';

// ---------------------------------------------------------------------------
// Phrase providers (in-memory stubs)
// ---------------------------------------------------------------------------

final allPhrasesProvider = StateNotifierProvider<PhrasesNotifier, List<Phrase>>(
    (ref) => PhrasesNotifier());

class PhrasesNotifier extends StateNotifier<List<Phrase>> {
  PhrasesNotifier() : super(_seed());

  static List<Phrase> _seed() {
    const uuid = Uuid();
    return [
      Phrase(
        id: uuid.v4(),
        text: 'Quiero ir al baño',
        context: 'Casa',
        ageGroup: AgeGroup.child,
        level: PhraseLevel.phrase,
        isFavorite: true,
        usageCount: 12,
        isCustom: false,
      ),
      Phrase(
        id: uuid.v4(),
        text: 'Tengo hambre',
        context: 'Casa',
        ageGroup: AgeGroup.child,
        level: PhraseLevel.twoWords,
        isFavorite: true,
        usageCount: 20,
        isCustom: false,
      ),
      Phrase(
        id: uuid.v4(),
        text: 'Ayúdame por favor',
        context: 'Escuela',
        ageGroup: AgeGroup.child,
        level: PhraseLevel.phrase,
        isFavorite: false,
        usageCount: 8,
        isCustom: false,
      ),
      Phrase(
        id: uuid.v4(),
        text: 'Me duele la cabeza',
        context: 'Doctor',
        ageGroup: AgeGroup.teen,
        level: PhraseLevel.phrase,
        isFavorite: false,
        usageCount: 3,
        isCustom: false,
      ),
      Phrase(
        id: uuid.v4(),
        text: 'Quiero jugar',
        context: 'Casa',
        ageGroup: AgeGroup.child,
        level: PhraseLevel.twoWords,
        isFavorite: true,
        usageCount: 15,
        isCustom: false,
      ),
      Phrase(
        id: uuid.v4(),
        text: 'Necesito descansar',
        context: 'Casa',
        ageGroup: AgeGroup.adult,
        level: PhraseLevel.phrase,
        isFavorite: false,
        usageCount: 5,
        isCustom: false,
      ),
      Phrase(
        id: uuid.v4(),
        text: 'Buenos días',
        context: 'Escuela',
        ageGroup: AgeGroup.early,
        level: PhraseLevel.twoWords,
        isFavorite: false,
        usageCount: 30,
        isCustom: false,
      ),
      Phrase(
        id: uuid.v4(),
        text: 'No entiendo',
        context: 'Escuela',
        ageGroup: AgeGroup.child,
        level: PhraseLevel.twoWords,
        isFavorite: false,
        usageCount: 7,
        isCustom: false,
      ),
    ];
  }

  void toggleFavorite(String id) {
    state = state
        .map((p) => p.id == id ? p.copyWith(isFavorite: !p.isFavorite) : p)
        .toList();
  }

  void incrementUsage(String id) {
    state = state
        .map((p) =>
            p.id == id ? p.copyWith(usageCount: p.usageCount + 1) : p)
        .toList();
  }

  void addPhrase(Phrase phrase) {
    state = [...state, phrase];
  }

  void updatePhrase(Phrase phrase) {
    state = state.map((p) => p.id == phrase.id ? phrase : p).toList();
  }

  void deletePhrase(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}

// Phrase folder providers
final phraseFoldersProvider = StateProvider<List<_PhraseFolder>>((ref) => [
      const _PhraseFolder(id: 'default', name: 'General'),
      const _PhraseFolder(id: 'school', name: 'Escuela'),
      const _PhraseFolder(id: 'home', name: 'Casa'),
    ]);

class _PhraseFolder {
  final String id;
  final String name;

  const _PhraseFolder({required this.id, required this.name});
}

// Phrase constructor state
class _ConstructorState {
  final List<String> words;
  const _ConstructorState({this.words = const []});
}

final phraseConstructorProvider =
    StateNotifierProvider<_ConstructorNotifier, _ConstructorState>(
        (ref) => _ConstructorNotifier());

class _ConstructorNotifier extends StateNotifier<_ConstructorState> {
  _ConstructorNotifier() : super(const _ConstructorState());

  void addWord(String w) {
    state = _ConstructorState(words: [...state.words, w]);
  }

  void removeLast() {
    if (state.words.isEmpty) return;
    final words = [...state.words]..removeLast();
    state = _ConstructorState(words: words);
  }

  void clear() => state = const _ConstructorState();
}

// ---------------------------------------------------------------------------
// PhrasesScreen
// ---------------------------------------------------------------------------

class PhrasesScreen extends ConsumerStatefulWidget {
  const PhrasesScreen({super.key});

  @override
  ConsumerState<PhrasesScreen> createState() => _PhrasesScreenState();
}

class _PhrasesScreenState extends ConsumerState<PhrasesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  static const _tabs = [
    Tab(text: 'Explorar'),
    Tab(text: '⭐ Favoritas'),
    Tab(text: '🔥 Frecuentes'),
    Tab(text: '✦ Sugeridas IA'),
    Tab(text: '📝 Mis frases'),
    Tab(text: '🔨 Constructor'),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frases'),
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: const [
          _ExploreTab(),
          _FavoritesTab(),
          _FrequentTab(),
          _AiSuggestionsTab(),
          _MyPhrasesTab(),
          _ConstructorTab(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Explore Tab
// ---------------------------------------------------------------------------

class _ExploreTab extends ConsumerStatefulWidget {
  const _ExploreTab();

  @override
  ConsumerState<_ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends ConsumerState<_ExploreTab> {
  String _searchQuery = '';
  String? _contextFilter;
  AgeGroup? _ageFilter;
  PhraseLevel? _levelFilter;
  final TextEditingController _searchCtrl = TextEditingController();

  static const _contexts = ['Casa', 'Escuela', 'Doctor', 'Social', 'Trabajo'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phrases = ref.watch(allPhrasesProvider);
    final filtered = _filter(phrases);

    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Buscar frases…',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              isDense: true,
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),

        // Context chips
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            children: [
              _FilterChip(
                label: 'Todos',
                isSelected: _contextFilter == null,
                onTap: () => setState(() => _contextFilter = null),
              ),
              ..._contexts.map((c) => _FilterChip(
                    label: c,
                    isSelected: _contextFilter == c,
                    onTap: () => setState(() =>
                        _contextFilter = _contextFilter == c ? null : c),
                  )),
            ],
          ),
        ),

        // Age + Level chips
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            children: [
              _FilterChip(
                label: 'Temprana',
                isSelected: _ageFilter == AgeGroup.early,
                color: Colors.purple,
                onTap: () => setState(() => _ageFilter =
                    _ageFilter == AgeGroup.early ? null : AgeGroup.early),
              ),
              _FilterChip(
                label: 'Niño',
                isSelected: _ageFilter == AgeGroup.child,
                color: Colors.blue,
                onTap: () => setState(() => _ageFilter =
                    _ageFilter == AgeGroup.child ? null : AgeGroup.child),
              ),
              _FilterChip(
                label: 'Adolescente',
                isSelected: _ageFilter == AgeGroup.teen,
                color: Colors.teal,
                onTap: () => setState(() => _ageFilter =
                    _ageFilter == AgeGroup.teen ? null : AgeGroup.teen),
              ),
              _FilterChip(
                label: 'Adulto',
                isSelected: _ageFilter == AgeGroup.adult,
                color: Colors.indigo,
                onTap: () => setState(() => _ageFilter =
                    _ageFilter == AgeGroup.adult ? null : AgeGroup.adult),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: '1 pal.',
                isSelected: _levelFilter == PhraseLevel.oneWord,
                color: Colors.orange,
                onTap: () => setState(() => _levelFilter =
                    _levelFilter == PhraseLevel.oneWord
                        ? null
                        : PhraseLevel.oneWord),
              ),
              _FilterChip(
                label: '2 pal.',
                isSelected: _levelFilter == PhraseLevel.twoWords,
                color: Colors.deepOrange,
                onTap: () => setState(() => _levelFilter =
                    _levelFilter == PhraseLevel.twoWords
                        ? null
                        : PhraseLevel.twoWords),
              ),
              _FilterChip(
                label: 'Frase',
                isSelected: _levelFilter == PhraseLevel.phrase,
                color: Colors.red,
                onTap: () => setState(() => _levelFilter =
                    _levelFilter == PhraseLevel.phrase
                        ? null
                        : PhraseLevel.phrase),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Phrase list
        Expanded(
          child: filtered.isEmpty
              ? _buildEmpty()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) =>
                      PhraseCard(phrase: filtered[i]),
                ),
        ),
      ],
    );
  }

  List<Phrase> _filter(List<Phrase> all) {
    return all.where((p) {
      if (_searchQuery.isNotEmpty &&
          !p.text.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_contextFilter != null && p.context != _contextFilter) return false;
      if (_ageFilter != null && p.ageGroup != _ageFilter) return false;
      if (_levelFilter != null && p.level != _levelFilter) return false;
      return true;
    }).toList();
  }

  Widget _buildEmpty() {
    return const Center(
      child: Text(
        'No hay frases con los filtros seleccionados.',
        style: TextStyle(color: AppColors.grey500),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Favorites Tab
// ---------------------------------------------------------------------------

class _FavoritesTab extends ConsumerWidget {
  const _FavoritesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrases =
        ref.watch(allPhrasesProvider).where((p) => p.isFavorite).toList();

    if (phrases.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border, size: 48, color: AppColors.grey300),
            SizedBox(height: 12),
            Text('Aún no tienes frases favoritas.',
                style: TextStyle(color: AppColors.grey500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: phrases.length,
      itemBuilder: (ctx, i) => PhraseCard(phrase: phrases[i]),
    );
  }
}

// ---------------------------------------------------------------------------
// Frequent Tab
// ---------------------------------------------------------------------------

class _FrequentTab extends ConsumerWidget {
  const _FrequentTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrases = [...ref.watch(allPhrasesProvider)]
      ..sort((a, b) => b.usageCount.compareTo(a.usageCount));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: phrases.length,
      itemBuilder: (ctx, i) => PhraseCard(
        phrase: phrases[i],
        leadingBadge: '${i + 1}',
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AI Suggestions Tab
// ---------------------------------------------------------------------------

class _AiSuggestionsTab extends StatelessWidget {
  const _AiSuggestionsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.aiVioletLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 40, color: AppColors.aiViolet),
            ),
            const SizedBox(height: 20),
            Text(
              'Sugerencias IA',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'Conecta IA para recibir sugerencias de frases personalizadas basadas en el perfil y el contexto del usuario.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.aiViolet,
              ),
              icon: const Icon(Icons.link),
              label: const Text('Conectar IA'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// My Phrases Tab
// ---------------------------------------------------------------------------

class _MyPhrasesTab extends ConsumerStatefulWidget {
  const _MyPhrasesTab();

  @override
  ConsumerState<_MyPhrasesTab> createState() => _MyPhrasesTabState();
}

class _MyPhrasesTabState extends ConsumerState<_MyPhrasesTab> {
  String _selectedFolder = 'default';

  @override
  Widget build(BuildContext context) {
    final folders = ref.watch(phraseFoldersProvider);
    final profileId = ref.watch(currentProfileIdProvider);
    final myPhrases = ref
        .watch(allPhrasesProvider)
        .where((p) => p.isCustom && p.profileId == profileId)
        .toList();

    return Column(
      children: [
        // Folder row
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: folders
                .map((f) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f.name),
                        selected: _selectedFolder == f.id,
                        onSelected: (_) =>
                            setState(() => _selectedFolder = f.id),
                        selectedColor: AppColors.inkTeal,
                        labelStyle: TextStyle(
                          color: _selectedFolder == f.id
                              ? Colors.white
                              : AppColors.grey700,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        const Divider(height: 1),

        Expanded(
          child: myPhrases.isEmpty
              ? _buildEmpty(context)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: myPhrases.length,
                  itemBuilder: (ctx, i) => PhraseCard(
                    phrase: myPhrases[i],
                    showEditDelete: true,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.note_add_outlined, size: 48, color: AppColors.grey300),
          const SizedBox(height: 12),
          const Text(
            'No tienes frases personalizadas aún.',
            style: TextStyle(color: AppColors.grey500),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAddDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Agregar frase'),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final ctrl = TextEditingController();
    final profileId = ref.read(currentProfileIdProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva frase personalizada'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Escribe la frase…'),
          autofocus: true,
          maxLines: 2,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final text = ctrl.text.trim();
              if (text.isNotEmpty) {
                ref.read(allPhrasesProvider.notifier).addPhrase(Phrase(
                      id: const Uuid().v4(),
                      text: text,
                      context: 'Personal',
                      ageGroup: AgeGroup.adult,
                      level: PhraseLevel.phrase,
                      isFavorite: false,
                      usageCount: 0,
                      profileId: profileId,
                      isCustom: true,
                      folderId: _selectedFolder,
                    ));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Constructor Tab
// ---------------------------------------------------------------------------

class _ConstructorTab extends ConsumerWidget {
  const _ConstructorTab();

  static const _wordSets = {
    'Personas': ['yo', 'tú', 'él', 'mamá', 'papá', 'nosotros'],
    'Verbos': ['quiero', 'necesito', 'tengo', 'voy', 'puedo', 'siento'],
    'Sustantivos': ['agua', 'comida', 'baño', 'casa', 'escuela', 'juego'],
    'Descriptores': ['mucho', 'poco', 'bien', 'mal', 'grande', 'pequeño'],
    'Social': ['por favor', 'gracias', 'hola', 'adiós', 'sí', 'no'],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(phraseConstructorProvider);
    final notifier = ref.read(phraseConstructorProvider.notifier);
    final preview = state.words.join(' ');

    return Column(
      children: [
        // Preview bar
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  preview.isEmpty ? 'Toca palabras para construir una frase…' : preview,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: preview.isEmpty
                            ? AppColors.grey400
                            : AppColors.inkTeal,
                        fontWeight: preview.isEmpty
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                ),
              ),
              if (preview.isNotEmpty) ...[
                IconButton(
                  icon: const Icon(Icons.volume_up_outlined,
                      color: AppColors.inkTeal),
                  tooltip: 'Pronunciar',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pronunciando: $preview')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.backspace_outlined,
                      color: AppColors.grey500),
                  onPressed: () => notifier.removeLast(),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.error),
                  onPressed: () => notifier.clear(),
                ),
              ],
            ],
          ),
        ),

        // Word sets
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _wordSets.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style:
                          Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.grey500,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entry.value
                          .map((word) => ActionChip(
                                label: Text(word),
                                onPressed: () => notifier.addWord(word),
                                backgroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      color: AppColors.border),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ),
        ),

        // Save button
        if (preview.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(messageBarProvider.notifier).addWord(preview);
                      notifier.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Frase enviada a la barra')),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Enviar a barra'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _savePhrase(context, ref, preview),
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Guardar frase'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _savePhrase(BuildContext context, WidgetRef ref, String text) {
    final profileId = ref.read(currentProfileIdProvider);
    ref.read(allPhrasesProvider.notifier).addPhrase(Phrase(
          id: const Uuid().v4(),
          text: text,
          context: 'Personal',
          ageGroup: AgeGroup.adult,
          level: PhraseLevel.phrase,
          isFavorite: false,
          usageCount: 0,
          profileId: profileId,
          isCustom: true,
        ));
    ref.read(phraseConstructorProvider.notifier).clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Frase guardada en Mis frases')),
    );
  }
}

// ---------------------------------------------------------------------------
// PhraseCard
// ---------------------------------------------------------------------------

class PhraseCard extends ConsumerWidget {
  const PhraseCard({
    super.key,
    required this.phrase,
    this.leadingBadge,
    this.showEditDelete = false,
  });

  final Phrase phrase;
  final String? leadingBadge;
  final bool showEditDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Leading badge (rank number)
            if (leadingBadge != null) ...[
              SizedBox(
                width: 28,
                child: Text(
                  leadingBadge!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.grey400,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(width: 6),
            ],

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phrase.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: [
                      _Badge(phrase.context, color: AppColors.infoLight,
                          textColor: AppColors.info),
                      _Badge(_ageLabel(phrase.ageGroup),
                          color: AppColors.aiVioletLight,
                          textColor: AppColors.aiViolet),
                      _Badge(_levelLabel(phrase.level),
                          color: AppColors.successLight,
                          textColor: AppColors.success),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Favorite
                IconButton(
                  icon: Icon(
                    phrase.isFavorite ? Icons.star : Icons.star_border,
                    color: phrase.isFavorite
                        ? Colors.amber
                        : AppColors.grey400,
                    size: 20,
                  ),
                  onPressed: () =>
                      ref.read(allPhrasesProvider.notifier).toggleFavorite(phrase.id),
                  tooltip: phrase.isFavorite
                      ? 'Quitar de favoritos'
                      : 'Agregar a favoritos',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                ),

                // Speak
                IconButton(
                  icon: const Icon(Icons.volume_up_outlined,
                      size: 20, color: AppColors.inkTeal),
                  onPressed: () {
                    ref
                        .read(allPhrasesProvider.notifier)
                        .incrementUsage(phrase.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pronunciando: ${phrase.text}')),
                    );
                  },
                  tooltip: 'Pronunciar',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                ),

                // Copy to message bar
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline,
                      size: 20, color: AppColors.grey600),
                  onPressed: () {
                    ref.read(messageBarProvider.notifier).addWord(phrase.text);
                    ref
                        .read(allPhrasesProvider.notifier)
                        .incrementUsage(phrase.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Frase enviada a la barra')),
                    );
                  },
                  tooltip: 'Copiar a barra',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                ),

                // Edit/Delete if custom
                if (showEditDelete) ...[
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        size: 18, color: AppColors.grey500),
                    onPressed: () => _showEditDialog(context, ref),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: AppColors.error),
                    onPressed: () =>
                        ref.read(allPhrasesProvider.notifier).deletePhrase(phrase.id),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _ageLabel(AgeGroup g) {
    switch (g) {
      case AgeGroup.early:
        return 'Temprana';
      case AgeGroup.child:
        return 'Niño';
      case AgeGroup.teen:
        return 'Adolescente';
      case AgeGroup.adult:
        return 'Adulto';
    }
  }

  String _levelLabel(PhraseLevel l) {
    switch (l) {
      case PhraseLevel.oneWord:
        return '1 pal.';
      case PhraseLevel.twoWords:
        return '2 pal.';
      case PhraseLevel.phrase:
        return 'Frase';
    }
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController(text: phrase.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar frase'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: 2,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref.read(allPhrasesProvider.notifier).updatePhrase(
                      phrase.copyWith(text: ctrl.text.trim()),
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
}

// ---------------------------------------------------------------------------
// Shared small widgets
// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.inkTeal;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : AppColors.grey100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? activeColor : AppColors.divider,
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected ? Colors.white : AppColors.grey700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, {required this.color, required this.textColor});

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: textColor, fontSize: 10),
      ),
    );
  }
}

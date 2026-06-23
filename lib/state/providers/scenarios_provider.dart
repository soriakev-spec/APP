import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// ScenarioEntity
// ---------------------------------------------------------------------------

class ScenarioEntity {
  final String id;
  final String title;
  final String category;
  final Map<String, List<String>> sections;

  const ScenarioEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.sections,
  });

  factory ScenarioEntity.fromJson(Map<String, dynamic> json) {
    final raw = json['sections'] as Map<String, dynamic>;
    return ScenarioEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      sections: raw.map(
        (k, v) => MapEntry(k, (v as List<dynamic>).cast<String>()),
      ),
    );
  }

  int get totalPhrases =>
      sections.values.fold(0, (sum, list) => sum + list.length);
}

// ---------------------------------------------------------------------------
// Provider — loads scenarios.json once
// ---------------------------------------------------------------------------

final scenariosProvider = FutureProvider<List<ScenarioEntity>>((ref) async {
  final str = await rootBundle.loadString('assets/data/scenarios.json');
  final data = jsonDecode(str) as Map<String, dynamic>;
  final list = data['scenarios'] as List<dynamic>;
  return list
      .map((e) => ScenarioEntity.fromJson(e as Map<String, dynamic>))
      .toList();
});

// ---------------------------------------------------------------------------
// Category metadata
// ---------------------------------------------------------------------------

const scenarioCategoryMeta = <String, (String, IconData, Color)>{
  'salud':        ('Salud',        Icons.local_hospital,      Color(0xFFC62828)),
  'educacion':    ('Educación',    Icons.school,              Color(0xFF1565C0)),
  'social':       ('Social',       Icons.people,              Color(0xFF6A1B9A)),
  'casa':         ('Casa',         Icons.home,                Color(0xFF00695C)),
  'ocio':         ('Ocio',         Icons.sports_esports,      Color(0xFFE65100)),
  'transporte':   ('Transporte',   Icons.directions_bus,      Color(0xFF2E7D32)),
  'comunicacion': ('Comunicación', Icons.chat_bubble_outline, Color(0xFF283593)),
};

// ---------------------------------------------------------------------------
// Section metadata (tab order matches JSON section order)
// ---------------------------------------------------------------------------

const scenarioSectionMeta = <String, (String, IconData, Color)>{
  'phrases':   ('Frases',      Icons.chat_bubble_outline,  Color(0xFF1565C0)),
  'questions': ('Preguntas',   Icons.help_outline,         Color(0xFF6A1B9A)),
  'answers':   ('Respuestas',  Icons.check_circle_outline, Color(0xFF2E7D32)),
  'comments':  ('Comentarios', Icons.chat,                 Color(0xFFE65100)),
  'emotions':  ('Emociones',   Icons.mood,                 Color(0xFFFF8F00)),
  'emergency': ('Emergencia',  Icons.warning,              Color(0xFFC62828)),
  'social':    ('Social',      Icons.people_outline,       Color(0xFF00695C)),
};

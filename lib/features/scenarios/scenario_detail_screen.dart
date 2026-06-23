import 'package:flutter/material.dart';

class ScenarioDetailScreen extends StatelessWidget {
  final String scenarioId;

  const ScenarioDetailScreen({required this.scenarioId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escenario')),
      body: Center(
        child: Text('ScenarioDetailScreen — scenarioId: $scenarioId'),
      ),
    );
  }
}

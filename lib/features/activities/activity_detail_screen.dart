import 'package:flutter/material.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String activityId;

  const ActivityDetailScreen({required this.activityId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actividad')),
      body: Center(
        child: Text('ActivityDetailScreen — activityId: $activityId'),
      ),
    );
  }
}

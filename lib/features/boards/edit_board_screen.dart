import 'package:flutter/material.dart';

class EditBoardScreen extends StatelessWidget {
  final String boardId;

  const EditBoardScreen({required this.boardId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar tablero')),
      body: Center(
        child: Text('EditBoardScreen — boardId: $boardId'),
      ),
    );
  }
}

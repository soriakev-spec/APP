import 'package:flutter/material.dart';

import 'package:habla/state/providers/board_provider.dart';
import 'package:habla/widgets/aac_button/aac_button.dart';

// ---------------------------------------------------------------------------
// Column count helpers
// ---------------------------------------------------------------------------

int _tabletColumns(int gridSize) {
  switch (gridSize) {
    case 4:
      return 2;
    case 8:
      return 4;
    case 15:
      return 5;
    case 30:
      return 6;
    case 60:
      return 8;
    case 90:
      return 10;
    default:
      return 5;
  }
}

// ---------------------------------------------------------------------------
// AacGrid
// ---------------------------------------------------------------------------

class AacGrid extends StatelessWidget {
  final List<VocabularyItemEntity> items;
  final int gridSize;
  final void Function(VocabularyItemEntity) onTap;
  final void Function(VocabularyItemEntity)? onLongPress;

  const AacGrid({
    super.key,
    required this.items,
    required this.gridSize,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide >= 600;

    final tabletCols = _tabletColumns(gridSize);
    final phoneCols = (tabletCols - 1).clamp(1, tabletCols);
    final crossAxisCount = isTablet ? tabletCols : phoneCols;

    // Aspect ratio: taller for sparse grids, more square for dense
    final double childAspectRatio;
    if (gridSize <= 4) {
      childAspectRatio = 0.85;
    } else if (gridSize <= 8) {
      childAspectRatio = 0.88;
    } else if (gridSize <= 15) {
      childAspectRatio = 0.90;
    } else if (gridSize <= 30) {
      childAspectRatio = 0.92;
    } else {
      childAspectRatio = 0.95;
    }

    if (items.isEmpty) {
      return const _EmptyGridPlaceholder();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return AacButton(
          key: ValueKey(item.id),
          item: item,
          onTap: () => onTap(item),
          onLongPress:
              onLongPress != null ? () => onLongPress!(item) : null,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyGridPlaceholder extends StatelessWidget {
  const _EmptyGridPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.grid_view_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay palabras en esta categoría',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pulsa + para añadir símbolos',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

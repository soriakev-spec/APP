import 'package:flutter/material.dart';

import 'package:habla/core/theme/app_colors.dart';
import 'package:habla/core/theme/app_typography.dart';
import 'package:habla/core/theme/fitzgerald.dart';
import 'package:habla/state/providers/board_provider.dart';

// ---------------------------------------------------------------------------
// Color for a fitzgerald string value
// ---------------------------------------------------------------------------

Color fitzColorForString(String fitzgerald) {
  final cat = FitzgeraldHelper.categoryFromString(fitzgerald);
  if (cat == null) return AppColors.grey400;
  return FitzgeraldHelper.colorForCategory(cat);
}

IconData _iconForFitzgerald(String fitzgerald) {
  final cat = FitzgeraldHelper.categoryFromString(fitzgerald);
  if (cat == null) return Icons.grid_3x3;
  switch (cat) {
    case FitzgeraldCategory.people:
      return Icons.person_outline;
    case FitzgeraldCategory.verbs:
      return Icons.directions_run;
    case FitzgeraldCategory.descriptors:
      return Icons.palette_outlined;
    case FitzgeraldCategory.nouns:
      return Icons.category_outlined;
    case FitzgeraldCategory.social:
      return Icons.chat_bubble_outline;
    case FitzgeraldCategory.function:
      return Icons.functions;
    case FitzgeraldCategory.navigation:
      return Icons.location_on_outlined;
  }
}

// ---------------------------------------------------------------------------
// AacButton
// ---------------------------------------------------------------------------

class AacButton extends StatefulWidget {
  final VocabularyItemEntity item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final double? size;

  const AacButton({
    super.key,
    required this.item,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.size,
  });

  @override
  State<AacButton> createState() => _AacButtonState();
}

class _AacButtonState extends State<AacButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _scaleController.forward();

  void _onTapUp(TapUpDetails _) {
    _scaleController.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() => _scaleController.reverse();

  @override
  Widget build(BuildContext context) {
    final color = fitzColorForString(widget.item.fitzgerald);
    final bgColor = color.withValues(alpha: 0.12);
    final borderColor =
        widget.isSelected ? color : color.withValues(alpha: 0.35);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onLongPress: widget.onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: color, width: 3),
              top: BorderSide(color: borderColor, width: 1),
              right: BorderSide(color: borderColor, width: 1),
              bottom: BorderSide(color: borderColor, width: 1),
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Symbol image — 60% of height
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 6, 6, 2),
                      child: _SymbolImage(item: widget.item, color: color),
                    ),
                  ),
                  // Label — 40% of height
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      child: Center(
                        child: _AutoSizeLabel(label: widget.item.label),
                      ),
                    ),
                  ),
                ],
              ),
              // Favorite star badge
              if (widget.item.isFavorite)
                Positioned(
                  top: 3,
                  right: 4,
                  child: Icon(
                    Icons.star_rounded,
                    size: 12,
                    color: Colors.amber.shade600,
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
// Symbol image
// ---------------------------------------------------------------------------

class _SymbolImage extends StatelessWidget {
  final VocabularyItemEntity item;
  final Color color;

  const _SymbolImage({required this.item, required this.color});

  @override
  Widget build(BuildContext context) {
    final path = item.symbolPath;
    if (path != null && path.isNotEmpty) {
      if (path.startsWith('http')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            path,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                _PlaceholderIcon(color: color, fitzgerald: item.fitzgerald),
          ),
        );
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              _PlaceholderIcon(color: color, fitzgerald: item.fitzgerald),
        ),
      );
    }
    return _PlaceholderIcon(color: color, fitzgerald: item.fitzgerald);
  }
}

class _PlaceholderIcon extends StatelessWidget {
  final Color color;
  final String fitzgerald;

  const _PlaceholderIcon({required this.color, required this.fitzgerald});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        _iconForFitzgerald(fitzgerald),
        color: color.withValues(alpha: 0.7),
        size: 28,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Auto-sizing label
// ---------------------------------------------------------------------------

class _AutoSizeLabel extends StatelessWidget {
  final String label;

  const _AutoSizeLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final double fontSize;
        if (maxWidth > 80) {
          fontSize = 12;
        } else if (maxWidth > 55) {
          fontSize = 10;
        } else {
          fontSize = 8.5;
        }

        return Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.symbolLabelMedium.copyWith(fontSize: fontSize),
        );
      },
    );
  }
}

part of '../widgets/app_layout.dart';

class _ResizeHandle extends StatefulWidget {

  final double railWidth;
  final void Function(double) updateRailWidth;

  const _ResizeHandle({
    required this.railWidth,
    required this.updateRailWidth,
  });

  @override
  State<_ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<_ResizeHandle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        widget.updateRailWidth(widget.railWidth + details.primaryDelta!);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: _isHovered ? 4 : 2,
          decoration: BoxDecoration(
            color: _isHovered
                ? colorScheme.primary.withValues(alpha: 0.3)
                : colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}
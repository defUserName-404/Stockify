import 'package:flutter/material.dart';

class HoverActionsCell extends StatefulWidget {
  final List<Widget> actions;
  final bool isSelected;

  const HoverActionsCell(
      {super.key, required this.actions, this.isSelected = false});

  @override
  State<HoverActionsCell> createState() => _HoverActionsCellState();
}

class _HoverActionsCellState extends State<HoverActionsCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool showActions = widget.isSelected || _isHovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: showActions
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.actions,
            )
          : const Icon(Icons.more_horiz),
    );
  }
}

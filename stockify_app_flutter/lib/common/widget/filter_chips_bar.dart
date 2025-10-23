import 'package:flutter/material.dart';

class FilterChipsBar extends StatelessWidget {
  final List<FilterChipData> chips;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;

  const FilterChipsBar({
    Key? key,
    required this.chips,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: padding,
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: chips.map((chip) => _buildChip(chip)).toList(),
      ),
    );
  }

  Widget _buildChip(FilterChipData chip) {
    return Chip(
      label: Text(chip.label),
      onDeleted: chip.onDeleted,
      deleteIcon: chip.deleteIcon,
      backgroundColor: chip.backgroundColor,
      labelStyle: chip.labelStyle,
    );
  }
}

class FilterChipData {
  final String label;
  final VoidCallback? onDeleted;
  final Widget? deleteIcon;
  final Color? backgroundColor;
  final TextStyle? labelStyle;

  const FilterChipData({
    required this.label,
    this.onDeleted,
    this.deleteIcon,
    this.backgroundColor,
    this.labelStyle,
  });
}

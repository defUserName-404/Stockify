part of '../app_layout.dart';

class _HeaderToggleButton extends StatelessWidget {
  final bool isExtended;
  final VoidCallback onPressed;

  const _HeaderToggleButton({
    required this.isExtended,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: isExtended ? 'Collapse sidebar' : 'Expand sidebar',
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              isExtended ? Icons.chevron_left : Icons.chevron_right,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
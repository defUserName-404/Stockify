part of '../app_layout.dart';

class _SidebarHeader extends StatelessWidget {
  final bool showLabels;
  final bool isExtended;
  final VoidCallback onToggle;

  const _SidebarHeader({
    required this.showLabels,
    required this.isExtended,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: showLabels ? 64 : 80,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: showLabels
          ? Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/icons/icon.png',
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.inventory_2,
                  size: 24,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Stockify',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          _HeaderToggleButton(
            isExtended: isExtended,
            onPressed: onToggle,
          ),
        ],
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/icons/icon.png',
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.inventory_2,
                  size: 24,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          _HeaderToggleButton(
            isExtended: isExtended,
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}
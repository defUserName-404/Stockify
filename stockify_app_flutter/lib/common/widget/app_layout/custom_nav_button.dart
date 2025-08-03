part of 'app_layout.dart';

class _CustomNavButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool showLabel;
  final String tooltip;
  final int? badge;

  const _CustomNavButton({
    required this.icon,
    this.label,
    required this.onPressed,
    required this.isSelected,
    required this.showLabel,
    required this.tooltip,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                isSelected ? colorScheme.primaryContainer : colorScheme.surface,
          ),
          child: Material(
            color: AppColors.colorTransparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onPressed,
              child: Container(
                height: showLabel ? 48 : 64,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: showLabel
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildContent(context, colorScheme),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildContent(context, colorScheme),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, ColorScheme colorScheme) {
    return [
      Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? AppColors.colorAccent : colorScheme.onSurface,
          ),
          if (badge != null)
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  badge! > 99 ? '99+' : badge.toString(),
                  style: TextStyle(
                    color: colorScheme.onError,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      if (label != null) ...[
        SizedBox(width: showLabel ? 12 : 0, height: showLabel ? 0 : 8),
        if (showLabel)
          Expanded(
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color:
                    isSelected ? AppColors.colorAccent : colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
      ],
    ];
  }
}

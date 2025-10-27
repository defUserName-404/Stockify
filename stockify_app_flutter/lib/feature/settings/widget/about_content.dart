part of '../screen/settings_screen.dart';

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stockify is a modern inventory management application designed to streamline your stock control process. '
          'It provides a comprehensive set of features to help you manage your inventory efficiently, track stock levels, '
          'and make informed decisions.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 16),
        Text(
          'Key Features:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        ...[
          'Real-time inventory tracking',
          'Easy product addition and management',
          'Barcode scanning for quick operations',
          'Detailed reports and analytics',
          'User-friendly interface',
        ].map(
          (feature) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Version: 1.0.0',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.6),
              ),
        ),
      ],
    );
  }
}

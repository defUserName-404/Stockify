part of '../screen/settings_screen.dart';

class _HelpContent extends StatelessWidget {
  const _HelpContent();

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I add a new item to the inventory?',
        'answer':
            'To add a new item, navigate to the "Inventory" screen and click on the "Add Item" button. '
                'Fill in the required details such as item name, quantity, and price, then save.',
      },
      {
        'question': 'Can I import my existing inventory data?',
        'answer':
            'Yes, you can import your inventory data from a CSV or Excel file. '
                'Go to the "Settings" screen and use the "Import Data" feature.',
      },
      {
        'question': 'How do I generate a sales report?',
        'answer':
            'To generate a sales report, go to the "Reports" screen, select the desired date range and other filters, '
                'and click on the "Generate Report" button.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        ...faqs.map(
          (faq) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        faq['question']!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: Text(
                    faq['answer']!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'For more assistance, contact support@stockifyapp.com',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

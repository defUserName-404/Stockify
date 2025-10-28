part of '../screen/settings_screen.dart';

class _ImportResultDialog extends StatelessWidget {
  final ImportResult result;

  const _ImportResultDialog({required this.result});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            result.hasErrors && result.successCount == 0
                ? Icons.error_outline
                : result.hasErrors
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline,
            color: result.hasErrors && result.successCount == 0
                ? Colors.red
                : result.hasErrors
                    ? Colors.orange
                    : Colors.green,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              result.hasErrors && result.successCount == 0
                  ? 'Import Failed'
                  : result.hasErrors
                      ? 'Import Completed with Errors'
                      : 'Import Successful',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ResultStat(
              label: 'Total Rows',
              value: result.totalRows.toString(),
            ),
            _ResultStat(
              label: 'Successfully Imported',
              value: result.successCount.toString(),
              color: Colors.green,
            ),
            if (result.updatedCount > 0)
              _ResultStat(
                label: 'Updated',
                value: result.updatedCount.toString(),
                color: Colors.blue,
              ),
            if (result.errorCount > 0)
              _ResultStat(
                label: 'Errors',
                value: result.errorCount.toString(),
                color: Colors.red,
              ),
            if (result.warnings.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Warnings:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...result.warnings.take(5).map(
                    (w) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• $w',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
              if (result.warnings.length > 5)
                Text(
                  '... and ${result.warnings.length - 5} more',
                  style: const TextStyle(fontSize: 12),
                ),
            ],
            if (result.errors.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Errors:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...result.errors.take(5).map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• ${e.toString()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
              if (result.errors.length > 5)
                Text(
                  '... and ${result.errors.length - 5} more errors',
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

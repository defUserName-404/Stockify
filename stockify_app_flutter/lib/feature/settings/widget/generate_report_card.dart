part of '../screen/settings_screen.dart';
class _GenerateReportCard extends StatelessWidget {
  const _GenerateReportCard();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);

    return _SettingsCard(
      child: _CardHeader(
        icon: Icons.picture_as_pdf,
        title: 'Generate Report',
        subtitle: 'Generate a PDF report of the inventory',
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => _handleGenerateReport(context, provider),
        ),
        onTap: () => _handleGenerateReport(context, provider),
      ),
    );
  }

  Future<void> _handleGenerateReport(
      BuildContext context,
      SettingsProvider provider,
      ) async {
    try {
      await provider.generateReport();
      CustomSnackBar.show(
        context: context,
        message: 'Report generated successfully!',
        type: SnackBarType.success,
      );
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Error generating report: $e',
        type: SnackBarType.error,
      );
    }
  }
}
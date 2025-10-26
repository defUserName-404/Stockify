import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/widget/custom_snackbar.dart';
import 'package:stockify_app_flutter/feature/settings/provider/settings_provider.dart';

class GenerateReportTile extends StatelessWidget {
  const GenerateReportTile({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    return ListTile(
      leading: const Icon(Icons.picture_as_pdf),
      title: const Text('Generate Report'),
      subtitle: const Text('Generate a PDF report of the inventory.'),
      onTap: () async {
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
      },
    );
  }
}
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/data/service/data_service.dart';
import 'package:stockify_app_flutter/common/widget/custom_snackbar.dart';

import '../../../common/theme/colors.dart';
import '../../../common/widget/sidebar/app_layout.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildActionButton(
              'Add New Item',
              Icons.add_circle_outline,
              AppColors.colorAccent,
              () {
                AppLayout.navigatorKey.currentState
                    ?.updateSelectedScreen(1, openAddItemPanel: true);
              },
            ),
            _buildActionButton(
              'Generate Report',
              Icons.assessment,
              AppColors.colorAccent,
              () async {
                try {
                  String? outputFile = await FilePicker.platform.saveFile(
                    dialogTitle: 'Save Report',
                    fileName: 'inventory_report.pdf',
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (outputFile != null) {
                    final dataService = DataService.instance;
                    await dataService.generatePdfReport(filePath: outputFile);
                    CustomSnackBar.show(
                      context: context,
                      message: 'Report generated successfully!',
                      type: SnackBarType.success,
                    );
                  } else {
                    CustomSnackBar.show(
                      context: context,
                      message: 'Report generation cancelled.',
                      type: SnackBarType.error,
                    );
                  }
                } catch (e) {
                  CustomSnackBar.show(
                    context: context,
                    message: 'Error generating report: $e',
                    type: SnackBarType.error,
                  );
                }
              },
            ),
            _buildActionButton(
              'Manage Users',
              Icons.people_outline,
              AppColors.colorAccent,
              () {
                AppLayout.navigatorKey.currentState?.updateSelectedScreen(2);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(60),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withAlpha(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

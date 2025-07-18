import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/data/service/data_service.dart';

import '../../../common/theme/colors.dart';

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
              AppColors.colorPrimary,
              () {
                // Navigate to add item screen
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Report generated successfully!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Report generation cancelled.')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error generating report: $e')),
                  );
                }
              },
            ),
            _buildActionButton(
              'Manage Users',
              Icons.people_outline,
              AppColors.colorGreen,
              () {
                // Navigate to user management
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

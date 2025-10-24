import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/data/service/data_service.dart';
import 'package:stockify_app_flutter/common/widget/custom_snackbar.dart';

import '../../../common/theme/colors.dart';
import '../../../common/widget/app_layout/provider/app_layout_provider.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate button width: 3 per row with spacing (16px between buttons)
        double totalSpacing = 2 * 16; // two gaps per row of 3 buttons
        double buttonWidth =
            (constraints.maxWidth - totalSpacing) / 3; // 3 buttons per row
        // Fallback to full width if screen is too narrow
        if (buttonWidth < 200) buttonWidth = constraints.maxWidth;
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
                  width: buttonWidth,
                  title: 'Add New Item',
                  icon: Icons.add_circle_outline,
                  color: AppColors.colorAccent,
                  onTap: () {
                    final appLayoutProvider =
                        Provider.of<AppLayoutProvider>(context, listen: false);
                    appLayoutProvider.updateSelectedScreen(1,
                        openAddItemPanel: true);
                  },
                ),
                _buildActionButton(
                  width: buttonWidth,
                  title: 'Generate Report',
                  icon: Icons.assessment,
                  color: AppColors.colorAccent,
                  onTap: () async {
                    try {
                      String? outputFile = await FilePicker.platform.saveFile(
                        dialogTitle: 'Save Report',
                        fileName: 'inventory_report.pdf',
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (outputFile != null) {
                        final dataService = DataService.instance;
                        await dataService.generatePdfReport(
                            filePath: outputFile);
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
                  width: buttonWidth,
                  title: 'Manage Users',
                  icon: Icons.people_outline,
                  color: AppColors.colorAccent,
                  onTap: () {
                    final appLayoutProvider =
                        Provider.of<AppLayoutProvider>(context, listen: false);
                    appLayoutProvider.updateSelectedScreen(2);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton({
    required double width,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(60),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

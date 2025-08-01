import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/model/device_type.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';

class ReportService {
  ReportService._();

  static Future<void> generatePdfReport(List<Item> items,
      {String? filePath}) async {
    final pdf = pw.Document();

    // Filter items by status
    final activeItems =
        items.where((item) => item.assetStatus == AssetStatus.Active).toList();
    final inactiveItems = items
        .where((item) => item.assetStatus == AssetStatus.Inactive)
        .toList();
    final disposedItems = items
        .where((item) => item.assetStatus == AssetStatus.Disposed)
        .toList();

    // Count device types
    final deviceTypeCounts = <DeviceType, int>{};
    for (final item in items) {
      deviceTypeCounts[item.deviceType] =
          (deviceTypeCounts[item.deviceType] ?? 0) + 1;
    }

    // Count asset statuses
    final assetStatusCounts = <AssetStatus, int>{};
    for (final item in items) {
      assetStatusCounts[item.assetStatus] =
          (assetStatusCounts[item.assetStatus] ?? 0) + 1;
    }

    // Calculate max values for charts
    final maxDeviceTypeCount = deviceTypeCounts.values.isEmpty
        ? 1
        : deviceTypeCounts.values.reduce((a, b) => a > b ? a : b);
    final maxAssetStatusCount = assetStatusCounts.values.isEmpty
        ? 1
        : assetStatusCounts.values.reduce((a, b) => a > b ? a : b);

    // Create proper Y-axis values based on actual data
    List<double> createYAxisValues(int maxValue) {
      final step = (maxValue / 5).ceil();
      return List.generate(6, (index) => (index * step).toDouble());
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(text: 'Inventory Report', level: 0),
          // Summary Section
          pw.Partition(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(text: 'Summary'),
                pw.Paragraph(
                  text:
                      'This report provides a summary of the inventory as of ${DateTime.now().toString().split('.')[0]}.',
                ),
                pw.SizedBox(height: 10),
                pw.Bullet(text: 'Total Items: ${items.length}'),
                pw.Bullet(text: 'Active Items: ${activeItems.length}'),
                pw.Bullet(text: 'Inactive Items: ${inactiveItems.length}'),
                pw.Bullet(text: 'Disposed Items: ${disposedItems.length}'),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          // Device Type Chart - only if we have multiple items or want to show chart
          if (deviceTypeCounts.isNotEmpty && items.length > 1) ...[
            pw.Header(text: 'Items by Device Type'),
            pw.Container(
              height: 250,
              child: pw.Chart(
                left: pw.Container(
                  alignment: pw.Alignment.topCenter,
                  margin: const pw.EdgeInsets.only(right: 5, top: 10),
                  child: pw.Transform.rotateBox(
                    angle: 1.5708, // 90 degrees
                    child: pw.Text('Count'),
                  ),
                ),
                bottom: pw.Container(
                  alignment: pw.Alignment.topCenter,
                  margin: const pw.EdgeInsets.only(left: 5, top: 5),
                  child: pw.Text('Device Types'),
                ),
                grid: pw.CartesianGrid(
                  xAxis: pw.FixedAxis.fromStrings(
                    deviceTypeCounts.keys.map((e) => e.name).toList(),
                    marginStart: 50,
                    marginEnd: 30,
                  ),
                  yAxis: pw.FixedAxis(
                    createYAxisValues(maxDeviceTypeCount),
                    divisions: true,
                  ),
                ),
                datasets: [
                  pw.BarDataSet(
                    color: PdfColors.blue300,
                    borderColor: PdfColors.blue800,
                    borderWidth: 1,
                    data: deviceTypeCounts.entries.map((e) {
                      final xIndex =
                          deviceTypeCounts.keys.toList().indexOf(e.key);
                      return pw.PointChartValue(
                        xIndex.toDouble(),
                        e.value.toDouble(),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
          ],
          // Device Type Statistics Table
          pw.Header(
              text: deviceTypeCounts.isEmpty || items.length <= 1
                  ? 'Items by Device Type'
                  : 'Device Type Statistics'),
          if (deviceTypeCounts.isNotEmpty)
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Device Type', 'Count', 'Percentage'],
              data: deviceTypeCounts.entries.map((entry) {
                final percentage =
                    ((entry.value / items.length) * 100).toStringAsFixed(1);
                return [entry.key.name, entry.value.toString(), '$percentage%'];
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              border: pw.TableBorder.all(),
            )
          else
            pw.Paragraph(text: 'No device type data available.'),
          pw.SizedBox(height: 20),
          // Asset Status Chart - only if we have multiple items
          if (assetStatusCounts.isNotEmpty && items.length > 1) ...[
            pw.Header(text: 'Items by Asset Status'),
            pw.Container(
              height: 250,
              child: pw.Chart(
                left: pw.Container(
                  alignment: pw.Alignment.topCenter,
                  margin: const pw.EdgeInsets.only(right: 5, top: 10),
                  child: pw.Transform.rotateBox(
                    angle: 1.5708, // 90 degrees
                    child: pw.Text('Count'),
                  ),
                ),
                bottom: pw.Container(
                  alignment: pw.Alignment.topCenter,
                  margin: const pw.EdgeInsets.only(left: 5, top: 5),
                  child: pw.Text('Asset Status'),
                ),
                grid: pw.CartesianGrid(
                  xAxis: pw.FixedAxis.fromStrings(
                    assetStatusCounts.keys.map((e) => e.name).toList(),
                    marginStart: 50,
                    marginEnd: 30,
                  ),
                  yAxis: pw.FixedAxis(
                    createYAxisValues(maxAssetStatusCount),
                    divisions: true,
                  ),
                ),
                datasets: [
                  pw.BarDataSet(
                    color: PdfColors.green300,
                    borderColor: PdfColors.green800,
                    borderWidth: 1,
                    data: assetStatusCounts.entries.map((e) {
                      final xIndex =
                          assetStatusCounts.keys.toList().indexOf(e.key);
                      return pw.PointChartValue(
                        xIndex.toDouble(),
                        e.value.toDouble(),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
          ],
          // Asset Status Statistics Table
          pw.Header(
              text: assetStatusCounts.isEmpty || items.length <= 1
                  ? 'Items by Asset Status'
                  : 'Asset Status Statistics'),
          if (assetStatusCounts.isNotEmpty)
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Asset Status', 'Count', 'Percentage'],
              data: assetStatusCounts.entries.map((entry) {
                final percentage =
                    ((entry.value / items.length) * 100).toStringAsFixed(1);
                return [entry.key.name, entry.value.toString(), '$percentage%'];
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              border: pw.TableBorder.all(),
            )
          else
            pw.Paragraph(text: 'No asset status data available.'),
          pw.SizedBox(height: 20),
          // Active Items Table
          pw.Header(text: 'Active Items'),
          if (activeItems.isNotEmpty)
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Asset No', 'Model No', 'Serial No', 'Device Type'],
              data: activeItems
                  .map((item) => [
                        item.assetNo,
                        item.modelNo,
                        item.serialNo,
                        item.deviceType.name,
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              border: pw.TableBorder.all(),
            )
          else
            pw.Paragraph(text: 'No active items found.'),
          pw.SizedBox(height: 20),
          // Inactive Items Table
          pw.Header(text: 'Inactive Items'),
          if (inactiveItems.isNotEmpty)
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Asset No', 'Model No', 'Serial No', 'Device Type'],
              data: inactiveItems
                  .map((item) => [
                        item.assetNo,
                        item.modelNo,
                        item.serialNo,
                        item.deviceType.name,
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              border: pw.TableBorder.all(),
            )
          else
            pw.Paragraph(text: 'No inactive items found.'),
          pw.SizedBox(height: 20),
          // Disposed Items Table
          pw.Header(text: 'Disposed Items'),
          if (disposedItems.isNotEmpty)
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Asset No', 'Model No', 'Serial No', 'Device Type'],
              data: disposedItems
                  .map((item) => [
                        item.assetNo,
                        item.modelNo,
                        item.serialNo,
                        item.deviceType.name,
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              border: pw.TableBorder.all(),
            )
          else
            pw.Paragraph(text: 'No disposed items found.'),
        ],
      ),
    );
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(filePath ?? '${dir.path}/inventory_report.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
    } catch (e) {
      print('Error saving or opening PDF: $e');
      rethrow;
    }
  }
}

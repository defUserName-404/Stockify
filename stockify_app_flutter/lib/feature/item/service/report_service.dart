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

  static Future<void> generatePdfReport(List<Item> items, {String? filePath}) async {
    final pdf = pw.Document();

    final activeItems = items.where((item) => item.assetStatus == AssetStatus.Active).toList();
    final inactiveItems = items.where((item) => item.assetStatus == AssetStatus.Inactive).toList();
    final disposedItems = items.where((item) => item.assetStatus == AssetStatus.Disposed).toList();

    final deviceTypeCounts = <DeviceType, int>{};
    for (final item in items) {
      deviceTypeCounts[item.deviceType] = (deviceTypeCounts[item.deviceType] ?? 0) + 1;
    }

    final assetStatusCounts = <AssetStatus, int>{};
    for (final item in items) {
      assetStatusCounts[item.assetStatus] = (assetStatusCounts[item.assetStatus] ?? 0) + 1;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(text: 'Inventory Report', level: 0),
          pw.Partition(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(text: 'Summary'),
                pw.Paragraph(
                  text: 'This report provides a summary of the inventory as of ${DateTime.now()}.',
                ),
                pw.Bullet(text: 'Total Items: ${items.length}'),
                pw.Bullet(text: 'Active Items: ${activeItems.length}'),
                pw.Bullet(text: 'Inactive Items: ${inactiveItems.length}'),
                pw.Bullet(text: 'Disposed Items: ${disposedItems.length}'),
              ],
            ),
          ),
          pw.Header(text: 'Items by Device Type'),
          pw.Container(
            height: 200,
            child: pw.Chart(
              grid: pw.CartesianGrid(
                xAxis: pw.FixedAxis.fromStrings(
                  deviceTypeCounts.keys.map((e) => e.name).toList(),
                  marginStart: 30,
                  marginEnd: 30,
                ),
                yAxis: pw.FixedAxis(
                  [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50],
                ),
              ),
              datasets: [
                pw.BarDataSet(
                  data: deviceTypeCounts.entries.map((e) {
                    return pw.PointChartValue(
                      deviceTypeCounts.keys.toList().indexOf(e.key).toDouble(),
                      e.value.toDouble(),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          pw.Header(text: 'Items by Asset Status'),
          pw.Container(
            height: 200,
            child: pw.Chart(
              grid: pw.CartesianGrid(
                xAxis: pw.FixedAxis.fromStrings(
                  assetStatusCounts.keys.map((e) => e.name).toList(),
                  marginStart: 30,
                  marginEnd: 30,
                ),
                yAxis: pw.FixedAxis(
                  [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50],
                ),
              ),
              datasets: [
                pw.BarDataSet(
                  data: assetStatusCounts.entries.map((e) {
                    return pw.PointChartValue(
                      assetStatusCounts.keys.toList().indexOf(e.key).toDouble(),
                      e.value.toDouble(),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          pw.Header(text: 'Active Items'),
          pw.TableHelper.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>['Asset No', 'Model No', 'Serial No', 'Device Type'],
              ...activeItems.map((item) => [
                    item.assetNo,
                    item.modelNo,
                    item.serialNo,
                    item.deviceType.name,
                  ]),
            ],
          ),
          pw.Header(text: 'Inactive Items'),
          pw.TableHelper.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>['Asset No', 'Model No', 'Serial No', 'Device Type'],
              ...inactiveItems.map((item) => [
                    item.assetNo,
                    item.modelNo,
                    item.serialNo,
                    item.deviceType.name,
                  ]),
            ],
          ),
          pw.Header(text: 'Disposed Items'),
          pw.TableHelper.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>['Asset No', 'Model No', 'Serial No', 'Device Type'],
              ...disposedItems.map((item) => [
                    item.assetNo,
                    item.modelNo,
                    item.serialNo,
                    item.deviceType.name,
                  ]),
            ],
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(filePath ?? '${dir.path}/inventory_report.pdf');
    await file.writeAsBytes(await pdf.save());
    if (filePath == null) {
      OpenFile.open(file.path);
    }
  }
}

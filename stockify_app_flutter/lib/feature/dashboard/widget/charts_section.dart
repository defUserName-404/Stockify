import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/model/device_type.dart';
import 'package:stockify_app_flutter/feature/item/model/item_filter_param.dart';

import '../../../common/theme/colors.dart';
import '../../../common/widget/sidebar/app_layout.dart';

class ChartsSection extends StatefulWidget {
  final Map<DeviceType, int> deviceTypeCounts;
  final Map<AssetStatus, int> assetStatusCounts;

  const ChartsSection(
      {super.key,
      required this.deviceTypeCounts,
      required this.assetStatusCounts});

  @override
  State<ChartsSection> createState() => _ChartsSectionState();
}

class _ChartsSectionState extends State<ChartsSection> {
  int _selectedChartIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Analytics Overview',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              return Column(
                children: [
                  _buildDeviceTypeChart(),
                  const SizedBox(height: 16),
                  _buildAssetStatusChart(),
                ],
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildDeviceTypeChart(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildAssetStatusChart(),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDeviceTypeChart() {
    return MouseRegion(
      onEnter: (_) => setState(() => _selectedChartIndex = 0),
      onExit: (_) => setState(() => _selectedChartIndex = -1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_selectedChartIndex == 0 ? 1.02 : 1.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: _selectedChartIndex == 0
                    ? Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withAlpha(20)
                    : Theme.of(context).colorScheme.surface,
                blurRadius: _selectedChartIndex == 0 ? 20 : 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Items by Device Type',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.pie_chart,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: widget.deviceTypeCounts.entries.map((entry) {
                      return PieChartSectionData(
                        color: _getDeviceTypeColor(entry.key),
                        value: entry.value.toDouble(),
                        title: '${entry.value}',
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: widget.deviceTypeCounts.keys.map((type) {
                  return InkWell(
                    onTap: () =>
                        _navigateToItems(ItemFilterParams(deviceType: type)),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getDeviceTypeColor(type).withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getDeviceTypeColor(type),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getDeviceTypeColor(type),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            type.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getDeviceTypeColor(type),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssetStatusChart() {
    return MouseRegion(
      onEnter: (_) => setState(() => _selectedChartIndex = 1),
      onExit: (_) => setState(() => _selectedChartIndex = -1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_selectedChartIndex == 1 ? 1.02 : 1.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: _selectedChartIndex == 1
                    ? Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withAlpha(20)
                    : Theme.of(context).colorScheme.surface,
                blurRadius: _selectedChartIndex == 1 ? 20 : 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Items by Asset Status',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.colorAccent.withAlpha(10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.bar_chart,
                      color: AppColors.colorAccent,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups: widget.assetStatusCounts.entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key.index,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.toDouble(),
                            color: _getAssetStatusColor(entry.key),
                            width: 32,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: InkWell(
                                onTap: () => _navigateToItems(ItemFilterParams()
                                    .copyWith(
                                        assetStatus:
                                            AssetStatus.values[value.toInt()])),
                                child: Text(
                                  AssetStatus.values[value.toInt()].name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToItems(ItemFilterParams filterParams) {
    AppLayout.navigatorKey.currentState
        ?.updateSelectedScreen(1, itemFilterParams: filterParams);
  }

  Color _getDeviceTypeColor(DeviceType type) {
    switch (type) {
      case DeviceType.CPU:
        return AppColors.colorBlue;
      case DeviceType.Monitor:
        return AppColors.colorGreen;
      case DeviceType.UPS:
        return AppColors.colorOrange;
      case DeviceType.RAM:
        return AppColors.colorPurple;
      case DeviceType.HDD:
        return AppColors.colorPink;
      case DeviceType.SSD:
        return AppColors.colorPrimary;
      case DeviceType.Scanner:
        return AppColors.colorAccent;
      default:
        return AppColors.colorTextSemiLight;
    }
  }

  Color _getAssetStatusColor(AssetStatus status) {
    switch (status) {
      case AssetStatus.Active:
        return AppColors.colorGreen;
      case AssetStatus.Inactive:
        return AppColors.colorOrange;
      case AssetStatus.Disposed:
        return AppColors.colorPink;
      case AssetStatus.Unknown:
        return AppColors.colorTextSemiLight;
    }
  }
}

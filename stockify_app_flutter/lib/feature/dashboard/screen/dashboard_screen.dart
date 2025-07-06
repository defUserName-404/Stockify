import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/widget/placeholder/placeholder_widget.dart';
import 'package:stockify_app_flutter/feature/dashboard/widget/chart_legend.dart';
import 'package:stockify_app_flutter/feature/dashboard/widget/dashboard_card.dart';
import 'package:stockify_app_flutter/feature/dashboard/widget/info_card.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/model/device_type.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/model/item_filter_param.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/user/model/user.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final ItemService _itemService;
  late final UserService _userService;
  late List<Item> _items;
  late List<User> _users;

  @override
  void initState() {
    _itemService = ItemServiceImplementation.instance;
    _userService = UserServiceImplementation.instance;
    _items = _itemService.getAllItems();
    _users = _userService.getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildInfoCards(),
            const SizedBox(height: 16),
            _buildCharts(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        InkWell(
          onTap: () {
            AppPlaceholder.navigatorKey.currentState?.updateSelectedScreen(1);
          },
          child: InfoCard(
            title: 'Total Items',
            value: _items.length.toString(),
            icon: Icons.inventory_2,
            color: AppColors.colorBlue,
          ),
        ),
        InkWell(
          onTap: () {},
          child: InfoCard(
            title: 'Total Users',
            value: _users.length.toString(),
            icon: Icons.people,
            color: AppColors.colorGreen,
          ),
        ),
        InkWell(
          onTap: () {
            AppPlaceholder.navigatorKey.currentState?.updateSelectedScreen(1,
                itemFilterParams: ItemFilterParams(isExpiring: true));
          },
          child: InfoCard(
            title: 'Items Nearing Warranty',
            value: _getExpiringItems().length.toString(),
            icon: Icons.warning,
            color: AppColors.colorOrange,
          ),
        ),
        InkWell(
          onTap: () {
            AppPlaceholder.navigatorKey.currentState?.updateSelectedScreen(1,
                itemFilterParams:
                    ItemFilterParams(assetStatus: AssetStatus.Disposed));
          },
          child: InfoCard(
            title: 'Disposed Items',
            value: _getDisposedItems().length.toString(),
            icon: Icons.delete,
            color: AppColors.colorPink,
          ),
        ),
      ],
    );
  }

  Widget _buildCharts() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildDeviceTypeChart(),
        _buildAssetStatusChart(),
      ],
    );
  }

  Widget _buildDeviceTypeChart() {
    final deviceTypeCounts = _getDeviceTypeCounts();
    return DashboardCard(
      child: Column(
        children: [
          const Text(
            'Items by Device Type',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: deviceTypeCounts.entries.map((entry) {
                  return PieChartSectionData(
                    color: _getDeviceTypeColor(entry.key),
                    value: entry.value.toDouble(),
                    title: '${entry.value}',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: deviceTypeCounts.keys.map((type) {
              return InkWell(
                onTap: () {
                  _navigateToItems(ItemFilterParams(deviceType: type));
                },
                child: ChartLegend(
                  title: type.name,
                  color: _getDeviceTypeColor(type),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetStatusChart() {
    final assetStatusCounts = _getAssetStatusCounts();
    return DashboardCard(
      child: Column(
        children: [
          const Text(
            'Items by Asset Status',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: assetStatusCounts.entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key.index,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.toDouble(),
                        color: _getAssetStatusColor(entry.key),
                        width: 20,
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
                        return InkWell(
                          onTap: () {
                            _navigateToItems(ItemFilterParams().copyWith(
                                assetStatus:
                                    AssetStatus.values[value.toInt()]));
                          },
                          child: Text(
                            AssetStatus.values[value.toInt()].name,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToItems(ItemFilterParams filterParams) {
    AppPlaceholder.navigatorKey.currentState
        ?.updateSelectedScreen(1, itemFilterParams: filterParams);
  }

  List<Item> _getExpiringItems() {
    final now = DateTime.now();
    return _items.where((item) {
      return item.warrantyDate.isAfter(now) &&
          item.warrantyDate.difference(now).inDays <= 30;
    }).toList();
  }

  List<Item> _getDisposedItems() {
    return _items
        .where((item) => item.assetStatus == AssetStatus.Disposed)
        .toList();
  }

  Map<DeviceType, int> _getDeviceTypeCounts() {
    final counts = <DeviceType, int>{};
    for (final item in _items) {
      counts[item.deviceType] = (counts[item.deviceType] ?? 0) + 1;
    }
    return counts;
  }

  Map<AssetStatus, int> _getAssetStatusCounts() {
    final counts = <AssetStatus, int>{};
    for (final item in _items) {
      counts[item.assetStatus] = (counts[item.assetStatus] ?? 0) + 1;
    }
    return counts;
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
      case DeviceType.Printer:
        return AppColors.colorSecondary;
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

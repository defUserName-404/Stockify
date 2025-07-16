import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/sidebar/app_sidebar.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/model/device_type.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/model/item_filter_param.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/notification/model/app_notification.dart';
import 'package:stockify_app_flutter/feature/notification/service/notification_service.dart';
import 'package:stockify_app_flutter/feature/notification/service/notification_storage_service.dart';
import 'package:stockify_app_flutter/feature/user/model/user.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';

import '../widget/info_card.dart';

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

  int _selectedChartIndex = -1;

  @override
  void initState() {
    super.initState();
    _itemService = ItemServiceImplementation.instance;
    _userService = UserServiceImplementation.instance;
    _items = _itemService.getAllItems();
    _users = _userService.getAllUsers();
    _scheduleWarrantyNotifications();
  }

  void dispose() {
    super.dispose();
  }

  void _scheduleWarrantyNotifications() async {
    final expiringItems = _getExpiringItems();
    final existingNotifications =
        await NotificationStorageService().getNotifications();
    for (var item in expiringItems) {
      if (!existingNotifications.any((n) => n.id == item.id)) {
        final notificationTitle = 'Warranty Expiring Soon!';
        final notificationBody =
            'The warranty for ${item.assetNo} (${item.modelNo}) is expiring on ${item.warrantyDate.toLocal().toString().split(' ')[0]}.';
        final notificationPayload = 'item_id_${item.id}';
        NotificationService().showNotification(
          id: item.id!,
          title: notificationTitle,
          body: notificationBody,
          payload: notificationPayload,
        );
        NotificationStorageService().addNotification(
          AppNotification(
            id: item.id!,
            title: notificationTitle,
            body: notificationBody,
            timestamp: DateTime.now(),
            payload: notificationPayload,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        surfaceTintColor: AppColors.colorTransparent,
      ),
      body: ScreenTransition(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 32),
              _buildInfoCards(),
              const SizedBox(height: 32),
              _buildChartsSection(),
              const SizedBox(height: 32),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.colorPrimary, AppColors.colorAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorPrimary.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Stockify',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your inventory efficiently',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/icons/icon.png',
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    final cards = [
      InfoCard(
        title: 'Total Items',
        value: _items.length.toString(),
        icon: Icons.inventory_2,
        color: AppColors.colorBlue,
        index: 0,
        onTap: () =>
            AppSidebar.navigatorKey.currentState?.updateSelectedScreen(1),
      ),
      InfoCard(
        title: 'Total Users',
        value: _users.length.toString(),
        icon: Icons.people,
        color: AppColors.colorGreen,
        index: 1,
        onTap: () {},
      ),
      InfoCard(
        title: 'Items Nearing Warranty',
        value: _getExpiringItems().length.toString(),
        icon: Icons.warning,
        color: AppColors.colorOrange,
        index: 2,
        onTap: () => AppSidebar.navigatorKey.currentState?.updateSelectedScreen(
            1,
            itemFilterParams: ItemFilterParams(isExpiring: true)),
      ),
      InfoCard(
        title: 'Disposed Items',
        value: _getDisposedItems().length.toString(),
        icon: Icons.delete,
        color: AppColors.colorPink,
        index: 3,
        onTap: () => AppSidebar.navigatorKey.currentState?.updateSelectedScreen(
            1,
            itemFilterParams:
                ItemFilterParams(assetStatus: AssetStatus.Disposed)),
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350, // Maximum width of each card
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return cards[index];
      },
    );
  }

  Widget _buildChartsSection() {
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
    final deviceTypeCounts = _getDeviceTypeCounts();
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
                    sections: deviceTypeCounts.entries.map((entry) {
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
                children: deviceTypeCounts.keys.map((type) {
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
    final assetStatusCounts = _getAssetStatusCounts();
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
                    barGroups: assetStatusCounts.entries.map((entry) {
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

  Widget _buildQuickActions() {
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
              () {
                // Navigate to reports screen
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

  void _navigateToItems(ItemFilterParams filterParams) {
    AppSidebar.navigatorKey.currentState
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';

import '../model/device_type.dart';
import '../model/item.dart';

class ItemScreen extends StatefulWidget {
  ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        surfaceTintColor: AppColors.colorTransparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16.0),
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: PaginatedDataTable(
                  headingRowColor: WidgetStateProperty.all<Color>(
                      AppColors.colorAccent.withValues(alpha: 0.25)),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        final id = (int.parse(ItemService.instance
                                    .getAllItems()
                                    .last
                                    .id) +
                                1)
                            .toString();
                        ItemService.instance.addItem(Item(
                            id: id,
                            assetNo: 'A$id',
                            modelNo: 'M$id',
                            deviceType: DeviceType.CPU,
                            serialNo: 'S$id',
                            warrantyDate:
                                DateTime.now().add(const Duration(days: 365)),
                            assetStatus: AssetStatus.ACTIVE));
                        log('item added with id $id');
                      },
                      child: const Row(children: [
                        Icon(Icons.add),
                        SizedBox(width: 8.0),
                        Text('Add Item'),
                      ]),
                    )
                  ],
                  header: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: SearchBar(
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          leading: Icon(Icons.search,
                              color: AppColors.colorTextDark),
                          hintText: 'Search for items by their names',
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorTextSemiLight,
                          foregroundColor: AppColors.colorTextDark,
                        ),
                        onPressed: () {},
                        child: const Row(children: [
                          Icon(Icons.filter_list_rounded),
                          SizedBox(width: 8.0),
                          Text('Filter'),
                        ]),
                      ),
                    ],
                  ),
                  availableRowsPerPage: const [10, 20, 50],
                  onRowsPerPageChanged: (int? value) {
                    setState(() {
                      _rowsPerPage = value!;
                    });
                  },
                  rowsPerPage: _rowsPerPage,
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Asset No')),
                    DataColumn(label: Text('Model No')),
                    DataColumn(label: Text('Serial No')),
                    DataColumn(label: Text('Device Type')),
                    DataColumn(label: Text('Warranty Date')),
                    DataColumn(label: Text('Asset Status')),
                    DataColumn(label: Text('Actions'))
                  ],
                  source: ItemData(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemData extends DataTableSource {
  final List<Item> _items = ItemService.instance.getAllItems();

  final Set<int> _selectedRows = {};

  @override
  DataRow getRow(int index) {
    final item = _items[index];
    final selectedRowId = int.parse(item.id);
    return DataRow.byIndex(
      index: index,
      selected: _selectedRows.contains(selectedRowId),
      onSelectChanged: (selected) {
        if (selected == true) {
          _selectedRows.add(selectedRowId);
        } else {
          _selectedRows.remove(selectedRowId);
        }
        notifyListeners();
      },
      cells: [
        DataCell(Text(item.id.toString())),
        DataCell(Text(item.assetNo)),
        DataCell(Text(item.modelNo)),
        DataCell(Text(item.serialNo)),
        DataCell(Text(item.deviceType.name)),
        DataCell(Text(item.warrantyDate.toLocal().toString())),
        DataCell(Text(item.assetStatus.name)),
        DataCell(Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  for (int i = 0; i < _selectedRows.length; i++) {
                    log(_selectedRows.toList()[i].toString());
                  }
                },
                icon: const Icon(Icons.delete)),
          ],
        ))
      ],
    );
  }

  @override
  int get rowCount => _items.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedRows.length;
}

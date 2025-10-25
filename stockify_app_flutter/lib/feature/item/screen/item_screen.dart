import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/helpers/date_formatter.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/app_dialogs.dart';
import 'package:stockify_app_flutter/common/widget/custom_snackbar.dart';
import 'package:stockify_app_flutter/common/widget/page_header.dart';
import 'package:stockify_app_flutter/feature/item/model/item_view_type.dart';
import 'package:stockify_app_flutter/feature/item/provider/item_provider.dart';
import 'package:stockify_app_flutter/feature/item/provider/view_type_provider.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_form.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';

import '../../../common/widget/filter_chips_bar.dart';
import '../../user/model/user.dart';
import '../model/item.dart';
import '../model/item_filter_param.dart';
import '../widget/item_card_view.dart';
import '../widget/item_list_view.dart';
import '../widget/item_table_view.dart';

class ItemScreen extends StatefulWidget {
  final ItemFilterParams? filterParams;
  final int? itemId;
  final bool openAddItemPanel;

  const ItemScreen({
    super.key,
    this.filterParams,
    this.itemId,
    this.openAddItemPanel = false,
  });

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late final ItemService _itemService;
  late final UserService _userService;
  final FocusNode _searchFocusNode = FocusNode();
  late final TextEditingController _searchInputController;
  List<User> _usersList = [];
  final GlobalKey<PaginatedDataTableState> _paginatedDataTableKey =
      GlobalKey<PaginatedDataTableState>();

  @override
  void initState() {
    super.initState();
    _itemService = ItemServiceImplementation.instance;
    _userService = UserServiceImplementation.instance;
    _searchInputController = TextEditingController();
    _fetchUsers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ItemProvider>();
      provider.initialize(widget.filterParams);
      if (widget.itemId != null) {
        final item = _itemService.getItem(widget.itemId!);
        _showViewDetailsDialog(item);
      } else if (widget.openAddItemPanel) {
        _openItemFormDialog();
      }
    });
  }

  void _fetchUsers() {
    setState(() {
      _usersList = _userService.getAllUsers();
    });
  }

  void _onSearchChanged(String query) {
    context.read<ItemProvider>().search(query);
  }

  void _showFilterDialog() {
    final provider = context.read<ItemProvider>();
    AppDialogs.showItemFilterDialog(
      context: context,
      currentParams: provider.filterParams,
      onApplyFilter: (params) {
        provider.updateFilterParams(params);
      },
      usersList: _usersList,
    );
  }

  @override
  void didUpdateWidget(ItemScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filterParams != oldWidget.filterParams) {
      context
          .read<ItemProvider>()
          .updateFilterParams(widget.filterParams ?? ItemFilterParams());
    }
  }

  @override
  void dispose() {
    _searchInputController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _openItemFormDialog({Item? item}) async {
    final savedItem = await showDialog<Item>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width * 0.9,
          child: ItemForm(
            editingItem: item,
            onSave: (newItem) {
              Navigator.of(context).pop(newItem);
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
            usersList: _usersList,
          ),
        ),
      ),
    );
    if (savedItem != null) {
      _saveItem(savedItem);
    }
  }

  void _saveItem(Item item) {
    final provider = context.read<ItemProvider>();
    if (item.id != null) {
      provider.updateItem(item);
      CustomSnackBar.show(
        context: context,
        message: 'Item updated successfully',
        type: SnackBarType.success,
      );
    } else {
      provider.addItem(item);
      CustomSnackBar.show(
        context: context,
        message: 'Item added successfully',
        type: SnackBarType.success,
      );
    }
  }

  void _showViewDetailsDialog(Item item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width * 0.9,
          child: ItemForm(
            editingItem: item,
            onSave: (_) {},
            onCancel: () {
              Navigator.of(context).pop();
            },
            usersList: _usersList,
            isViewOnly: true,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Item item) async {
    final confirmDelete = await AppDialogs.showDeleteConfirmationDialog(
      context: context,
      itemName: 'item',
    );
    if (confirmDelete == true) {
      context.read<ItemProvider>().deleteItem(item.id!);
      CustomSnackBar.show(
        context: context,
        message: 'Item deleted successfully',
        type: SnackBarType.success,
      );
    }
  }

  void _onSort(String sortBy) {
    context.read<ItemProvider>().sort(sortBy);
  }

  @override
  Widget build(BuildContext context) {
    final viewTypeProvider = context.watch<ViewTypeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        surfaceTintColor: AppColors.colorTransparent,
      ),
      body: ScreenTransition(
        child: Consumer<ItemProvider>(
          builder: (context, provider, child) {
            return Shortcuts(
              shortcuts: {
                AppShortcuts.openSearch:
                    VoidCallbackIntent(() => _searchFocusNode.requestFocus()),
                AppShortcuts.openFilter:
                    VoidCallbackIntent(() => _showFilterDialog()),
                AppShortcuts.addNew:
                    VoidCallbackIntent(() => _openItemFormDialog()),
                AppShortcuts.arrowDown: VoidCallbackIntent(() {
                  provider.selectNextRow();
                  _paginatedDataTableKey.currentState
                      ?.pageTo(provider.firstRowIndex);
                }),
                AppShortcuts.arrowUp: VoidCallbackIntent(() {
                  provider.selectPreviousRow();
                  _paginatedDataTableKey.currentState
                      ?.pageTo(provider.firstRowIndex);
                }),
                AppShortcuts.viewDetails: VoidCallbackIntent(() {
                  final item = provider.getSelectedItem();
                  if (item != null) {
                    _showViewDetailsDialog(item);
                  }
                }),
                AppShortcuts.editItem: VoidCallbackIntent(() {
                  final item = provider.getSelectedItem();
                  if (item != null) {
                    _openItemFormDialog(item: item);
                  }
                }),
                AppShortcuts.deleteItem: VoidCallbackIntent(() {
                  final item = provider.getSelectedItem();
                  if (item != null) {
                    _showDeleteConfirmationDialog(item);
                  }
                }),
                AppShortcuts.nextPage: VoidCallbackIntent(() {
                  provider.nextPage();
                  _paginatedDataTableKey.currentState
                      ?.pageTo(provider.firstRowIndex);
                }),
                AppShortcuts.previousPage: VoidCallbackIntent(() {
                  provider.previousPage();
                  _paginatedDataTableKey.currentState
                      ?.pageTo(provider.firstRowIndex);
                }),
                AppShortcuts.sortAsc: VoidCallbackIntent(() {
                  provider.setSortOrder('ASC');
                }),
                AppShortcuts.sortDesc: VoidCallbackIntent(() {
                  provider.setSortOrder('DESC');
                }),
              },
              child: Actions(
                actions: {
                  VoidCallbackIntent: CallbackAction<VoidCallbackIntent>(
                    onInvoke: (intent) => intent.callback(),
                  ),
                },
                child: FocusScope(
                  autofocus: true,
                  child: Column(
                    children: <Widget>[
                      PageHeader(
                          onAddNew: () => _openItemFormDialog(),
                          onFilter: _showFilterDialog,
                          onSearch: _onSearchChanged,
                          searchController: _searchInputController,
                          searchFocusNode: _searchFocusNode,
                          searchHint:
                              'Search by Asset No, Model, or Serial No...',
                          viewSwitcher: ToggleButtons(
                            isSelected: [
                              viewTypeProvider.viewType == ItemViewType.table,
                              viewTypeProvider.viewType == ItemViewType.list,
                              viewTypeProvider.viewType == ItemViewType.card,
                            ],
                            onPressed: (index) {
                              viewTypeProvider
                                  .setViewType(ItemViewType.values[index]);
                            },
                            children: const [
                              Icon(Icons.table_rows),
                              Icon(Icons.view_list),
                              Icon(Icons.grid_view),
                            ],
                          )),
                      FilterChipsBar(
                        chips: [
                          if (provider.filterParams.deviceType != null)
                            FilterChipData(
                              label:
                                  'Device: ${provider.filterParams.deviceType?.name}',
                              onDeleted: () => provider.clearDeviceTypeFilter(),
                            ),
                          if (provider.filterParams.assetStatus != null)
                            FilterChipData(
                              label:
                                  'Asset Status: ${provider.filterParams.assetStatus?.name}',
                              onDeleted: () =>
                                  provider.clearAssetStatusFilter(),
                            ),
                          if (provider.filterParams.warrantyDate != null)
                            FilterChipData(
                              label:
                                  'Warranty Date: ${DateFormatter.extractDateFromDateTime(provider.filterParams.warrantyDate!)} (${provider.filterParams.warrantyDateFilterType!.name})',
                              onDeleted: () =>
                                  provider.clearWarrantyDateFilter(),
                            ),
                          if (provider.filterParams.assignedTo != null)
                            FilterChipData(
                              label:
                                  'Assigned to: ${provider.filterParams.assignedTo?.userName}',
                              onDeleted: () => provider.clearAssignedToFilter(),
                            ),
                          if (provider.filterParams.isExpiring)
                            FilterChipData(
                              label: 'Expiring in 30 days',
                              onDeleted: () => provider.clearIsExpiringFilter(),
                            ),
                        ],
                      ),
                      Expanded(
                        child: switch (viewTypeProvider.viewType) {
                          ItemViewType.table => ItemTableView(
                              onView: _showViewDetailsDialog,
                              onEdit: (item) => _openItemFormDialog(item: item),
                              onDelete: _showDeleteConfirmationDialog,
                              onSort: _onSort,
                            ),
                          ItemViewType.list => ItemListView(
                              onView: _showViewDetailsDialog,
                              onEdit: (item) => _openItemFormDialog(item: item),
                              onDelete: _showDeleteConfirmationDialog,
                            ),
                          ItemViewType.card => ItemCardView(
                              onView: _showViewDetailsDialog,
                              onEdit: (item) => _openItemFormDialog(item: item),
                              onDelete: _showDeleteConfirmationDialog,
                            ),
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

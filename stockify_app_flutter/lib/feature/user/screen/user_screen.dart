import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/app_dialogs.dart';
import 'package:stockify_app_flutter/common/widget/responsive/page_header.dart';
import 'package:stockify_app_flutter/feature/user/model/user_filter_param.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';
import 'package:stockify_app_flutter/feature/user/widget/user_form.dart';

import '../../../common/widget/custom_snackbar.dart';
import '../../item/widget/item_details_text.dart';
import '../../user/model/user.dart';
import '../service/user_service.dart';

part '../widget/user_datatable.dart';

class UserScreen extends StatefulWidget {
  UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final UserService _userService;
  int _rowsPerPage = 10;
  late UserData _userDataSource;
  UserFilterParams _filterParams = UserFilterParams();
  final FocusNode _searchFocusNode = FocusNode();
  int _selectedRowIndex = -1;
  late final TextEditingController _searchInputController;
  final GlobalKey<PaginatedDataTableState> _paginatedDataTableKey =
      GlobalKey<PaginatedDataTableState>();
  int _firstRowIndex = 0;

  @override
  void initState() {
    _userService = UserServiceImplementation.instance;
    _searchInputController = TextEditingController();
    _initializeUserDataSource();
    super.initState();
  }

  void _initializeUserDataSource() {
    _userDataSource = UserData(
        context: context,
        onEdit: (user) => _openUserFormDialog(user: user),
        filterParams: _filterParams,
        rowsPerPage: _rowsPerPage,
        onView: (user) => _showViewDetailsDialog(user),
        onDelete: (user) => _showDeleteConfirmationDialog(user),
        getSelectedRowIndex: () => _selectedRowIndex,
        setSelectedRowIndex: (index) {
          setState(() {
            _selectedRowIndex = index;
          });
      },
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _userDataSource.updateFilterParams(_filterParams);
      _userDataSource.refreshData();
      _selectedRowIndex = -1; // Reset selected row index on data refresh
    });
  }

  void _onSearchChanged(String query) {
    _filterParams = _filterParams.copyWith(search: query);
    _refreshData();
  }

  void _showFilterDialog() {
    AppDialogs.showUserFilterDialog(
      context: context,
      currentParams: _filterParams,
      onApplyFilter: (params) {
        setState(() {
          _filterParams = params;
        });
        _refreshData();
      },
    );
  }

  @override
  void dispose() {
    _searchInputController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _openUserFormDialog({User? user}) async {
    final savedUser = await showDialog<User>(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width * 0.9,
          child: UserForm(
            editingUser: user,
            onSave: (newUser) {
              Navigator.of(context).pop(newUser);
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
    if (savedUser != null) {
      _saveUser(savedUser);
    }
  }

  void _saveUser(User user) {
    if (user.id != null) {
      _userService.editUser(user);
      CustomSnackBar.show(
        context: context,
        message: 'User updated successfully',
        type: SnackBarType.success,
      );
    } else {
      _userService.addUser(user);
      CustomSnackBar.show(
        context: context,
        message: 'User added successfully',
        type: SnackBarType.success,
      );
    }
    _refreshData();
  }

  void _showViewDetailsDialog(User user) {
    AppDialogs.showDetailsDialog(
      context: context,
      title: 'User Details',
      icon: Icons.person_outline,
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ItemDetailsText(label: 'User Name', itemText: '${user.userName}'),
            if (user.designation != null)
              ItemDetailsText(
                  label: 'Designation', itemText: '${user.designation}'),
            if (user.sapId != null)
              ItemDetailsText(label: 'SAP ID', itemText: '${user.sapId}'),
            if (user.ipPhone != null)
              ItemDetailsText(label: 'IP Phone', itemText: '${user.ipPhone!}'),
            if (user.roomNo != null)
              ItemDetailsText(label: 'Room No', itemText: '${user.roomNo!}'),
            if (user.floor != null)
              ItemDetailsText(label: 'Floor No', itemText: '${user.floor}'),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(User user) async {
    final confirmDelete = await AppDialogs.showDeleteConfirmationDialog(
      context: context,
      itemName: 'user',
    );
    if (confirmDelete == true) {
      _userService.deleteUser(user.id!);
      CustomSnackBar.show(
        context: context,
        message: 'User deleted successfully',
        type: SnackBarType.success,
      );
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        surfaceTintColor: AppColors.colorTransparent,
      ),
      body: ScreenTransition(
        child: Shortcuts(
          shortcuts: {
            AppShortcuts.openSearch:
                VoidCallbackIntent(() => _searchFocusNode.requestFocus()),
            AppShortcuts.openFilter:
                VoidCallbackIntent(() => _showFilterDialog()),
            AppShortcuts.addNew: VoidCallbackIntent(() => _openUserFormDialog()),
            AppShortcuts.arrowDown: VoidCallbackIntent(() {
              int newIndex = _selectedRowIndex;
              if (newIndex < _userDataSource.rowCount - 1) {
                newIndex++;
                setState(() {
                  _selectedRowIndex = newIndex;
                  if (newIndex >= _firstRowIndex + _rowsPerPage) {
                    _firstRowIndex = (newIndex ~/ _rowsPerPage) * _rowsPerPage;
                    _paginatedDataTableKey.currentState?.pageTo(_firstRowIndex);
                  }
                });
                _userDataSource.notifySelectionChanged();
              }
            }),
            AppShortcuts.arrowUp: VoidCallbackIntent(() {
              int newIndex = _selectedRowIndex;
              if (newIndex > 0) {
                newIndex--;
                setState(() {
                  _selectedRowIndex = newIndex;
                  if (newIndex < _firstRowIndex) {
                    _firstRowIndex = (newIndex ~/ _rowsPerPage) * _rowsPerPage;
                    _paginatedDataTableKey.currentState?.pageTo(_firstRowIndex);
                  }
                });
                _userDataSource.notifySelectionChanged();
              }
            }),
            AppShortcuts.viewDetails: VoidCallbackIntent(() {
              if (_selectedRowIndex != -1) {
                _showViewDetailsDialog(
                    _userDataSource.getRowData(_selectedRowIndex));
              }
            }),
            AppShortcuts.editItem: VoidCallbackIntent(() {
              if (_selectedRowIndex != -1) {
                _openUserFormDialog(
                    user: _userDataSource.getRowData(_selectedRowIndex));
              }
            }),
            AppShortcuts.deleteItem: VoidCallbackIntent(() {
              if (_selectedRowIndex != -1) {
                _showDeleteConfirmationDialog(
                    _userDataSource.getRowData(_selectedRowIndex));
              }
            }),
            AppShortcuts.nextPage: VoidCallbackIntent(() {
              final newFirstRowIndex = _firstRowIndex + _rowsPerPage;
              if (newFirstRowIndex < _userDataSource.rowCount) {
                setState(() {
                  _firstRowIndex = newFirstRowIndex;
                  _selectedRowIndex = newFirstRowIndex;
                });
                _paginatedDataTableKey.currentState?.pageTo(newFirstRowIndex);
              }
            }),
            AppShortcuts.previousPage: VoidCallbackIntent(() {
              final newFirstRowIndex = _firstRowIndex - _rowsPerPage;
              if (newFirstRowIndex >= 0) {
                setState(() {
                  _firstRowIndex = newFirstRowIndex;
                  _selectedRowIndex = newFirstRowIndex;
                });
                _paginatedDataTableKey.currentState?.pageTo(newFirstRowIndex);
              }
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
                    onAddNew: () => _openUserFormDialog(),
                    onFilter: _showFilterDialog,
                    onSearch: _onSearchChanged,
                    searchController: _searchInputController,
                    searchFocusNode: _searchFocusNode,
                    searchHint:
                        'Search for users by their User Name or SAP ID',
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            _userDataSource.screenWidth = constraints.maxWidth;
                            List<DataColumn> getColumns(double maxWidth) {
                              if (maxWidth < 600) {
                                return [
                                  const DataColumn(label: Text('User Name')),
                                  const DataColumn(label: Text('Actions')),
                                ];
                              } else if (maxWidth < 900) {
                                return [
                                  const DataColumn(label: Text('User Name')),
                                  const DataColumn(label: Text('Designation')),
                                  const DataColumn(label: Text('Actions')),
                                ];
                              } else {
                                return [
                                  const DataColumn(label: Text('User Name')),
                                  const DataColumn(label: Text('Designation')),
                                  const DataColumn(label: Text('SAP ID')),
                                  const DataColumn(label: Text('Actions')),
                                ];
                              }
                            }
                            return PaginatedDataTable(
                              key: _paginatedDataTableKey,
                              initialFirstRowIndex: _firstRowIndex,
                              onPageChanged: (rowIndex) {
                                setState(() {
                                  _firstRowIndex = rowIndex;
                                  _selectedRowIndex = rowIndex;
                                });
                              },
                              headingRowColor:
                                  WidgetStateProperty.all<Color>(
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                          .withAlpha(10)),
                              showCheckboxColumn: false,
                              showEmptyRows: false,
                              availableRowsPerPage: const [10, 20, 50],
                              onRowsPerPageChanged: (int? value) {
                                setState(() {
                                  _rowsPerPage = value!;
                                });
                              },
                              rowsPerPage: _rowsPerPage,
                              columns: getColumns(constraints.maxWidth),
                              source: _userDataSource,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

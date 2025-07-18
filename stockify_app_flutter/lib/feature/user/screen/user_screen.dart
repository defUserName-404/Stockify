import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/theme/controller/theme_controller.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/app_dialogs.dart';
import 'package:stockify_app_flutter/common/widget/responsive/page_header.dart';
import 'package:stockify_app_flutter/common/widget/side_panel.dart';
import 'package:stockify_app_flutter/feature/user/model/user_filter_param.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';
import 'package:stockify_app_flutter/feature/user/widget/user_form.dart';

import '../../item/widget/item_details_text.dart';
import '../../user/model/user.dart';
import '../service/user_service.dart';

class UserScreen extends StatefulWidget {
  UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final UserService _userService;
  int _rowsPerPage = 10;
  bool _isPanelOpen = false;
  User? _editingUser;
  late UserData _userDataSource;
  UserFilterParams _filterParams = UserFilterParams();
  final FocusNode _searchFocusNode = FocusNode();
  int _selectedRowIndex = -1;
  late final TextEditingController _searchInputController;
  final GlobalKey<UserFormState> _formKey = GlobalKey<UserFormState>();
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
        onEdit: (user) => _togglePanel(user: user),
        filterParams: _filterParams,
        rowsPerPage: _rowsPerPage,
        onView: (user) => _showViewDetailsDialog(user),
        onDelete: (user) => _showDeleteConfirmationDialog(user),
        getSelectedRowIndex: () => _selectedRowIndex,
        setSelectedRowIndex: (index) {
          setState(() {
            _selectedRowIndex = index;
          });
        });
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

  void _togglePanel({User? user}) {
    setState(() {
      _editingUser = user;
      _isPanelOpen = !_isPanelOpen;
    });
  }

  void _saveUser(User user) {
    if (user.id != null) {
      _userService.editUser(user);
    } else {
      _userService.addUser(user);
    }
    _togglePanel();
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
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidthHalf = MediaQuery.of(context).size.width / 2;
    final currentTheme =
        Provider.of<ThemeController>(context).themeData.brightness;
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
            AppShortcuts.addNew: VoidCallbackIntent(() => _togglePanel()),
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
                _togglePanel(
                    user: _userDataSource.getRowData(_selectedRowIndex));
              }
            }),
            AppShortcuts.deleteItem: VoidCallbackIntent(() {
              if (_selectedRowIndex != -1) {
                _showDeleteConfirmationDialog(
                    _userDataSource.getRowData(_selectedRowIndex));
              }
            }),
            AppShortcuts.cancel: VoidCallbackIntent(() => _togglePanel()),
            AppShortcuts.submit: VoidCallbackIntent(() {
              if (_isPanelOpen) {
                _formKey.currentState?.saveUser();
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
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      PageHeader(
                        onAddNew: () => _togglePanel(),
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
                                List<DataColumn> getColumns(double maxWidth) {
                                  if (maxWidth < 600) {
                                    return [
                                      DataColumn(label: Text('ID')),
                                      DataColumn(label: Text('User Name')),
                                      DataColumn(label: Text('Actions')),
                                    ];
                                  } else if (maxWidth < 900) {
                                    return [
                                      DataColumn(label: Text('ID')),
                                      DataColumn(label: Text('User Name')),
                                      DataColumn(label: Text('Designation')),
                                      DataColumn(label: Text('Actions')),
                                    ];
                                  } else {
                                    return [
                                      DataColumn(label: Text('ID')),
                                      DataColumn(label: Text('User Name')),
                                      DataColumn(label: Text('Designation')),
                                      DataColumn(label: Text('SAP ID')),
                                      DataColumn(label: Text('Actions')),
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
                  SidePanel(
                    isOpen: _isPanelOpen,
                    panelWidth: screenWidthHalf,
                    currentTheme: currentTheme,
                    child: UserForm(
                      key: _formKey,
                      editingUser: _editingUser,
                      onSave: _saveUser,
                      onCancel: () => _togglePanel(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserData extends DataTableSource {
  final UserService _userService = UserServiceImplementation.instance;
  List<User> _filteredUsers = [];
  final BuildContext context;
  final void Function(User)? onEdit;
  final void Function(User)? onView;
  final void Function(User)? onDelete;
  UserFilterParams _filterParams;
  final int Function() getSelectedRowIndex;
  final Function(int) setSelectedRowIndex;

  UserData({
    required this.context,
    this.onEdit,
    this.onView,
    this.onDelete,
    required this.getSelectedRowIndex,
    required this.setSelectedRowIndex,
    required UserFilterParams filterParams,
    required int rowsPerPage,
  }) : _filterParams = filterParams {
    refreshData();
  }

  void updateFilterParams(UserFilterParams params) {
    _filterParams = params;
    refreshData();
  }

  void refreshData() {
    _filteredUsers = _userService.getFilteredUsers(_filterParams);
    notifyListeners();
  }

  void notifySelectionChanged() {
    notifyListeners();
  }

  User getRowData(int index) {
    return _filteredUsers[index];
  }

  @override
  DataRow getRow(int index) {
    final user = _filteredUsers[index];
    final isSelected = getSelectedRowIndex() == index;
    final isEven = index.isEven;
    final theme = Theme.of(context);
    return DataRow.byIndex(
      index: index,
      selected: isSelected,
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return theme.colorScheme.primary.withAlpha(40);
        }
        return isEven
            ? Colors.transparent
            : theme.colorScheme.onSurface.withAlpha(2);
      }),
      onSelectChanged: (_) {
        if (index >= 0 && index < _filteredUsers.length) {
          setSelectedRowIndex(index);
        }
        notifyListeners();
      },
      cells: [
        DataCell(Text(user.id.toString())),
        DataCell(Text(user.userName)),
        DataCell(Text(user.designation ?? '')),
        DataCell(Text(user.sapId ?? '')),
        DataCell(
          Row(
            children: [
              ActionWidget(
                icon: Icons.remove_red_eye_rounded,
                onTap: () {
                  onView!(user);
                },
                message: 'View User Details',
              ),
              const SizedBox(width: 10.0),
              ActionWidget(
                icon: Icons.edit,
                onTap: () {
                  onEdit!(user);
                },
                message: 'Edit User',
              ),
              const SizedBox(width: 10.0),
              ActionWidget(
                icon: Icons.delete,
                onTap: () {
                  onDelete!(user);
                },
                message: 'Delete User',
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  int get rowCount => _filteredUsers.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

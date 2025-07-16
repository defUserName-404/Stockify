import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/theme/controller/theme_controller.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/app_button.dart';
import 'package:stockify_app_flutter/common/widget/responsive/page_header.dart';
import 'package:stockify_app_flutter/feature/user/model/user_filter_param.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';
import 'package:stockify_app_flutter/feature/user/util/user_validator.dart';
import 'package:stockify_app_flutter/feature/user/widget/user_filter_dialog.dart';

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

  late final TextEditingController _userNameController,
      _designationController,
      _sapIdController,
      _roomNoController,
      _floorController,
      _searchInputController;

  @override
  void initState() {
    _userService = UserServiceImplementation.instance;
    _initializeControllers();
    _initializeUserDataSource();
    super.initState();
  }

  void _initializeControllers() {
    _userNameController = TextEditingController();
    _designationController = TextEditingController();
    _sapIdController = TextEditingController();
    _roomNoController = TextEditingController();
    _floorController = TextEditingController();
    _searchInputController = TextEditingController();
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
    });
  }

  void _onSearchChanged(String query) {
    _filterParams = _filterParams.copyWith(search: query);
    _refreshData();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => UserFilterDialog(
        currentParams: _filterParams,
        onApplyFilter: (params) {
          setState(() {
            _filterParams = params;
          });
          _refreshData();
        },
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _designationController.dispose();
    _sapIdController.dispose();
    _roomNoController.dispose();
    _floorController.dispose();
    _searchInputController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _togglePanel({User? user}) {
    setState(() {
      if (user != null) {
        _editingUser = user;
        _userNameController.text = user.userName;
        _designationController.text = user.designation ?? '';
        _sapIdController.text = user.sapId ?? '';
        _roomNoController.text = user.roomNo ?? '';
        _floorController.text = user.floor ?? '';
      } else {
        _editingUser = null;
        _userNameController.clear();
        _designationController.clear();
        _sapIdController.clear();
        _roomNoController.clear();
        _floorController.clear();
      }
      _isPanelOpen = !_isPanelOpen;
    });
  }

  void _saveUser() {
    final userName = _userNameController.text;
    final designation = _designationController.text;
    final sapId = _sapIdController.text;
    final roomNo = _roomNoController.text;
    final floor = _floorController.text;
    final user = User(
      id: _editingUser != null ? _editingUser!.id : null,
      userName: userName,
      designation: designation,
      sapId: sapId,
      roomNo: roomNo,
      floor: floor,
    );
    if (_editingUser != null) {
      _userService.editUser(user);
    } else {
      _userService.addUser(user);
    }
    _clearFields();
    _togglePanel();
    _refreshData();
  }

  void _clearFields() {
    _userNameController.clear();
    _designationController.clear();
    _sapIdController.clear();
    _roomNoController.clear();
    _floorController.clear();
  }

  void _showViewDetailsDialog(User user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(User user) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Yes', style: TextStyle(color: AppColors.colorPink)),
          ),
        ],
      ),
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
              _selectedRowIndex = _userDataSource.getSelectedRowIndex();
              setState(() {
                if (_selectedRowIndex <
                    _userDataSource._filteredUsers.length - 1) {
                  _userDataSource.setSelectedRowIndex(_selectedRowIndex + 1);
                }
              });
              _refreshData();
            }),
            AppShortcuts.arrowUp: VoidCallbackIntent(() {
              _selectedRowIndex = _userDataSource.getSelectedRowIndex();
              setState(() {
                if (_selectedRowIndex > 0) {
                  _userDataSource.setSelectedRowIndex(_selectedRowIndex - 1);
                }
              });
              _refreshData();
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
          },
          child: Actions(
            actions: {
              VoidCallbackIntent: CallbackAction<VoidCallbackIntent>(
                onInvoke: (intent) => intent.callback(),
              ),
            },
            child: Focus(
              autofocus: true,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      PageHeader(
                        onAddNew: _togglePanel,
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
                  // Side Panel (Sliding in/out)
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    right: _isPanelOpen ? 0 : -screenWidthHalf,
                    top: 0,
                    bottom: 0,
                    width: screenWidthHalf,
                    child: Container(
                      color: currentTheme == Brightness.light
                          ? AppColors.colorBackground
                          : AppColors.colorBackgroundDark,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _editingUser == null ? 'Add User' : 'Edit User',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: [
                              SizedBox(
                                width: 200, // Adjust width as needed
                                child: TextFormField(
                                  controller: _userNameController,
                                  validator:
                                      UserInputValidator.validateUsername,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration:
                                      InputDecoration(labelText: 'User Name'),
                                ),
                              ),
                              SizedBox(
                                width: 200, // Adjust width as needed
                                child: TextFormField(
                                  controller: _designationController,
                                  decoration:
                                      InputDecoration(labelText: 'Designation'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: [
                              SizedBox(
                                width: 200, // Adjust width as needed
                                child: TextFormField(
                                  controller: _sapIdController,
                                  decoration:
                                      InputDecoration(labelText: 'SAP ID'),
                                ),
                              ),
                              SizedBox(
                                width: 200, // Adjust width as needed
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Room No'),
                                  controller: _roomNoController,
                                ),
                              ),
                              SizedBox(
                                width: 200, // Adjust width as needed
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Floor No'),
                                  controller: _floorController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppButton(
                                  onPressed: _saveUser,
                                  icon: Icons.add,
                                  iconColor: AppColors.colorAccent,
                                  text: _editingUser == null
                                      ? 'Add User'
                                      : 'Save Changes'),
                              const SizedBox(width: 10.0),
                              AppButton(
                                onPressed: _togglePanel,
                                icon: Icons.cancel,
                                iconColor: AppColors.colorTextDark,
                                text: 'Cancel',
                                backgroundColor: AppColors.colorTextSemiLight,
                                foregroundColor: AppColors.colorTextDark,
                              ),
                            ],
                          ),
                        ],
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

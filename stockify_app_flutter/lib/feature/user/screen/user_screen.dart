import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/theme/controller/theme_controller.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/common/widget/app_button.dart';
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
    );
  }

  void _refreshData() {
    setState(() {
      _userDataSource.updateFilterParams(_filterParams);
      _userDataSource.refreshData();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filterParams = _filterParams.copyWith(search: query, page: 1);
    });
    _refreshData();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => UserFilterDialog(
        currentParams: _filterParams,
        onApplyFilter: (params) {
          setState(() {
            _filterParams = params.copyWith(page: 1);
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
    log(user.toString());
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
      body: Shortcuts(
        shortcuts: {
          AppShortcuts.openSearch:
              VoidCallbackIntent(() => _searchFocusNode.requestFocus()),
          AppShortcuts.openFilter: VoidCallbackIntent(() => _showFilterDialog()),
          AppShortcuts.addNew: VoidCallbackIntent(() => _togglePanel()),
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
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        child: PaginatedDataTable(
                          headingRowColor: WidgetStateProperty.all<Color>(
                              AppColors.colorAccent.withValues(alpha: 0.25)),
                          showEmptyRows: false,
                          source: _userDataSource,
                          actions: [
                            AppButton(
                                onPressed: _togglePanel,
                                icon: Icons.add,
                                iconColor: AppColors.colorAccent,
                                text: 'Add New User'),
                          ],
                          header: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 9,
                                child: SearchBar(
                                  controller: _searchInputController,
                                  focusNode: _searchFocusNode,
                                  padding: WidgetStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                  ),
                                  leading: Icon(Icons.search,
                                      color: AppColors.colorTextDark),
                                  hintText:
                                      'Search for users by their User Name or SAP ID',
                                  onChanged: _onSearchChanged,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              AppButton(
                                onPressed: _showFilterDialog,
                                icon: Icons.filter_list_rounded,
                                iconColor: AppColors.colorTextDark,
                                text: 'Sort & Filter',
                                backgroundColor: AppColors.colorTextSemiLight,
                                foregroundColor: AppColors.colorTextDark,
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
                            DataColumn(label: Text('User Name')),
                            DataColumn(label: Text('Designation')),
                            DataColumn(label: Text('SAP ID')),
                            DataColumn(label: Text('Actions'))
                          ],
                        ),
                      ),
                    ],
                  ),
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
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _userNameController,
                                validator: UserInputValidator.validateUsername,
                                autovalidateMode: AutovalidateMode.onUnfocus,
                                decoration:
                                    InputDecoration(labelText: 'User Name'),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                controller: _designationController,
                                decoration:
                                    InputDecoration(labelText: 'Designation'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _sapIdController,
                                decoration: InputDecoration(labelText: 'SAP ID'),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Room No'),
                                controller: _roomNoController,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Floor No'),
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
    );
  }
}

class UserData extends DataTableSource {
  final UserService _userService = UserServiceImplementation.instance;
  List<User> _users = [];
  List<User> _filteredUsers = [];
  late final BuildContext _context;
  final void Function(User)? onEdit;
  UserFilterParams _filterParams;
  int? _hoveredRowIndex;

  UserData({
    required BuildContext context,
    this.onEdit,
    required UserFilterParams filterParams,
    required int rowsPerPage,
  }) : _filterParams = filterParams {
    _context = context;
    refreshData();
  }

  void updateFilterParams(UserFilterParams params) {
    _filterParams = params;
  }

  void refreshData() {
    _users = _userService.getAllUsers();
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredUsers = _users.where((user) {
      if (_filterParams.search.isNotEmpty) {
        final searchLower = _filterParams.search.toLowerCase();
        final matchesSearch = user.userName
                .toLowerCase()
                .contains(searchLower) ||
            (user.sapId?.toLowerCase().contains(searchLower) ?? false) ||
            (user.designation?.toLowerCase().contains(searchLower) ?? false);
        if (!matchesSearch) return false;
      }
      return true;
    }).toList();
    _filteredUsers.sort((a, b) {
      int comparison = 0;
      switch (_filterParams.sortBy) {
        case 'userName':
          comparison = a.userName.compareTo(b.userName);
          break;
        case 'designation':
          comparison = (a.designation ?? '').compareTo(b.designation ?? '');
          break;
        case 'sapId':
          comparison = (a.sapId ?? '').compareTo(b.sapId ?? '');
          break;
        default:
          comparison = a.userName.compareTo(b.userName);
      }
      return _filterParams.sortOrder == 'DESC' ? -comparison : comparison;
    });
  }

  @override
  DataRow getRow(int index) {
    final user = _filteredUsers[index];
    final isHovered = _hoveredRowIndex == index;
    return DataRow.byIndex(
      index: index,
      color: WidgetStateProperty.all<Color?>(
        isHovered ? AppColors.colorAccent.withValues(alpha: 0.04) : null,
      ),
      cells: [
        DataCell(
          MouseRegion(
            onEnter: (_) {
              _hoveredRowIndex = index;
              notifyListeners();
            },
            onExit: (_) {
              _hoveredRowIndex = null;
              notifyListeners();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(user.id.toString()),
            ),
          ),
        ),
        DataCell(
          MouseRegion(
            onEnter: (_) {
              _hoveredRowIndex = index;
              notifyListeners();
            },
            onExit: (_) {
              _hoveredRowIndex = null;
              notifyListeners();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(user.userName),
            ),
          ),
        ),
        DataCell(
          MouseRegion(
            onEnter: (_) {
              _hoveredRowIndex = index;
              notifyListeners();
            },
            onExit: (_) {
              _hoveredRowIndex = null;
              notifyListeners();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(user.designation ?? ''),
            ),
          ),
        ),
        DataCell(
          MouseRegion(
            onEnter: (_) {
              _hoveredRowIndex = index;
              notifyListeners();
            },
            onExit: (_) {
              _hoveredRowIndex = null;
              notifyListeners();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(user.sapId ?? ''),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              ActionWidget(
                  icon: Icons.remove_red_eye_rounded,
                  onTap: () {
                    showDialog(
                      context: _context,
                      builder: (_) => AlertDialog(
                        title: Text('Item Details'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ItemDetailsText(
                                label: 'User Name',
                                itemText: '${user.userName}'),
                            if (user.designation != null)
                              ItemDetailsText(
                                  label: 'Designation',
                                  itemText: '${user.designation}'),
                            if (user.sapId != null)
                              ItemDetailsText(
                                  label: 'SAP ID', itemText: '${user.sapId}'),
                            if (user.ipPhone != null)
                              ItemDetailsText(
                                  label: 'IP Phone',
                                  itemText: '${user.ipPhone!}'),
                            if (user.roomNo != null)
                              ItemDetailsText(
                                  label: 'Room No',
                                  itemText: '${user.roomNo!}'),
                            if (user.floor != null)
                              ItemDetailsText(
                                  label: 'Floor No', itemText: '${user.floor}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () => Navigator.of(_context).pop(),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox(width: 10.0),
              ActionWidget(
                  icon: Icons.edit,
                  onTap: () {
                    onEdit!(user);
                  }),
              const SizedBox(width: 10.0),
              ActionWidget(
                  icon: Icons.delete,
                  onTap: () async {
                    final confirmDelete = await showDialog<bool>(
                      context: _context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete this user?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Yes',
                                style: TextStyle(color: AppColors.colorPink)),
                          ),
                        ],
                      ),
                    );
                    if (confirmDelete == true) {
                      _userService.deleteUser(user.id!);
                      refreshData();
                    }
                  })
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
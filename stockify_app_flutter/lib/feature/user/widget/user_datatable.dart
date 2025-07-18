part of '../screen/user_screen.dart';

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

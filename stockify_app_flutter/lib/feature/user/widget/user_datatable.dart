part of '../screen/user_screen.dart';

class _ActionsCell extends StatefulWidget {
  final bool isSelected;
  final List<Widget> actions;

  const _ActionsCell({required this.isSelected, required this.actions});

  @override
  State<_ActionsCell> createState() => _ActionsCellState();
}

class _ActionsCellState extends State<_ActionsCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool showActions = widget.isSelected || _isHovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: showActions
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.actions,
            )
          : const Icon(Icons.more_horiz),
    );
  }
}

class UserData extends DataTableSource {
  final UserService _userService = UserServiceImplementation.instance;
  List<User> _filteredUsers = [];
  final BuildContext context;
  final void Function(User) onEdit;
  final void Function(User) onView;
  final void Function(User) onDelete;
  UserFilterParams _filterParams;
  final int Function() getSelectedRowIndex;
  final Function(int) setSelectedRowIndex;
  double screenWidth;

  UserData({
    required this.context,
    required this.onEdit,
    required this.onView,
    required this.onDelete,
    required this.getSelectedRowIndex,
    required this.setSelectedRowIndex,
    required UserFilterParams filterParams,
    required int rowsPerPage,
    this.screenWidth = 600,
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
      cells: _getCells(user, isSelected),
    );
  }

  List<DataCell> _getCells(User user, bool isSelected) {
    if (screenWidth < 600) {
      return [
        DataCell(Text(user.userName)),
        _buildActionsCell(user, isSelected),
      ];
    } else if (screenWidth < 900) {
      return [
        DataCell(Text(user.userName)),
        DataCell(Text(user.designation ?? '')),
        _buildActionsCell(user, isSelected),
      ];
    } else {
      return [
        DataCell(Text(user.userName)),
        DataCell(Text(user.designation ?? '')),
        DataCell(Text(user.sapId ?? '')),
        _buildActionsCell(user, isSelected),
      ];
    }
  }

  DataCell _buildActionsCell(User user, bool isSelected) {
    return DataCell(
      _ActionsCell(
        isSelected: isSelected,
        actions: [
          ActionWidget(
            icon: Icons.remove_red_eye_rounded,
            onTap: () {
              onView(user);
            },
            message: 'View User Details',
          ),
          const SizedBox(width: 10.0),
          ActionWidget(
            icon: Icons.edit,
            onTap: () {
              onEdit(user);
            },
            message: 'Edit User',
          ),
          const SizedBox(width: 10.0),
          ActionWidget(
            icon: Icons.delete,
            onTap: () {
              onDelete(user);
            },
            message: 'Delete User',
          )
        ],
      ),
    );
  }

  @override
  int get rowCount => _filteredUsers.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/widget/app_button.dart';

import '../../../common/theme/colors.dart';

class ItemHeader extends StatelessWidget {
  final VoidCallback onAddNew;
  final VoidCallback onFilter;
  final Function(String) onSearch;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;

  const ItemHeader(
      {super.key,
      required this.onAddNew,
      required this.onFilter,
      required this.onSearch,
      required this.searchController,
      required this.searchFocusNode});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildVerticalLayout(context);
        } else {
          return _buildHorizontalLayout(context);
        }
      },
    );
  }

  Widget _buildHorizontalLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSearchBar(context),
          ),
          const SizedBox(width: 16.0),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildVerticalLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        children: [
          _buildSearchBar(context),
          const SizedBox(height: 16.0),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      focusNode: searchFocusNode,
      controller: searchController,
      onChanged: onSearch,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search by Asset No, Model, or Serial No...',
        isDense: false,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        suffixIcon: searchController.text.isNotEmpty
            ? InkWell(
                onTap: () {
                  searchController.clear();
                  onSearch('');
                },
                child: const Icon(Icons.clear),
              )
            : null,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      alignment: WrapAlignment.end,
      children: [
        AppButton(
          onPressed: onFilter,
          icon: Icons.filter_list_alt,
          text: 'Filter & Sort',
          backgroundColor: AppColors.colorTextSemiLight,
          foregroundColor: AppColors.colorTextDark,
        ),
        AppButton(
          onPressed: onAddNew,
          icon: Icons.add,
          text: 'Add New Item',
        ),
      ],
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSearchBar(),
          ),
          const SizedBox(width: 16.0),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      focusNode: searchFocusNode,
      controller: searchController,
      onChanged: onSearch,
      style: TextStyle(color: AppColors.colorTextDark),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search by Asset No, Model, or Serial No...',
        hintStyle: TextStyle(color: AppColors.colorTextDark),
        isDense: false,
        filled: true,
        fillColor: AppColors.colorTextSemiLight,
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        AppButton(
          onPressed: onFilter,
          icon: Icons.filter_list_alt,
          text: 'Filter & Sort',
          backgroundColor: AppColors.colorTextSemiLight,
          foregroundColor: AppColors.colorTextDark,
        ),
        const SizedBox(width: 16.0),
        AppButton(
          onPressed: onAddNew,
          icon: Icons.add,
          text: 'Add New Item',
        ),
      ],
    );
  }
}

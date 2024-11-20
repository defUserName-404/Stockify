import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        titleSpacing: 0,
        surfaceTintColor: AppColors.colorTransparent,
        actions: [
          ElevatedButton(
            onPressed: () {
              log('add item pressed');
            },
            child: const Row(children: [
              Icon(Icons.add),
              SizedBox(width: 16.0),
              Text('Add Item'),
            ]),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 32.0),
          Row(
            children: <Widget>[
              Expanded(
                flex: 9,
                child: SearchBar(
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  leading: Icon(Icons.search, color: AppColors.colorTextDark),
                  hintText: 'Search for items by their names',
                ),
              ),
              const SizedBox(width: 16.0),
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
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const Icon(Icons.inventory_2),
                  title: Text('Item ${index + 1}'),
                  subtitle: const Text('Item details'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Help & FAQs'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Frequently Asked Questions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Q: How do I add a new item to the inventory?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'A: To add a new item, navigate to the "Inventory" screen and click on the "Add Item" button. '
                'Fill in the required details such as item name, quantity, and price, then save.',
              ),
              SizedBox(height: 16),
              Text(
                'Q: Can I import my existing inventory data?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'A: Yes, you can import your inventory data from a CSV or Excel file. '
                'Go to the "Settings" screen and use the "Import Data" feature.',
              ),
              SizedBox(height: 16),
              Text(
                'Q: How do I generate a sales report?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'A: To generate a sales report, go to the "Reports" screen, select the desired date range and other filters, '
                'and click on the "Generate Report" button.',
              ),
              SizedBox(height: 16),
              Text(
                'For more assistance, please contact our support team at support@stockifyapp.com.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

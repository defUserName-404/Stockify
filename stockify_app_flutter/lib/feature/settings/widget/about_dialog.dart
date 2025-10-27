import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';

void showAboutAppDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('About Stockify'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Stockify is a modern inventory management application designed to streamline your stock control process. '
                    'It provides a comprehensive set of features to help you manage your inventory efficiently, track stock levels, '
                    'and make informed decisions.',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                'Key Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Real-time inventory tracking'),
              Text('• Easy product addition and management'),
              Text('• Detailed reports and analytics'),
              Text('• User-friendly interface'),
              SizedBox(height: 16),
              Text(
                'Version: 1.0.0',
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

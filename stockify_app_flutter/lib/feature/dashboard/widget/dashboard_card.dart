import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;
  final Decoration? decoration;
  final double? elevation;

  const DashboardCard(
      {super.key, required this.child, this.decoration, this.elevation});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.transparent,
      child: Container(
        decoration: decoration,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}

part of '../screen/settings_screen.dart';

class _ExpandableCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const _ExpandableCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<_ExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      child: Column(
        children: [
          _CardHeader(
            icon: widget.icon,
            title: widget.title,
            subtitle: widget.subtitle,
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
          ),
          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 1,
                color: Theme.of(context).dividerColor.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: widget.child,
            ),
          ],
        ],
      ),
    );
  }
}

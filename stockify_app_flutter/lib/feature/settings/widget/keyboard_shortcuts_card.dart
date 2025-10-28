part of '../screen/settings_screen.dart';

class _KeyboardShortcutsCard extends StatefulWidget {
  const _KeyboardShortcutsCard();

  @override
  State<_KeyboardShortcutsCard> createState() => _KeyboardShortcutsCardState();
}

class _KeyboardShortcutsCardState extends State<_KeyboardShortcutsCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      child: Column(
        children: [
          _CardHeader(
            icon: Icons.keyboard_outlined,
            title: 'Keyboard Shortcuts',
            subtitle: 'View all available keyboard shortcuts',
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
              child: _KeyboardShortcutsContent(),
            ),
          ],
        ],
      ),
    );
  }
}
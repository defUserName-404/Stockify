part of '../screen/settings_screen.dart';
class _DataManagementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<_ActionButton> actions;

  const _DataManagementCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: icon,
            title: title,
            subtitle: subtitle,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                for (int i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(child: actions[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
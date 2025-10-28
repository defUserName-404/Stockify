part of '../screen/settings_screen.dart';

class _DarkModeCard extends StatelessWidget {
  const _DarkModeCard();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData == AppTheme.dark;
    return _SettingsCard(
      child: _CardHeader(
        icon: isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
        title: 'Dark Mode',
        subtitle:
        isDarkMode ? 'Dark theme is enabled' : 'Light theme is enabled',
        trailing: Switch(
          value: isDarkMode,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
        ),
      ),
    );
  }
}
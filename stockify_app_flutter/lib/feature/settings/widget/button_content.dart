part of '../screen/settings_screen.dart';
class _ButtonContent extends StatelessWidget {
  final String imageAsset;
  final String label;

  const _ButtonContent({
    required this.imageAsset,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imageAsset,
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
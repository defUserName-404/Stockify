part of '../screen/settings_screen.dart';

class _ActionButton extends StatelessWidget {
  final String label;
  final String imageAsset;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.imageAsset,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _ButtonContent(imageAsset: imageAsset, label: label),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _ButtonContent(imageAsset: imageAsset, label: label),
    );
  }
}
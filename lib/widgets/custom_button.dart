import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Tombol reusable selebar parent. Letakkan di dalam Expanded jika berada di Row.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined;
  final Color? color;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.outlined = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );
    const size = Size(double.infinity, 48);

    if (outlined) {
      final c = color ?? AppColors.primary;
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: c,
          minimumSize: size,
          shape: shape,
          side: BorderSide(color: onPressed == null ? AppColors.divider : c),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        child: content,
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: size,
        shape: shape,
      ),
      child: content,
    );
  }
}

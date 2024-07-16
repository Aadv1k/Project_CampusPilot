import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';
import 'package:flutter/material.dart';

enum ChipVariant { filled, outlined }

class CustomChip extends StatelessWidget {
  final ChipVariant variant;
  final VoidCallback? onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Color color; 
  final Color textColor; 
  final String text;
  final TextStyle? textStyle;

  const CustomChip({
    Key? key,
    required this.variant,
    required this.text,
    this.color = Palette.primary,
    this.textColor = Palette.white,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.xs),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          border: variant == ChipVariant.outlined
              ? Border.all(color: color)
              : Border.all(color: Palette.divider),
          borderRadius: BorderRadius.circular(Radii.lg),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              leadingIcon!,
              const SizedBox(width: Spacing.sm),
            ],
            Text(
              text,
              style: textStyle ??
                  TextStyle(
                    color: textColor,
                    fontSize: FontSize.sm,
                  ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: Spacing.sm),
              trailingIcon!,
            ],
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case ChipVariant.filled:
        return color;
      case ChipVariant.outlined:
        return Colors.transparent;
      default:
        return color;
    }
  }
}

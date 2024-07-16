import 'package:flutter/material.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/sizes.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final String text;
  final TextStyle? textStyle;
  final bool isLoading;
  final double radius;
  final Widget? icon;

  const PrimaryButton({
    Key? key,
    required this.width,
    this.height = Heights.xl,
    required this.text,
    this.radius = Radii.md, 
    this.textStyle,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Palette.slate100),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: textStyle ?? const TextStyle(
            fontSize: FontSize.base,
            fontWeight: FontWeight.normal,
            color: Palette.white,
          ),
        ),
        if (icon != null) ...[
          SizedBox(width: 8),
          icon!,
        ],
      ],
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final String text;
  final TextStyle? textStyle;
  final bool isLoading;
  final Widget? icon;

  const SecondaryButton({
    Key? key,
    required this.width,
    this.height = Heights.xl,
    required this.text,
    this.textStyle,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.xxl)),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Palette.slate100),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: textStyle ?? const TextStyle(
            fontSize: FontSize.base,
            fontWeight: FontWeight.normal,
            color: Palette.white,
          ),
        ),
        if (icon != null) ...[
          SizedBox(width: 8),
          icon!,
        ],
      ],
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final TextStyle? textStyle;

  const CustomTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ?? const TextStyle(
          fontSize: FontSize.base,
          fontWeight: FontWeight.normal,
          color: Palette.primary,
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final Color? color;
  final Color? backgroundColor;

  const CustomIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.size = 48.0,
    this.color,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Palette.gray200,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color ?? Palette.gray400),
        iconSize: size * 0.5,
      ),
    );
  }
}

class UserProfileButton extends StatelessWidget {
  final String profileInitials;
  final double size;
  final VoidCallback? onTap;

  UserProfileButton({
    Key? key,
    required this.profileInitials,
    required this.size,
    this.onTap,
  }) : super(key: key);

  Color get _colorBasedOnProfileInitials {
    if (profileInitials.isEmpty) return Palette.pastelOrange;

    final colors = [
      Palette.pastelLavender,
      Palette.pastelPink,
      Palette.pastelAqua,
      Palette.pastelIceBlue,
      Palette.pastelOrange,
      Palette.pastelRed,
    ];

    int sumIndex = profileInitials.toLowerCase().codeUnits.fold(0, (sum, code) => sum + (code - 'a'.codeUnitAt(0)));
    return colors[sumIndex % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: _colorBasedOnProfileInitials,
        ),
        child: Center(
          child: Text(
            profileInitials.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Palette.white,
              fontWeight: FontWeight.bold,
              fontSize: FontSize.lg,
            ),
          ),
        ),
      ),
    );
  }
}
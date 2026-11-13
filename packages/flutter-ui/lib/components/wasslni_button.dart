import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

class WasslniButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final Widget? icon;

  const WasslniButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isSecondary
        ? (isDark ? WasslniColors.darkSurfaceRaised : WasslniColors.lightSurfaceRaised)
        : WasslniColors.emerald800;

    final fgColor = isSecondary
        ? (isDark ? WasslniColors.darkTextPrimary : WasslniColors.lightTextPrimary)
        : Colors.white;

    final borderColor = isSecondary
        ? (isDark ? WasslniColors.darkBorder : WasslniColors.lightBorder)
        : WasslniColors.gold500.withOpacity(0.5);

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: isSecondary ? 0 : 3,
          shadowColor: WasslniColors.emerald800.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: fgColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

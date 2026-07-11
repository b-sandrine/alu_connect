import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/context_theme_x.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.useGradient = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final bool useGradient;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.isLoading || widget.onPressed == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(widget.label),
            ],
          );

    Widget button;
    if (widget.isOutlined) {
      button = OutlinedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        child: child,
      );
    } else if (widget.useGradient) {
      button = _GradientButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        child: child,
      );
    } else {
      button = ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        child: child,
      );
    }

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: button,
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.onPressed, required this.child});

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final gradient = context.colors.heroGradient;
    final disabled = onPressed == null;

    return Opacity(
      opacity: disabled ? 0.6 : 1,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPressed,
            child: Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                child: IconTheme(
                  data: const IconThemeData(color: Colors.white),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

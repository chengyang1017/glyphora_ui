import 'package:flutter/material.dart';
import 'package:nestless_flutter/nestless_flutter.dart';

enum AppButtonStyle {
  filled,
  outlined,
  text,
}

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonStyle style;
  final bool expand;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style = AppButtonStyle.filled,
    this.expand = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final button = switch (style) {
      AppButtonStyle.filled => _buildFilledButton(),
      AppButtonStyle.outlined => _buildOutlinedButton(),
      AppButtonStyle.text => _buildTextButton(),
    };

    if (!expand) return button;

    return button.nWidth(double.infinity);
  }

  Widget _buildFilledButton() {
    if (icon == null) {
      return FilledButton(
        onPressed: onPressed,
        child: child,
      );
    }

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: child,
    );
  }

  Widget _buildOutlinedButton() {
    if (icon == null) {
      return OutlinedButton(
        onPressed: onPressed,
        child: child,
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: child,
    );
  }

  Widget _buildTextButton() {
    if (icon == null) {
      return TextButton(
        onPressed: onPressed,
        child: child,
      );
    }

    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: child,
    );
  }
}
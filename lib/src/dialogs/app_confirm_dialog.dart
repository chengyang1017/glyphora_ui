import 'package:flutter/material.dart';

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = '确认',
    this.cancelText = '取消',
    this.isDestructive = false,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '确认',
    String cancelText = '取消',
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      ),
    );

    return result ?? false;
  }

  void _close(
    BuildContext context,
    bool result,
  ) {
    Navigator.of(context).pop(result);
  }

  List<Widget> _buildActions(
    BuildContext context,
  ) {
    return [
      TextButton(
        onPressed: () => _close(
          context,
          false,
        ),
        child: Text(cancelText),
      ),

      _ConfirmButton(
        text: confirmText,
        isDestructive: isDestructive,
        onPressed: () => _close(
          context,
          true,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: _buildActions(context),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final String text;
  final bool isDestructive;
  final VoidCallback onPressed;

  const _ConfirmButton({
    required this.text,
    required this.isDestructive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return FilledButton(
      style: isDestructive
          ? FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
            )
          : null,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
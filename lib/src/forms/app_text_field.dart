import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final bool enabled;
  final int minLines;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    this.enabled = true,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() {
    return _AppTextFieldState();
  }
}

class _AppTextFieldState
    extends State<AppTextField> {
  late bool _isObscured;

  bool get _isPasswordField {
    return widget.obscureText;
  }

  int get _minLines {
    return _isPasswordField
        ? 1
        : widget.minLines;
  }

  int get _maxLines {
    return _isPasswordField
        ? 1
        : widget.maxLines;
  }

  IconData get _visibilityIcon {
    return _isObscured
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
  }

  @override
  void initState() {
    super.initState();

    _isObscured = widget.obscureText;
  }

  @override
  void didUpdateWidget(
    covariant AppTextField oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.obscureText ==
        widget.obscureText) {
      return;
    }

    _isObscured = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Widget? _buildSuffixIcon() {
    if (!_isPasswordField) {
      return null;
    }

    return IconButton(
      onPressed: _toggleVisibility,
      icon: Icon(_visibilityIcon),
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      labelText: widget.label,
      hintText: widget.hintText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      alignLabelWithHint: widget.maxLines > 1,
      suffixIcon: _buildSuffixIcon(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      obscureText: _isObscured,
      minLines: _minLines,
      maxLines: _maxLines,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      decoration: _buildDecoration(),
    );
  }
}
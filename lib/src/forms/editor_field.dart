import 'package:flutter/material.dart';

enum EditorFieldType {
  text,
  multiline,
  password,
}

@immutable
class EditorField {
  final String key;
  final String label;
  final String initialValue;
  final String? hintText;
  final String? helperText;
  final EditorFieldType type;
  final bool required;
  final bool autofocus;
  final bool enabled;
  final int minLines;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String value)? validator;

  const EditorField._({
    required this.key,
    required this.label,
    required this.type,
    this.initialValue = '',
    this.hintText,
    this.helperText,
    this.required = true,
    this.autofocus = false,
    this.enabled = true,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.validator,
  });

  const EditorField.text({
    required String key,
    required String label,
    String initialValue = '',
    String? hintText,
    String? helperText,
    bool required = true,
    bool autofocus = false,
    bool enabled = true,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String value)? validator,
  }) : this._(
          key: key,
          label: label,
          type: EditorFieldType.text,
          initialValue: initialValue,
          hintText: hintText,
          helperText: helperText,
          required: required,
          autofocus: autofocus,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
        );

  const EditorField.multiline({
    required String key,
    required String label,
    String initialValue = '',
    String? hintText,
    String? helperText,
    bool required = true,
    bool autofocus = false,
    bool enabled = true,
    int minLines = 4,
    int maxLines = 10,
    TextInputType? keyboardType = TextInputType.multiline,
    String? Function(String value)? validator,
  }) : this._(
          key: key,
          label: label,
          type: EditorFieldType.multiline,
          initialValue: initialValue,
          hintText: hintText,
          helperText: helperText,
          required: required,
          autofocus: autofocus,
          enabled: enabled,
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.newline,
          validator: validator,
        );

  const EditorField.password({
    required String key,
    required String label,
    String initialValue = '',
    String? hintText,
    String? helperText,
    bool required = true,
    bool autofocus = false,
    bool enabled = true,
    TextInputAction? textInputAction,
    String? Function(String value)? validator,
  }) : this._(
          key: key,
          label: label,
          type: EditorFieldType.password,
          initialValue: initialValue,
          hintText: hintText,
          helperText: helperText,
          required: required,
          autofocus: autofocus,
          enabled: enabled,
          textInputAction: textInputAction,
          validator: validator,
        );
}

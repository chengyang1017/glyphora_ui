import 'package:flutter/material.dart';
import 'package:nestless_flutter/nestless_flutter.dart';

import '../forms/app_text_field.dart';
import '../forms/editor_field.dart';
import '../theme/app_spacing.dart';

typedef EditorValues = Map<String, String>;

typedef EditorSaveCallback =
    Future<void> Function(EditorValues values);

class AppEditorDialog extends StatefulWidget {
  final String title;
  final List<EditorField> fields;
  final String saveText;
  final String cancelText;
  final EditorSaveCallback? onSave;
  final bool popAfterSave;

  const AppEditorDialog({
    super.key,
    required this.title,
    required this.fields,
    this.saveText = '保存',
    this.cancelText = '取消',
    this.onSave,
    this.popAfterSave = true,
  });

  static Future<EditorValues?> show(
    BuildContext context, {
    required String title,
    required List<EditorField> fields,
    String saveText = '保存',
    String cancelText = '取消',
    EditorSaveCallback? onSave,
    bool popAfterSave = true,
    bool barrierDismissible = false,
  }) {
    return showDialog<EditorValues>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return AppEditorDialog(
          title: title,
          fields: fields,
          saveText: saveText,
          cancelText: cancelText,
          onSave: onSave,
          popAfterSave: popAfterSave,
        );
      },
    );
  }

  @override
  State<AppEditorDialog> createState() {
    return _AppEditorDialogState();
  }
}

class _AppEditorDialogState
    extends State<AppEditorDialog> {
  late final Map<String, TextEditingController>
      _controllers;

  final Map<String, String?> _errors = {};

  bool _isSaving = false;
  String? _saveError;

  @override
  void initState() {
    super.initState();

    _assertUniqueKeys();
    _createControllers();
  }

  void _assertUniqueKeys() {
    final keys = widget.fields
        .map((field) => field.key)
        .toList();

    assert(
      keys.length == keys.toSet().length,
      'EditorField keys must be unique.',
    );
  }

  void _createControllers() {
    _controllers = {
      for (final field in widget.fields)
        field.key: TextEditingController(
          text: field.initialValue,
        ),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  EditorValues _readValues() {
    return {
      for (final entry in _controllers.entries)
        entry.key: entry.value.text.trim(),
    };
  }

  bool _validate(EditorValues values) {
    final nextErrors = <String, String?>{};

    for (final field in widget.fields) {
      final value = values[field.key] ?? '';

      if (field.required && value.isEmpty) {
        nextErrors[field.key] =
            '${field.label}不能为空';

        continue;
      }

      nextErrors[field.key] =
          field.validator?.call(value);
    }

    setState(() {
      _errors
        ..clear()
        ..addAll(nextErrors);

      _saveError = null;
    });

    return nextErrors.values.every(
      (error) => error == null,
    );
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;

    final values = _readValues();

    if (!_validate(values)) return;

    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    try {
      await widget.onSave?.call(values);

      if (!mounted) return;

      if (widget.popAfterSave) {
        Navigator.of(context).pop(values);
        return;
      }

      setState(() {
        _isSaving = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
        _saveError = '保存失败：$error';
      });
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  void _clearFieldError(String fieldKey) {
    if (_errors[fieldKey] == null &&
        _saveError == null) {
      return;
    }

    setState(() {
      _errors[fieldKey] = null;
      _saveError = null;
    });
  }

  Widget _buildContent() {
    return _EditorDialogContent(
      fields: widget.fields,
      controllers: _controllers,
      errors: _errors,
      saveError: _saveError,
      enabled: !_isSaving,
      onChanged: _clearFieldError,
    );
  }

  List<Widget> _buildActions() {
    return [
      TextButton(
        onPressed: _isSaving ? null : _cancel,
        child: Text(widget.cancelText),
      ),
      FilledButton(
        onPressed:
            _isSaving ? null : _handleSave,
        child: _buildSaveButtonChild(),
      ),
    ];
  }

  Widget _buildSaveButtonChild() {
    if (!_isSaving) {
      return Text(widget.saveText);
    }

    return const SizedBox.square(
      dimension: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSaving,
      child: AlertDialog(
        title: Text(widget.title),
        content: _buildContent(),
        actions: _buildActions(),
      ),
    );
  }
}

class _EditorDialogContent
    extends StatelessWidget {
  final List<EditorField> fields;

  final Map<String, TextEditingController>
      controllers;

  final Map<String, String?> errors;

  final String? saveError;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _EditorDialogContent({
    required this.fields,
    required this.controllers,
    required this.errors,
    required this.saveError,
    required this.enabled,
    required this.onChanged,
  });

  Widget _buildField(EditorField field) {
    return _EditorFieldView(
      field: field,
      controller: controllers[field.key]!,
      errorText: errors[field.key],
      enabled: enabled,
      onChanged: () => onChanged(field.key),
    );
  }

  Widget _buildSaveError(
    BuildContext context,
    String error,
  ) {
    return Text(
      error,
      style: TextStyle(
        color: Theme.of(context)
            .colorScheme
            .error,
      ),
    ).nAlign(
      Alignment.centerLeft,
    );
  }

  List<Widget> _buildChildren(
    BuildContext context,
  ) {
    final error = saveError;

    return [
      ...fields.map(_buildField),

      if (error != null)
        _buildSaveError(
          context,
          error,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return NScrollColumn(
      width: 480,
      gap: AppSpacing.md,
      children: _buildChildren(context),
    );
  }
}

class _EditorFieldView
    extends StatelessWidget {
  final EditorField field;
  final TextEditingController controller;
  final String? errorText;
  final bool enabled;
  final VoidCallback onChanged;

  const _EditorFieldView({
    required this.field,
    required this.controller,
    required this.errorText,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: field.label,
      hintText: field.hintText,
      helperText: field.helperText,
      errorText: errorText,
      obscureText:
          field.type == EditorFieldType.password,
      autofocus: field.autofocus,
      enabled: enabled && field.enabled,
      minLines: field.minLines,
      maxLines: field.maxLines,
      keyboardType: field.keyboardType,
      textInputAction:
          field.textInputAction,
      onChanged: (_) => onChanged(),
    );
  }
}

// import 'package:flutter/material.dart';

// import '../forms/app_text_field.dart';
// import '../forms/editor_field.dart';
// import '../theme/app_spacing.dart';

// typedef EditorValues = Map<String, String>;
// typedef EditorSaveCallback = Future<void> Function(EditorValues values);

// class AppEditorDialog extends StatefulWidget {
//   final String title;
//   final List<EditorField> fields;
//   final String saveText;
//   final String cancelText;
//   final EditorSaveCallback? onSave;
//   final bool popAfterSave;

//   const AppEditorDialog({
//     super.key,
//     required this.title,
//     required this.fields,
//     this.saveText = '保存',
//     this.cancelText = '取消',
//     this.onSave,
//     this.popAfterSave = true,
//   });

//   static Future<EditorValues?> show(
//     BuildContext context, {
//     required String title,
//     required List<EditorField> fields,
//     String saveText = '保存',
//     String cancelText = '取消',
//     EditorSaveCallback? onSave,
//     bool popAfterSave = true,
//     bool barrierDismissible = false,
//   }) {
//     return showDialog<EditorValues>(
//       context: context,
//       barrierDismissible: barrierDismissible,
//       builder: (_) {
//         return AppEditorDialog(
//           title: title,
//           fields: fields,
//           saveText: saveText,
//           cancelText: cancelText,
//           onSave: onSave,
//           popAfterSave: popAfterSave,
//         );
//       },
//     );
//   }

//   @override
//   State<AppEditorDialog> createState() => _AppEditorDialogState();
// }

// class _AppEditorDialogState extends State<AppEditorDialog> {
//   late final Map<String, TextEditingController> _controllers;
//   final Map<String, String?> _errors = {};

//   bool _isSaving = false;
//   String? _saveError;

//   @override
//   void initState() {
//     super.initState();

//     _assertUniqueKeys();

//     _controllers = {
//       for (final field in widget.fields)
//         field.key: TextEditingController(
//           text: field.initialValue,
//         ),
//     };
//   }

//   void _assertUniqueKeys() {
//     final keys = widget.fields.map((field) => field.key).toList();
//     final uniqueKeys = keys.toSet();

//     assert(
//       keys.length == uniqueKeys.length,
//       'EditorField keys must be unique.',
//     );
//   }

//   @override
//   void dispose() {
//     for (final controller in _controllers.values) {
//       controller.dispose();
//     }

//     super.dispose();
//   }

//   EditorValues _readValues() {
//     return {
//       for (final entry in _controllers.entries)
//         entry.key: entry.value.text.trim(),
//     };
//   }

//   bool _validate(EditorValues values) {
//     final nextErrors = <String, String?>{};

//     for (final field in widget.fields) {
//       final value = values[field.key] ?? '';

//       if (field.required && value.isEmpty) {
//         nextErrors[field.key] = '${field.label}不能为空';
//         continue;
//       }

//       nextErrors[field.key] = field.validator?.call(value);
//     }

//     setState(() {
//       _errors
//         ..clear()
//         ..addAll(nextErrors);

//       _saveError = null;
//     });

//     return nextErrors.values.every((error) => error == null);
//   }

//   Future<void> _handleSave() async {
//     if (_isSaving) return;

//     final values = _readValues();

//     if (!_validate(values)) {
//       return;
//     }

//     setState(() {
//       _isSaving = true;
//       _saveError = null;
//     });

//     try {
//       await widget.onSave?.call(values);

//       if (!mounted) return;

//       if (widget.popAfterSave) {
//         Navigator.of(context).pop(values);
//         return;
//       }

//       setState(() {
//         _isSaving = false;
//       });
//     } catch (error) {
//       if (!mounted) return;

//       setState(() {
//         _isSaving = false;
//         _saveError = '保存失败：$error';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: !_isSaving,
//       child: AlertDialog(
//         title: Text(widget.title),
//         content: _EditorDialogContent(
//           fields: widget.fields,
//           controllers: _controllers,
//           errors: _errors,
//           saveError: _saveError,
//           enabled: !_isSaving,
//           onChanged: _clearFieldError,
//         ),
//         actions: [
//           TextButton(
//             onPressed: _isSaving
//                 ? null
//                 : () {
//                     Navigator.of(context).pop();
//                   },
//             child: Text(widget.cancelText),
//           ),
//           FilledButton(
//             onPressed: _isSaving ? null : _handleSave,
//             child: _isSaving
//                 ? const SizedBox.square(
//                     dimension: 18,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : Text(widget.saveText),
//           ),
//         ],
//       ),
//     );
//   }

//   void _clearFieldError(String fieldKey) {
//     if (_errors[fieldKey] == null && _saveError == null) {
//       return;
//     }

//     setState(() {
//       _errors[fieldKey] = null;
//       _saveError = null;
//     });
//   }
// }

// class _EditorDialogContent extends StatelessWidget {
//   final List<EditorField> fields;
//   final Map<String, TextEditingController> controllers;
//   final Map<String, String?> errors;
//   final String? saveError;
//   final bool enabled;
//   final ValueChanged<String> onChanged;

//   const _EditorDialogContent({
//     required this.fields,
//     required this.controllers,
//     required this.errors,
//     required this.saveError,
//     required this.enabled,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 480,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             for (var index = 0; index < fields.length; index++) ...[
//               _EditorFieldView(
//                 field: fields[index],
//                 controller: controllers[fields[index].key]!,
//                 errorText: errors[fields[index].key],
//                 enabled: enabled,
//                 onChanged: () {
//                   onChanged(fields[index].key);
//                 },
//               ),
//               if (index != fields.length - 1)
//                 const SizedBox(height: AppSpacing.md),
//             ],
//             if (saveError != null) ...[
//               const SizedBox(height: AppSpacing.md),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   saveError!,
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.error,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _EditorFieldView extends StatelessWidget {
//   final EditorField field;
//   final TextEditingController controller;
//   final String? errorText;
//   final bool enabled;
//   final VoidCallback onChanged;

//   const _EditorFieldView({
//     required this.field,
//     required this.controller,
//     required this.errorText,
//     required this.enabled,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppTextField(
//       controller: controller,
//       label: field.label,
//       hintText: field.hintText,
//       helperText: field.helperText,
//       errorText: errorText,
//       obscureText: field.type == EditorFieldType.password,
//       autofocus: field.autofocus,
//       enabled: enabled && field.enabled,
//       minLines: field.minLines,
//       maxLines: field.maxLines,
//       keyboardType: field.keyboardType,
//       textInputAction: field.textInputAction,
//       onChanged: (_) {
//         onChanged();
//       },
//     );
//   }
// }

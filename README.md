# Glyphora UI

A reusable Flutter UI package intended to keep application pages small and readable.

## Included

- `AppPage`
- `AppSection`
- `AppButton`
- `AsyncButton`
- `AppTextField`
- `EditorField`
- `AppEditorDialog`
- `AppConfirmDialog`
- `AppLoadingView`
- `AppEmptyView`
- `AppErrorView`
- `GlyphoraTheme`
- `AppSpacing`

## Local installation

```yaml
dependencies:
  glyphora_ui:
    path: ../glyphora_ui
```

## Import

```dart
import 'package:glyphora_ui/glyphora_ui.dart';
```

## Example

```dart
final result = await AppEditorDialog.show(
  context,
  title: 'Add note',
  fields: const [
    EditorField.text(
      key: 'title',
      label: 'Title',
    ),
    EditorField.multiline(
      key: 'content',
      label: 'Content',
      minLines: 5,
      maxLines: 10,
    ),
  ],
);

if (result == null) return;

await noteService.addNote(
  title: result['title']!,
  content: result['content']!,
);
```

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glyphora_ui/glyphora_ui.dart';

void main() {
  testWidgets(
    'AppEditorDialog validates required fields',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: FilledButton(
                    onPressed: () {
                      AppEditorDialog.show(
                        context,
                        title: 'Editor',
                        fields: const [
                          EditorField.text(
                            key: 'title',
                            label: 'Title',
                          ),
                        ],
                      );
                    },
                    child: const Text('Open'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('保存'));
      await tester.pump();

      expect(find.text('Title不能为空'), findsOneWidget);
    },
  );
}

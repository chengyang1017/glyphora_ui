import 'package:flutter/material.dart';
import 'package:glyphora_ui/glyphora_ui.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GlyphoraTheme.light(),
      darkTheme: GlyphoraTheme.dark(),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() {
    return _ExampleHomePageState();
  }
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  final List<Map<String, String>> _notes = [];

  Future<void> _addNote() async {
    final result = await AppEditorDialog.show(
      context,
      title: '添加笔记',
      fields: const [
        EditorField.text(
          key: 'title',
          label: '标题',
          autofocus: true,
        ),
        EditorField.multiline(
          key: 'content',
          label: '内容',
          minLines: 5,
          maxLines: 10,
        ),
      ],
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _notes.add(result);
    });
  }

  Future<void> _deleteNote(int index) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: '删除笔记',
      message: '确定删除这条笔记吗？',
      confirmText: '删除',
      isDestructive: true,
    );

    if (!confirmed || !mounted) {
      return;
    }

    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Glyphora UI 示例',
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
      body: _notes.isEmpty
          ? AppEmptyView(
              title: '还没有笔记',
              message: '点击右下角按钮添加第一条笔记。',
              actionText: '添加笔记',
              onAction: _addNote,
            )
          : ListView.separated(
              itemCount: _notes.length,
              separatorBuilder: (_, __) {
                return const SizedBox(height: AppSpacing.sm);
              },
              itemBuilder: (context, index) {
                final note = _notes[index];

                return AppSection(
                  title: note['title'],
                  trailing: IconButton(
                    onPressed: () {
                      _deleteNote(index);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                  child: Text(note['content'] ?? ''),
                );
              },
            ),
    );
  }
}

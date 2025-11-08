import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});
  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final _ctrl = TextEditingController();
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('todos') ?? [];
    setState(() => _tasks = raw.map((e) {
      final parts = e.split('|');
      return {'title': parts[0], 'done': parts[1] == '1'};
    }).toList());
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = _tasks.map((e) => '${e['title']}|${e['done'] ? '1' : '0'}').toList();
    await prefs.setStringList('todos', raw);
  }

  void _add() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() => _tasks.add({'title': _ctrl.text.trim(), 'done': false}));
    _ctrl.clear();
    _persist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo App (Local State)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(child: TextField(controller: _ctrl, decoration: const InputDecoration(labelText: 'Add a task'))),
              IconButton(onPressed: _add, icon: const Icon(Icons.add_circle))
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (_, i) => Dismissible(
                key: ValueKey('todo_$i'),
                background: Container(color: Colors.redAccent),
                onDismissed: (_) { setState(() => _tasks.removeAt(i)); _persist(); },
                child: CheckboxListTile(
                  value: _tasks[i]['done'],
                  title: Text(_tasks[i]['title']),
                  onChanged: (v) { setState(() => _tasks[i]['done'] = v ?? false); _persist(); },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

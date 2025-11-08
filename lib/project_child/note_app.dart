import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesModel extends ChangeNotifier {
  final List<String> notes = [];
  void add(String n) { notes.add(n); notifyListeners(); }
  void removeAt(int i) { notes.removeAt(i); notifyListeners(); }
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotesModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Notes (Provider)")),
        body: Consumer<NotesModel>(
          builder: (_, model, __) => ListView.builder(
            itemCount: model.notes.length,
            itemBuilder: (_, i) => Card(
              child: ListTile(
                title: Text(model.notes[i]),
                trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => model.removeAt(i)),
              ),
            ),
          ),
        ),
        floatingActionButton: Builder(builder: (ctx) {
          final ctrl = TextEditingController();
          return FloatingActionButton(
            onPressed: () {
              showDialog(context: ctx, builder: (_) => AlertDialog(
                title: const Text('New note'),
                content: TextField(controller: ctrl),
                actions: [
                  TextButton(onPressed: () {
                    if (ctrl.text.trim().isNotEmpty) {
                      ctx.read<NotesModel>().add(ctrl.text.trim());
                    }
                    Navigator.pop(ctx);
                  }, child: const Text('Save'))
                ],
              ));
            },
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }
}

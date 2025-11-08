import 'package:flutter/material.dart';
import 'package:baitap_flutter/project_child/chat_ui.dart';
import 'package:baitap_flutter/project_child/expense_tracker.dart';
import 'package:baitap_flutter/project_child/firebase_login.dart';
import 'package:baitap_flutter/project_child/news_app.dart';
import 'package:baitap_flutter/project_child/note_app.dart';
import 'package:baitap_flutter/project_child/photo_gallery.dart';
import 'package:baitap_flutter/project_child/profile_app.dart';
import 'package:baitap_flutter/project_child/reminder_app.dart';
import 'package:baitap_flutter/project_child/todo_app.dart';
import 'package:baitap_flutter/project_child/weather_app.dart';


class HomeMenu extends StatelessWidget {
  final void Function(bool) onDarkChanged;
  final bool isDark;
  const HomeMenu({super.key, required this.onDarkChanged, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = <({String title, IconData icon, Widget page})>[
      (title: '🧱 Profile', icon: Icons.person, page: const ProfileApp()),
      (title: '📚 Todo', icon: Icons.checklist, page: const TodoApp()),
      (title: '🧭 News', icon: Icons.article, page: const NewsApp()),
      (title: '💬 Chat UI', icon: Icons.chat_bubble, page: const ChatUI()),
      (title: '🎨 Notes (Provider)', icon: Icons.note, page: const NoteApp()),
      (title: '🌦 Weather', icon: Icons.cloud, page: const WeatherApp()),
      (title: '💾 Expense (Hive)', icon: Icons.pie_chart, page: const ExpenseTracker()),
      (title: '📸 Photo', icon: Icons.photo, page: const PhotoGallery()),
      (title: '🔔 Reminder', icon: Icons.alarm, page: const ReminderApp()),
      (title: '☁️ Firebase Login', icon: Icons.login, page: const FirebaseLoginApp()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Flutter Projects'),
        actions: [
          Row(children: [
            const Text('Dark'),
            Switch(value: isDark, onChanged: onDarkChanged),
          ])
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final it = items[i];
          return Card(
            elevation: 2,
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => it.page)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(it.icon, size: 40), const SizedBox(height: 8), Text(it.title)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

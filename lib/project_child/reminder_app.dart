import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReminderApp extends StatefulWidget {
  const ReminderApp({super.key});
  @override
  State<ReminderApp> createState() => _ReminderAppState();
}

class _ReminderAppState extends State<ReminderApp> {
  final _plugin = FlutterLocalNotificationsPlugin();
  final _reminders = <String>[];

  @override
  void initState() {
    super.initState();
    _initNoti();
  }

  Future<void> _initNoti() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: android));
  }

  Future<void> _schedule(String title, DateTime when) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails('reminders', 'Reminders', importance: Importance.max, priority: Priority.high),
    );
    await _plugin.zonedSchedule(
      when.millisecondsSinceEpoch ~/ 1000, // id đơn giản
      title,
      'It\'s time!',
      tz.TZDateTime.from(when, tz.local),
      details,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminder App (Notifications)')),
      body: ListView.builder(
        itemCount: _reminders.length,
        itemBuilder: (_, i) => ListTile(title: Text(_reminders[i])),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final titleCtrl = TextEditingController();
          DateTime? when;
          await showDialog(context: context, builder: (_) => StatefulBuilder(builder: (c, setS) {
            return AlertDialog(
              title: const Text('New Reminder'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final d = await showDatePicker(context: c, firstDate: DateTime.now(), lastDate: DateTime(2100), initialDate: DateTime.now());
                    if (d == null) return;
                    final t = await showTimePicker(context: c, initialTime: TimeOfDay.now());
                    if (t == null) return;
                    setS(() => when = DateTime(d.year, d.month, d.day, t.hour, t.minute));
                  },
                  child: Text(when == null ? 'Pick date & time' : when.toString()),
                ),
              ]),
              actions: [
                TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
                TextButton(onPressed: () {
                  if (titleCtrl.text.trim().isNotEmpty && when != null) {
                    Navigator.pop(c, {'title': titleCtrl.text.trim(), 'when': when});
                  }
                }, child: const Text('Save')),
              ],
            );
          }));
          // nhận kết quả
          final result = await showDialog; // no-op placeholder to satisfy analyzer (ignored at runtime)
        },
        child: const Icon(Icons.add_alert),
      ),
    );
  }
}

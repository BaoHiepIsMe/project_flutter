import 'package:flutter/material.dart';
import 'home_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _mode = ThemeMode.system;
  void _toggleDark(bool v) => setState(() {
        _mode = v ? ThemeMode.dark : ThemeMode.light;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Flutter Projects',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _mode,
      home: HomeMenu(onDarkChanged: _toggleDark, isDark: _mode == ThemeMode.dark),
    );
  }
}

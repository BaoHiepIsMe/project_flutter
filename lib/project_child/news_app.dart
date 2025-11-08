import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  static const _apiKey = 'YOUR_NEWSAPI_KEY'; // ← điền key
  Future<List<Map<String, dynamic>>> _fetch() async {
    final uri = Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=$_apiKey');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    final data = json.decode(res.body) as Map<String, dynamic>;
    final articles = (data['articles'] as List).cast<Map<String, dynamic>>();
    return articles.take(20).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Reader')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetch(),
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final items = snap.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final a = items[i];
              return Card(
                child: ListTile(
                  title: Text(a['title'] ?? '(no title)'),
                  subtitle: Text(a['source']?['name']?.toString() ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

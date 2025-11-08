import 'package:flutter/material.dart';

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    final info = [
      const ListTile(leading: Icon(Icons.email), title: Text('hiepndb.22it@vku.udn.vn')),
      const ListTile(leading: Icon(Icons.link), title: Text('github.com/BaoHiepisme')),
      const ListTile(leading: Icon(Icons.location_on), title: Text('Viet Nam')),
    ];

    final skills = [
      'Flutter', 'Dart', 'Firebase', 'REST', 'Clean Architecture'
    ].map((e) => Chip(label: Text(e))).toList();

    final avatar = const CircleAvatar(
      radius: 60, backgroundImage: AssetImage('assets/images/mu.jpg'),
    );

    final about = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hiệp Nguyễn', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Flutter Developer • AI Enthusiast'),
        const SizedBox(height: 16),
        Card(child: Column(children: info)),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: skills),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isWide
            ? Row(children: [
                avatar,
                const SizedBox(width: 24),
                Expanded(child: SingleChildScrollView(child: about)),
              ])
            : SingleChildScrollView(child: Column(children: [
                avatar, const SizedBox(height: 16), about
              ])),
      ),
    );
  }
}

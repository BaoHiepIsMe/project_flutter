import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLoginApp extends StatefulWidget {
  const FirebaseLoginApp({super.key});
  @override
  State<FirebaseLoginApp> createState() => _FirebaseLoginAppState();
}

class _FirebaseLoginAppState extends State<FirebaseLoginApp> {
  bool _inited = false;
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Firebase.initializeApp();
    setState(() => _inited = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_inited) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Login')),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snap) {
          final user = snap.data;
          if (user != null) {
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.verified_user, size: 80),
              Text(user.email ?? '(no email)'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => FirebaseAuth.instance.signOut(), child: const Text('Logout'))
            ]));
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(onPressed: () async {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text.trim(), password: _pass.text.trim());
                }, child: const Text('Login')),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: () async {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text.trim(), password: _pass.text.trim());
                }, child: const Text('Register')),
              ]),
            ]),
          );
        },
      ),
    );
  }
}

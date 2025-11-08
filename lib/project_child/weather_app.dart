import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});
  static const _apiKey = 'YOUR_OPENWEATHER_KEY'; // ← điền key

  Future<Map<String, dynamic>> _fetchWeather() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location service disabled');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }

    final pos = await Geolocator.getCurrentPosition();
    final uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather'
        '?lat=${pos.latitude}&lon=${pos.longitude}&units=metric&appid=$_apiKey');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    return json.decode(res.body) as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchWeather(),
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final w = snap.data!;
          final city = w['name'];
          final temp = w['main']?['temp']?.toString();
          final desc = (w['weather'] as List).first['description'];
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.cloud, size: 96),
            Text('$temp °C', style: const TextStyle(fontSize: 32)),
            Text('$city — $desc')
          ]));
        },
      ),
    );
  }
}

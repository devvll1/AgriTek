import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  String weather = 'Loading...';
  String location = 'Fetching location...';
  double temperature = 0;
  int humidity = 0;
  double windSpeed = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();
    _fetchWeather(position.latitude, position.longitude);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _fetchWeather(double lat, double lon) async {
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print('API Response: $data');  // Debugging purpose

      if (mounted) {
        setState(() {
          weather = 'Clear';  // OpenMeteo provides weather codes, you can map them to descriptions.
          location = '${data['latitude']}, ${data['longitude']}';
          temperature = data['current_weather']['temperature'];
          humidity = data['hourly']['humidity_2m']?[0] ?? 0;
          windSpeed = data['current_weather']['windspeed'];
        });
      }
    } else {
      print('Failed to load weather data: ${response.statusCode}');
      if (mounted) {
        setState(() {
          weather = 'Failed to load weather data';
        });
      }
    }
  }

  @override
  void dispose() {
    // Perform any necessary cleanup here.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              location,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              '$temperature°C',
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              weather,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.air, size: 30),
                    const SizedBox(height: 5),
                    Text('$windSpeed km/h'),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.water_drop, size: 30),
                    const SizedBox(height: 5),
                    Text('$humidity%'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _getCurrentLocation(),
              child: const Text('Refresh Weather'),
            ),
          ],
        ),
      ),
    );
  }
}

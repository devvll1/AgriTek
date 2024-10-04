import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import for date formatting

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
  double lat = 0;
  double lon = 0;
  String currentTime = ''; // Add a field for the current time
  String currentDate = ''; // Add a field for the current date

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _updateTime(); // Fetch the time when the widget is initialized
  }

  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();
    lat = position.latitude;
    lon = position.longitude;
    _fetchWeather(lat, lon);
    _fetchLocationName(lat, lon);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

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

      if (mounted) {
        setState(() {
          weather = 'Partly Cloudy'; // Example description
          temperature = data['current_weather']['temperature'];
          humidity = data['hourly']['relativehumidity_2m']?[0] ?? 0;
          windSpeed = data['current_weather']['windspeed'];
          _updateTime(); // Update the time whenever we fetch the weather data
        });
      }
    } else {
      if (mounted) {
        setState(() {
          weather = 'Failed to load weather data';
        });
      }
    }
  }

 Future<void> _fetchLocationName(double lat, double lon) async {
  final url =
      'https://api.opencagedata.com/geocode/v1/json?q=$lat+$lon&key=269b80706cd84223a9ac0155bb6b285c'; // Replace with your actual API key

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (mounted) {
      setState(() {
        // Extract the necessary components
        final components = data['results'][0]['components'];
        String formattedLocation = '';

        // Include city and province (or state)
        if (components['city'] != null) {
          formattedLocation += components['city'] + ', ';
        } else if (components['town'] != null) {
          // Fallback to town if city is not available
          formattedLocation += components['town'] + ', ';
        }

        if (components['state'] != null) {
          formattedLocation += components['state'];
        } else if (components['region'] != null) {
          // Fallback to region if state is not available
          formattedLocation += components['region'];
        }

        // Remove trailing comma and space if necessary
        formattedLocation = formattedLocation.replaceAll(RegExp(r',\s*$'), '');

        location = formattedLocation.isNotEmpty ? formattedLocation : 'Unknown location';
        _updateTime(); // Update the time when location data is fetched
      });
    }
  } else {
    if (mounted) {
      setState(() {
        location = 'Unknown location';
      });
    }
  }
}

int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on the selected index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        // Navigate to Forums or any other page
        break;
      case 2:
        Navigator.pushNamed(context, '/weather');
        break;
    }
  }


  // Function to update the current time
  void _updateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMM').format(now); // e.g., "Monday, 4 Oct"

    setState(() {
      currentTime = '${now.hour}:${now.minute.toString().padLeft(2, '0')}'; // Format time as HH:MM
      currentDate = formattedDate; // Add formatted date
    });
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Background image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'), // Add your background image
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: [
            // Header with tabs
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Weather',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Market',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Weather Card
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity, // Set width to full
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      weather,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      currentDate, // Display current date
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      currentTime, // Display current time
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      '${temperature.toStringAsFixed(0)}°C',
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(temperature * 1.8 + 32).toStringAsFixed(1)}°F',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            // Wind and Humidity Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity, // Set width to full
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(Icons.air, size: 30),
                            const SizedBox(height: 5),
                            Text(
                              '$windSpeed km/h',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(Icons.water_drop, size: 30),
                            const SizedBox(height: 5),
                            Text(
                              '$humidity%',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Forecast Report Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Forecast
                },
                child: const Text('Forecast Report'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Modules',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          label: 'Forums',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Updates',
        ),
      ],
    ),
  );
}
}

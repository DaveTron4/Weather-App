import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart' as weather_model;
import 'package:weather_app/models/weather_model_weatherlink.dart';
import 'package:weather_app/pages/home.dart';
import 'package:weather_app/pages/local.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/services/weather_service_link.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherState();
}

class _WeatherState extends State<WeatherPage> {
  // api key
  final _weatherService =
      WeatherService(dotenv.env['API_KEY_WEATHER'] ?? 'default_value_1');
  weather_model.Weather? _weather;

  final _weatherServiceLink = WeatherServiceLink(
      dotenv.env['API_KEY_WEATHER_LINK'] ?? 'default_value_1');
  WeatherLink? _weatherLink;

  late bool _is24HourFormat = false;

  String getFormattedDateTime(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    if (_is24HourFormat) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}, ${dateTime.month}/${dateTime.day}/${dateTime.year}';
    } else {
      // Convert 24-hour format to 12-hour format
      int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      String period = dateTime.hour >= 12 ? 'PM' : 'AM';
      return '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period, ${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }

  late int _lastFetchTimestamp = 0;
  String fetchDataString = '';

  // fetch weather
  _fetchWeather(String measure) async {
    // Get the current timestamp
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    // Check if 5 minutes have passed since the last fetch
    if (currentTimestamp - _lastFetchTimestamp >= 5 * 60 * 1000) {
      // 5 minutes in milliseconds
      print('first call');
      fetchDataString = 'fetching data...';
      // Update the last fetch timestamp
      _lastFetchTimestamp = currentTimestamp;

      // get the current city
      String cityName = await _weatherService.getCurrentCity();

      // get weather for city
      try {
        final weather = await _weatherService.getWeather(cityName, measure);
        final weatherLink = await _weatherServiceLink.getWeather();
        setState(() {
          _weather = weather;
          _weatherLink = weatherLink;
        });
      }
      // any errors
      catch (e) {
        // ignore: avoid_print
        print(e);
      }
    } else {
      fetchDataString = 'wait 5 mins to call again';
      print('cant');
    }
  }

  _changeMeasure(String measure) async {
    print('first call');
    fetchDataString = 'fetching data...';

    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName, measure);
      final weatherLink = await _weatherServiceLink.getWeather();
      setState(() {
        _weather = weather;
        _weatherLink = weatherLink;
      });
    }
    // any errors
    catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  int _selectedIndex = 0;
  String measure = 'imperial';
  String iconMeasure = 'F';

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather(measure);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.amber,
          selectedItemColor: Colors.black,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: _navigateBottomBar,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'local'),
          ]),
      appBar: AppBar(
        title: Text(
            _weather != null
                ? getFormattedDateTime(_weather!.time)
                : 'Loading time..',
            style: const TextStyle(fontSize: 25, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 98, 197, 247),
        actions: <Widget>[
          PopupMenuButton<int>(
            iconColor: const Color.fromARGB(255, 255, 255, 255),
            color: Colors.amber,
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(value: 0, child: Text('Fahrenheit')),
              const PopupMenuItem<int>(value: 1, child: Text('Celsius')),
              const PopupMenuItem<int>(value: 2, child: Text('12Hr Format')),
              const PopupMenuItem<int>(value: 3, child: Text('24Hr Format')),
            ],
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 69, 10, 2),
      body: Container(
        // Use Container for background gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 98, 197, 247), // Start color
              Color.fromARGB(255, 16, 103, 232), // End color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.8], // Adjust stops as needed
          ),
        ),
        child: _selectedIndex == 0
            ? UserHome(
                weather: _weather,
                weatherLink: _weatherLink,
                measure: measure,
                iconMeasure: iconMeasure)
            : UserLocal(weatherLink: _weatherLink),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchWeather(measure);
          final snackBar = SnackBar(
            content: Text(fetchDataString,
                style: const TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromARGB(255, 58, 1, 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        backgroundColor: Colors.amber,
        shape: const CircleBorder(eccentricity: BorderSide.strokeAlignCenter),
        splashColor: Colors.amber[300],
        child: const Icon(Icons.sync, size: 40, color: Colors.black),
      ),
    );
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        measure = 'imperial';
        iconMeasure = 'F';
        _changeMeasure(measure);
      case 1:
        measure = 'metric';
        iconMeasure = 'C';
        _changeMeasure(measure);
      case 2:
        _is24HourFormat = false;
      case 3:
        _is24HourFormat = true;
    }
    setState(() {});
  }
}

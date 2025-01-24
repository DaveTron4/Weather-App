import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/models/weather_model_weatherlink.dart';

class UserHome extends StatelessWidget {
  final Weather? weather;
  final WeatherLink? weatherLink;
  final String measure;
  final String iconMeasure;

  const UserHome({
    super.key,
    required this.weather,
    required this.weatherLink,
    required this.measure,
    required this.iconMeasure,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: Colors.amber),
          Text(
            weather?.cityName ?? "loading city..",
            style: const TextStyle(fontSize: 35, color: Colors.white),
          ),
          const SizedBox(height: 30),
          Lottie.asset(
              getWeatherAnimation(weather?.mainCondition, weather?.timeOfDay)),
          Text(
            '${weather?.temperature.round()}°$iconMeasure | ${weatherLink?.temperature.round()}°F',
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
          Text(
            weather?.mainCondition ?? '',
            style: const TextStyle(fontSize: 35, color: Colors.white),
          ),
        ],
      ),
    );
  }

  String getWeatherAnimation(String? mainCondition, String? timeOfDay) {
    if (timeOfDay == null) return 'assets/sunny.json';

    if (timeOfDay.endsWith('d')) {
      if (mainCondition == null) return 'assets/sunny.json';

      switch (mainCondition.toLowerCase()) {
        case 'clouds':
        case 'mist':
        case 'smoke':
        case 'haze':
        case 'dust':
        case 'fog':
          return 'assets/cloud.json';
        case 'rain':
        case 'drizzle':
        case 'shower rain':
          return 'assets/rain.json';
        case 'thunderstorm':
          return 'assets/thunder.json';
        default:
          return 'assets/sunny.json';
      }
    } else if (timeOfDay.endsWith('n')) {
      if (mainCondition == null) return 'assets/moon.json';
      switch (mainCondition.toLowerCase()) {
        case 'clouds':
        case 'mist':
        case 'smoke':
        case 'haze':
        case 'dust':
        case 'fog':
          return 'assets/cloud_moon.json';
        case 'rain':
        case 'drizzle':
        case 'shower rain':
          return 'assets/rain_moon.json';
        case 'thunderstorm':
          return 'assets/thunder.json';
        default:
          return 'assets/moon.json';
      }
    } else {
      return 'assets/sunny.json';
    }
  }
}

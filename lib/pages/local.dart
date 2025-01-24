import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model_weatherlink.dart';

class UserLocal extends StatelessWidget {
  final WeatherLink? weatherLink;

  const UserLocal({
    super.key,
    required this.weatherLink,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          'Piedmont Weather',
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
        const SizedBox(height: 30),
        Text(
          'Temperature: ${weatherLink?.temperature.round()}°F',
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          'Humidity: ${weatherLink?.humidity}%',
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          'Wind Speed: ${weatherLink?.windSpeed} mph',
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          'Wind Gust: ${weatherLink?.windGusting} mph',
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          'Rainfall(15min): ${weatherLink?.rainFall15min} in',
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          'Rainfall(24hr): ${weatherLink?.rainFall24Hr} in',
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        const SizedBox(height: 20),
      ],
    ));
  }
}
